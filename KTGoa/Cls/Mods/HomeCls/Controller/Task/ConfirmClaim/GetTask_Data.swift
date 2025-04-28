//
//  GetTask_Data.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/8/7.
//

import Foundation

extension GetTaskViewController {
    
     func mutateLoadConfig(_ surCount: Int) {
            NetAPI.HomeAPI.getTaskConfig.reqToModelHandler(parameters: nil, model: GetTaskConfig.self) { [weak self] model, _ in
                self?.loadConfigResult(model, surCount)
            } failed: { error in
                print("error: \(error)")
            }
        }
    
    private func loadConfigResult(_ model: GetTaskConfig, _ surCount:Int) {
        
        let registDataSource = config?.receiveArr.map { item in
            let model = PayDepositModel(value: "\(item)", isEnabled: item <= surCount)
            return model
        }
        var channelDataSource = config?.channelsArr.map({ item in
            let model = PayDepositModel(value: item.label)
            return model
        })
        var fansDataSource = config?.fansArr.map({ item in
            let model = PayDepositModel(value: item.label)
            return model
        })
        self.registDataSource = registDataSource ?? []
        self.channelDataSource = channelDataSource ?? []
        self.fansDataSource = fansDataSource ?? []
        chatDataSource = config?.chatHomeArr ?? []
        
        bind(model)
    }
}
