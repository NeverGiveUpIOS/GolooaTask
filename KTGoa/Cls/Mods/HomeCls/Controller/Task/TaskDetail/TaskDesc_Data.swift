//
//  TaskDesc_Data.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/8/7.
//

import Foundation

extension TaskDescViewController {
    
    func mutateLoadTaskDesc(_ id: String) {
        
        var params: [String: Any] = [:]
        params["id"] = id
        
        NetAPI.HomeAPI.taskDeac.reqToModelHandler(parameters: params, model: TaskDescModel.self) { [weak self] model, _ in
            self?.descModel = model
            self?.bind(model)
            
        } failed: { error in
            print("error: \(error)")
        }
    }
    
    /// 咨询
    func mutateConsultResult() {
        guard let model = self.model else { return }
        var params: [String: Any] = [:]
        params["id"] = model.id
        NetAPI.HomeAPI.consult.reqToJsonHandler(parameters: params, success: { [weak self] _ in
            guard let self = self else { return }
            guard let model = self.model else { return }
            RoutinStore.push(.singleChat, param: model.userId)
            FlyerLibHelper.log(.enterSingleTalkScreen, source: "0")
        }, failed: { error in
            print("error: \(error)")
        })
        
    }
    
    func bottomClickReq() {
        
        guard let model = model else { return }
        if model.isStart, model.status == 2, !model.isOwr {
            if model.recStatus == .canRec { // 领取任务
                debugPrint("点击了领取任务")
                if GlobalHelper.shared.inEndGid {
                    self.mutateReceiveTask(model: model)
                } else {
                    RoutinStore.push(.getTask, param: model)
                    FlyerLibHelper.log(.getTaskClick)
                }
            } else if model.recStatus == .unrec { // 抢光了
                ToastHud.showToastAction(message: "taskIsFull".homeLocalizable())
            } else { // 已领取
                RoutinStore.push(.choreDetail, param: model.id)
            }
        } else {
            if model.isOwr { // 是发布者，跳转发布任务详情
                RoutinStore.push(.chorePublishDetail, param: model.id)
            } else {
                RoutinStore.push(.choreDetail, param: model.id)
            }
            debugPrint("点击了查看任务数据详情")
        }
    }
    
    func mutateReceiveTask(model: TaskDescModel, receiveCount: Int = 1) {
        
        var params: [String: Any] = [:]
        params["taskId"] = model.id
        params["receiveCount"] = receiveCount
        
        NetAPI.HomeAPI.receiveTask.reqToJsonHandler(parameters: params) { originalData in
            if let traLink = originalData.data["traceLink"] as? String {
                model.traLink = traLink
            }
            FlyerLibHelper.log(.enterGetTaskSuccessResult, result: true)
            RoutinStore.dismiss(animated: false)
            ToastHud.showToastAction(message: "claimSuccess".homeLocalizable())
        } failed: { error in
            FlyerLibHelper.log(.enterGetTaskSuccessResult, result: false)
            print("error: \(error)")
        }
        
        
    }
    
}
