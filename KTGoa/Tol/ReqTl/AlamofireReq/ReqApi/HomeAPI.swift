//
//  HomeAPI.swift
//  Golaa
//
//  Created by duke on 2024/5/14.
//

import UIKit

extension NetAPI {
    struct HomeAPI { 
        static let taskData = APIItem("/user/task/income", des: "任务广场数据", m: .get)
        static let balance = APIItem("/trade/account/balance", des: "我的账户余额", m: .get)
        static let taskList = APIItem("/user/task/list", des: "任务列表", m: .get)
        static let auth = APIItem("/user/user/publishAuth", des: "发布者认证", m: .post)
        static let publishConfig = APIItem("/user/task/config", des: "任务发布配置", m: .get)
        static let publish = APIItem("/user/task/create", des: "发布任务", m: .post)
        static let taskDeac = APIItem("/user/task/detail", des: "任务详情", m: .get)
        static let getTaskConfig = APIItem("/user/task-receive/config", des: "任务领取配置", m: .get)
        static let receiveTask = APIItem("/user/task-receive/confirm", des: "领取任务", m: .post)
        static let publishDesc = APIItem("/user/task/viewPublish", des: "查看发布者", m: .get)
        static let myTaskList = APIItem("/user/task/my", des: "我的任务列表", m: .get)
        static let friendList = APIItem("/user/friend/list", des: "我的好友列表", m: .get)
        static let groupList = APIItem("/im/group/list", des: "群列表", m: .get)
        static let consult = APIItem("/user/task/consult", des: "咨询", m: .post)
        static let shareTask = APIItem("/user/task/share", des: "任务分享", m: .post)
        static let publishCheck = APIItem("/user/task/createCheck", des: "发布前检查", m: .get)
        static let makeupDeposit = APIItem("/user/task/supplyDeposit", des: "补交保证金数据获取", m: .get)
    }
}

struct HomeReq {
    
    /// "任务列表"
    static func getTaskData(_ params: [String: Any], completion: @escaping (_ list: [HomeListModel]) -> Void) {
        NetAPI.HomeAPI.taskList.reqToListHandler(parameters: params, model: HomeListModel.self) { list, _ in
            completion(list)
        } failed: { _ in
            completion([])
        }
    }
}
