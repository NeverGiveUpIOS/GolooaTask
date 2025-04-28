//
//  MineAPI.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/8/8.
//



enum TradeLogDetailScene: Int {
    case chore           = 0        // 任务
    case agent           = 1        // 代理
    case ensure          = 2        // 保证金
    case coin            = 3        // 金币
}

extension NetAPI {
    
    struct MineAPI {
        static let denyList = APIItem("/user/friend/blockList", des: "黑名单列表", m: .post)
        static let parentBind = APIItem("/user/invite/bindParent", des: "绑定上级", m: .post)
        static let invalidUser = APIItem("/user/user/invalid", des: "注销账户", m: .post)
        static let tradeLogDetail = APIItem("/trade/account/log", des: "账户明细", m: .get)
        static let choreRecord = APIItem("/user/task-receive/record", des: "我的任务记录", m: .get)
        static let myChoreDetail = APIItem("/user/task-receive/recordDetail", des: "我领取的任务详情", m: .get)
        static let publishList = APIItem("/user/task/publishList", des: "发布列表", m: .get)
        static let publishDetail = APIItem("/user/task/publishDetail", des: "发布任务详情", m: .get)
        static let publishSettle = APIItem("/user/task/settle", des: "发布任务结算", m: .post)
        static let choreAppealDetail = APIItem("/user/task/appealDetail", des: "申诉数据详情获取", m: .get)
        static let choreAppealSubmit = APIItem("/user/task/appeal", des: "发布任务提交申诉", m: .post)
    }
}

struct MineReq {
    
    static func parentBind(_ code: String, completion: ((Bool, String?) -> Void)?) {
        NetAPI.MineAPI.parentBind.reqToJsonHandler(parameters: ["inviteCode": code], success: { originalData in
            if let status = originalData.json["status"] as? String, status == "OK" {
                completion?(true, originalData.json["msg"] as? String)
            } else {
                completion?(false, originalData.json["msg"] as? String)
            }
        }, failed: { error in
            completion?(false, error.localizedDescription)
        })
    }
        
    static func denyList(_ page: Int = 1, size: Int = 20, completion: @escaping (_ usr: [DenyListModel]) -> Void) {
        var param = [String: Any]()
        param["page.current"] = page
        param["page.size"] = size
        NetAPI.MineAPI.denyList.reqToListHandler(parameters: param, model: DenyListModel.self) { model, _ in
            completion(model)
        } failed: { error in
            completion([])
            ToastHud.showToastAction(message: error.localizedDescription)
        }
    }
    
    static func invalidUser(_ completion: ((Bool, String?) -> Void)?) {
        NetAPI.MineAPI.invalidUser.reqToJsonHandler(parameters: nil, success: { originalData in
            if let status = originalData.json["status"] as? String {
                if status == "OK" {
                    completion?(true, originalData.json["msg"] as? String)
                }
            } else {
                if let msg = originalData.json["msg"] as? String {
                    ToastHud.showToastAction(message: msg)
                }
            }
        }, failed: { error in
            if error.status == "undone_task" {
                completion?(false, error.localizedDescription)
                return
            }
            ToastHud.showToastAction(message: error.localizedDescription)
        })
    }
    
    static func tradeLogDetail(_ scene: TradeLogDetailScene, page: Int = 1, size: Int = 20, completion: @escaping (([PouchDetailModel], HomeBalanceAccount?, Bool, String?) -> Void)) {
        var param = [String: Any]()
        param["accountType"] = scene.rawValue
        param["page.current"] = page
        param["page.size"] = size
        NetAPI.MineAPI.tradeLogDetail.reqToListHandler(parameters: param, model: PouchDetailModel.self) { list, json in
            if let extra = json["extra"] as? [String: Any], let model = HomeBalanceAccount.deserialize(from: extra, designatedPath: "account") {
                completion(list, model, true, nil)
            } else {
                completion(list, nil, true, nil)
            }
        } failed: { error in
            completion([], nil, false, error.localizedDescription)
        }
    }
    
    static func choreRecord(_ scene: ChoreRecordScene, page: Int = 0, size: Int = 20, completion: @escaping (([HomeListModel]) -> Void)) {
        var param = [String: Any]()
        param["status"] = scene.value
        param["page.current"] = page
        param["page.size"] = size
        NetAPI.MineAPI.choreRecord.reqToListHandler(parameters: param, model: HomeListModel.self) { list, _ in
            completion(list)
        } failed: { error in
            completion([])
            ToastHud.showToastAction(message: error.localizedDescription)
        }
    }
    
    static func publishList(_ scene: ChorePublishScene, page: Int = 0, size: Int = 20, completion: @escaping (([HomeListModel]) -> Void)) {
        var param = [String: Any]()
        param["status"] = scene.value
        param["page.current"] = page
        param["page.size"] = size
        NetAPI.MineAPI.publishList.reqToListHandler(parameters: param, model: HomeListModel.self) { list, _ in
            completion(list)
        } failed: { error in
            completion([])
            ToastHud.showToastAction(message: error.localizedDescription)
        }
    }
    
    static func myChoreDetail(_ id: Int, page: Int = 0, size: Int = 20, completion: @escaping (([ChoreRecordModel], HomeListModel?) -> Void)) {
        var param = [String: Any]()
        param["taskId"] = id
        param["page.current"] = page
        param["page.size"] = size
        NetAPI.MineAPI.myChoreDetail.reqToListHandler(parameters: param, model: ChoreRecordModel.self) { list, json in
            if let extra = json["extra"] as? [String: Any], let model = HomeListModel.deserialize(from: extra, designatedPath: "task") {
                completion(list, model)
            } else {
                completion(list, nil)
            }
        } failed: { error in
            completion([], nil)
            ToastHud.showToastAction(message: error.localizedDescription)
        }

    }
    
    static func publishDetail(_ id: Int, page: Int = 0, size: Int = 20, completion: @escaping (([ChorePublishDetailModel], HomeListModel?) -> Void)) {
        var param = [String: Any]()
        param["taskId"] = id
        param["page.current"] = page
        param["page.size"] = size
        NetAPI.MineAPI.publishDetail.reqToListHandler(parameters: param, model: ChorePublishDetailModel.self) { list, json in
            if let extra = json["extra"] as? [String: Any], let model = HomeListModel.deserialize(from: extra, designatedPath: "task") {
                completion(list, model)
            } else {
                completion(list, nil)
            }
        } failed: { error in
            completion([], nil)
            ToastHud.showToastAction(message: error.localizedDescription)
        }
    }
    
    static func publishSettle(_ id: Int, date: String, completion: ((Bool, String?) -> Void)?) {
        var param = [String: Any]()
        param["id"] = id
        param["settleDate"] = date
        NetAPI.MineAPI.publishSettle.reqToJsonHandler(parameters: param, success: { originalData in
            completion?(true, originalData.json["msg"] as? String)
        }, failed: { error in
            if error.status == "less_deposit" {
                completion?(false, error.localizedDescription)
            } else {
                ToastHud.showToastAction(message: error.localizedDescription)
            }
        })
    }
    
    static func choreAppealDetail(_ id: Int, date: String, completion: ((HomeListModel) -> Void)?) {
        var param = [String: Any]()
        param["id"] = id
        param["settleDate"] = date
        NetAPI.MineAPI.choreAppealDetail.reqToModelHandler(parameters: param, model: HomeListModel.self, success: { model, json in
            completion?(model)
            if let msg = json["msg"] as? String {
                ToastHud.showToastAction(message: msg)
            }
        }, failed: { error in
            ToastHud.showToastAction(message: error.localizedDescription)
        })
    }

    static func choreAppealSubmit(_ id: Int, date: String, content: String, completion: ((Bool, String?) -> Void)?) {
        var param = [String: Any]()
        param["id"] = id
        param["settleDate"] = date
        param["reason"] = content
        NetAPI.MineAPI.choreAppealSubmit.reqToJsonHandler(parameters: param, success: { originalData in
            completion?(true, originalData.json["msg"] as? String)
        }, failed: { error in
            ToastHud.showToastAction(message: error.localizedDescription)
        })
    }
}
