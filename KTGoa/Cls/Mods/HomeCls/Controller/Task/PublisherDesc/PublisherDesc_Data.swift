//
//  PublisherDesc_Data.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/8/7.
//

import Foundation

extension PublisherDescViewController {
    
    func mutateLoadPublishDesc() {
        
        var params: [String: Any] = [:]
        params["page.current"] = page
        params["page.size"] = size
        params["userId"] = userId ?? ""
        
        NetAPI.HomeAPI.publishDesc.reqToListHandler(parameters: params, model: HomeListModel.self) { [weak self] list, data in
            guard let self = self else { return }
            let model = PublisherDescModel()
            model.extra = PublisherDescExtra.deserialize(from: data, designatedPath: "extra") ?? PublisherDescExtra()
            var dataArray = model.list
            if page == 1 {
                dataArray.removeAll()
            }
            dataArray.append(contentsOf: list)
            model.list = dataArray
            self.model = model
            self.tableView?.reloadData()
            self.setupEmptyView(self.model?.list.count ?? 0)
            self.endRefreshAndReloadData(self.model?.list.count ?? 0, model.list.count)
            self.bind(model: model)
        } failed: { error in
            print("error: \(error)")
        }
    }
    
    func mutateConsultResult(_ userId: String) {
        
        var params: [String: Any] = [:]
        params["userId"] = userId
        
        NetAPI.HomeAPI.consult.reqToJsonHandler(parameters: params, success: { [weak self] _ in
            guard let self = self else { return }
            guard let model = self.model else { return }
            RoutinStore.push(.singleChat, param: model.extra.user.id)
            FlyerLibHelper.log(.enterSingleTalkScreen, source: "3")
        }, failed: { error in
            print("error: \(error)")
        })
        
    }
    
    func  mutatePublishCheck() {
            NetAPI.HomeAPI.publishCheck.reqToJsonHandler(parameters: nil, success: { _ in
                RoutinStore.push(.publish)
            }, failed: { error in
                if error.status == "deposit_exceed",
                   let extra = error.extra as? [String: Any],
                    let taskId = extra["taskId"] as? Int {
                    MakeupDepositAlert.show(taskId: taskId, date: "", content: error.localizedDescription)
                }
                print("error: \(error)")
            })

    }
    
}
