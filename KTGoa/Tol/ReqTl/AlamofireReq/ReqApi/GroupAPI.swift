//
//  GroupAPI.swift
//  Golaa
//
//  Created by duke on 2024/5/11.
//

import UIKit

extension NetAPI {
    
    struct GroupAPI {
        
        static let create = APIItem("/im/group/add", des: "创建群", m: .post)
        static let info = APIItem("/im/group/info", des: "获取群信息", m: .get)
        static let join = APIItem("/im/group/join", des: "先调join接口，看是否要进群，再根据join结果，看是否进入群申请页", m: .post)
        static let apply = APIItem("/im/group/joinApply", des: "申请入群", m: .post)
        static let update = APIItem("/im/group/update", des: "修改群资料", m: .post)
        static let memberList = APIItem("/im/group-user/list", des: "群成员列表", m: .get)
        static let applyList = APIItem("/im/group/joinApplyList", des: "进群申请记录（分页）", m: .post)
        static let friendList = APIItem("/im/group-user/friendList", des: "搜索群好友列表", m: .get)
        static let invite = APIItem("/im/group/invite", des: "邀请入群", m: .post)
        static let search = APIItem("/im/group/list", des: "搜索群", m: .get)
        static let exit = APIItem("/im/group/exit", des: "退出群", m: .post)
        static let muteUser = APIItem("/im/group/muteUser", des: "禁言、解禁用户", m: .post)
        static let groupList = APIItem("/im/group/list", des: "禁言、解禁用户", m: .get)
        static let remove = APIItem("/im/group/remove", des: "解散群", m: .post)
        static let groupValidate = APIItem("/im/group/groupValidate", des: "群校验", m: .get)
        static let joinVerify = APIItem("/im/group/joinVerify", des: "进群申请审核", m: .post)
        static let removeUser = APIItem("/im/group/removeUser", des: "踢人出群", m: .post)
    }
}

struct GroupReq {
    
    static func disbandGroup(_ groupId: String, _ completion: ((_ error: NetworkError?) -> Void)?) {
        let pars = ["groupId": groupId]
        NetAPI.GroupAPI.remove.reqToJsonHandler(parameters: pars) { _ in
            completion?(nil)
        } failed: { error in
            completion?(error)
        }   
    }
    
    static func applyGroup(_ groupId: String, remark: String, _ completion: ((_ error: NetworkError?) -> Void)?) {
        var pars: [String: Any] = [:]
        pars["remark"] = remark
        pars["groupId"] = groupId
        NetAPI.GroupAPI.apply.reqToJsonHandler(parameters: pars) { _ in
            completion?(nil)
        } failed: { error in
            completion?(error)
        }
    }
    
    static func exitGroup(_ groupId: String, _ completion: ((_ error: NetworkError?) -> Void)?) {
        let pars = ["groupId": groupId]
        NetAPI.GroupAPI.exit.reqToJsonHandler(parameters: pars) { _ in
            completion?(nil)
        } failed: { error in
            completion?(error)
        }
    }
    
    static func joinVerify(_ id: Int, status: Int, _ completion: ((_ error: NetworkError?) -> Void)?) {
        var pars: [String: Any] = [:]
        pars["id"] = id
        pars["status"] = status
        NetAPI.GroupAPI.joinVerify.reqToJsonHandler(parameters: pars) { _ in
            completion?(nil)
        } failed: { error in
            completion?(error)
        }
    }
    
    static func removeUser(_ groupId: String, userId: String, _ completion: ((_ error: NetworkError?) -> Void)?) {
        var pars: [String: Any] = [:]
        pars["userId"] = userId
        pars["groupId"] = groupId
        NetAPI.GroupAPI.removeUser.reqToJsonHandler(parameters: pars) { _ in
            completion?(nil)
        } failed: { error in
            completion?(error)
        }
    }
    
    static func muteUser(_ groupId: String, userId: String, mute: Bool, _ completion: ((_ error: NetworkError?) -> Void)?) {
        var pars: [String: Any] = [:]
        pars["groupId"] = groupId
        pars["muteUserId"] = userId
        pars["muteType"] = mute ? 1 : 0
        NetAPI.GroupAPI.muteUser.reqToJsonHandler(parameters: pars) { _ in
            completion?(nil)
        } failed: { error in
            completion?(error)
        }
    }
    
    static func muteUserAll(_ groupId: String, userId: String, mute: Bool, _ completion: ((_ error: NetworkError?) -> Void)?) {
        var pars: [String: Any] = [:]
        pars["userId"] = userId
        pars["groupId"] = groupId
        NetAPI.GroupAPI.muteUser.reqToJsonHandler(parameters: pars) { _ in
            completion?(nil)
        } failed: { error in
            completion?(error)
        }
    }
    
    static func updateGroup(_ groupId: String,
                            name: String = "",
                            icon: String = "",
                            intro: String = "",
                            _ completion: ((_ error: NetworkError?) -> Void)?) {
        var pars: [String: Any] = [:]
        pars["groupId"] = groupId
        if !icon.isEmpty {
            pars["icon"] = icon
        }
        if !name.isEmpty {
            pars["name"] = name
        }
        if !intro.isEmpty {
            pars["intro"] = intro
        }
        
        NetAPI.GroupAPI.update.reqToJsonHandler(parameters: pars) { _ in
            completion?(nil)
        } failed: { error in
            completion?(error)
        }
    }
}


