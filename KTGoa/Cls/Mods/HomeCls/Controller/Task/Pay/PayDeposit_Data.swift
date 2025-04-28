//
//  PayDeposit_Data.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/8/7.
//

import Foundation

extension PayDepositViewController {
    
    /// "任务发布配置"
    @objc func  mutateLoadConfigReuslt() {
        NetAPI.HomeAPI.publishConfig.reqToModelHandler(parameters: nil, model: TaskPublishConfig.self) { [weak self] model, _ in
            self?.config = model
            let zfList: [PayDepositModel] = model.taskList.map { PayDepositModel(value: "\($0)") }
            zfList.first?.isSelected = true
            self?.zfList = zfList
            self?.updateUI(config: model)
            self?.collectionView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                guard let self = self else { return }
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
            }
        } failed: { error in
            print("error: \(error)")
        }
    }
    
    /// "发布任务"
    func mutatePublishResult() {
        
        guard let model = model else { return  }
        
        var params: [String: Any] = [:]
        params["name"] = model.name
        params["link"] = model.link
        params["cover"] = model.cover
        params["price"] = model.price
        params["intro"] = model.intro
        params["startTime"] = model.startTime
        params["endTime"] = model.endTime
        params["steps"] = model.steps
        params["count"] = model.count
        params["platform"] = selectPayType.rawValue
        
        NetAPI.HomeAPI.publish.reqToJsonHandler(parameters: params) { [weak self] _ in
            
            guard let self = self else {
                return
            }
            
            if self.selectPayType == .paymax, let config = self.config,
               let url = config.zfPlatforms.first(where: { $0.type == .paymax })?.url {
                let paymaxUrl = String(format: "%@?type=3&event=pay_deposit_result&source=1", url)
                RoutinStore.push(.webScene(.url(paymaxUrl)))
            } else {
                FlyerLibHelper.log(.payDepositResult, values: ["type": self.selectPayType == .coin ? 2 : 1, "result": 1])
                RoutinStore.dismissRoot(animated: false)
                RoutinStore.push(.publishComple)
            }
        } failed: { error in
            if error.status == "less_coin" {
                // 表示 金币余额不足
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    RechargeCoinSheet(source: .publish).show()
                }
            }
            FlyerLibHelper.log(.payDepositResult, values: ["type": self.selectPayType == .coin ? 2 : 1, "result": 2])
            print("error: \(error)")
        }
        
    }
    
}

