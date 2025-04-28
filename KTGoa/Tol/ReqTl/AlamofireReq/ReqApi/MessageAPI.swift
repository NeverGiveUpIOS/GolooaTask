//
//  MessageAPI.swift
//  Golaa
//
//  Created by chenkaisong on 2024/5/20.
//

extension NetAPI {
    
    struct MessageAPI {
        static let userFriendBlock = APIItem("/user/friend/block", des: "添加/取消 拉黑", m: .post)
        static let userSearch = APIItem("/user/user/search", des: "用户搜索")
        static let addFriend = APIItem("/user/friend/addFriend", des: "申请好友", m: .post)
        static let addFriendLogList = APIItem("/user/friend/addFriendLogList", des: "新的好友【分页】")
        static let friendVerify = APIItem("/user/friend/verify", des: "好友申请同意/拒绝", m: .post)
        static let giftList = APIItem("/trade/gift/list", des: "礼物列表")
        static let sendGift = APIItem("/trade/gift/send", des: "赠送礼物", m: .post)
        static let accuseType = APIItem("/user/complain/category", des: "举报类型", m: .get)
        static let accuse = APIItem("/user/complain/add", des: "举报类型", m: .post)
    }
}

struct MessageReq {
    
    /// 添加/取消 拉黑
    /// - Parameters:
    ///   - toUserId: 被拉黑ID
    ///   - status: 状态：1=拉黑，0=取消
    static func userFriendBlock(_ toUserId: String, 
                                _ status: Int,
                                completion: @escaping () -> Void) {
        NetAPI.MessageAPI.userFriendBlock.reqToJsonHandler(parameters: ["toUserId": toUserId, "status": status]) { _ in
            ToastHud.showToastAction(message: status == 1 ? "blocked".msgLocalizable() : "unblocked".msgLocalizable())
            completion()
        } failed: { error in
            ToastHud.showToastAction(message: error.localizedDescription)
        }
    }
    
    /// 用户搜索
    static func userSearch(_ nickname: String, 
                           completion: @escaping (_ list: [GUsrInfo]) -> Void) {
        NetAPI.MessageAPI.userSearch.reqToListHandler(false, parameters: ["nickname": nickname], model: GUsrInfo.self) { list, _ in
            completion(list)
        } failed: { error in
            ToastHud.showToastAction(message: error.localizedDescription)
        }
    }
    
    /// 申请好友
    static func addFriend(_ toUserId: String,
                          completion: @escaping () -> Void) {
        NetAPI.MessageAPI.addFriend.reqToJsonHandler(parameters: ["toUserId": toUserId]) { _ in
            completion()
        } failed: { error in
            ToastHud.showToastAction(message: error.localizedDescription)
        }
    }
    
    /// 好友申请同意/拒绝
    static func friendVerify(_ fromUserId: String,
                             _ status: Int,
                             completion: @escaping () -> Void) {
        NetAPI.MessageAPI.friendVerify.reqToJsonHandler(parameters: ["fromUserId": fromUserId, "status": status]) { _ in
            completion()
        } failed: { error in
            ToastHud.showToastAction(message: error.localizedDescription)
        }
    }
    
    /// "新的好友【分页】"
    static func addFriendLogList(page: Int, 
                                 size: Int,
                                 _ completion: @escaping (_ list: [NewFriendListModel]) -> Void) {
        NetAPI.MessageAPI.addFriendLogList.reqToListHandler(false, parameters: ["page.current": page, "page.size": size], model: NewFriendListModel.self) { list, _ in
            completion(list)
        } failed: { error in
            ToastHud.showToastAction(message: error.localizedDescription)
            completion([])
        }
    }
    
    /// 邀请好友进群
    static func invite(_ groupId: String, _ userIds: String, completion: ((_ error: NetworkError?) -> Void)?) {
        NetAPI.GroupAPI.invite.reqToJsonHandler(parameters: ["groupId": groupId, "userIds": userIds]) { _ in
            completion?(nil)
        } failed: { error in
            completion?(error)
            ToastHud.showToastAction(message: error.localizedDescription)
        }
    }
    
    /// 申请入群
    static func apply(_ groupId: String, _ remark: String, completion: @escaping () -> Void) {
        NetAPI.GroupAPI.apply.reqToJsonHandler(parameters: ["groupId": groupId, "remark": remark]) { _ in
            completion()
        } failed: { error in
            ToastHud.showToastAction(message: error.localizedDescription)
        }
    }
    
    /// 禁言、解禁用户 muteType 0：否 1是
    static func muteUser(_ groupId: String, muteUserId: String, _ muteType: String, completion: @escaping () -> Void) {
        NetAPI.GroupAPI.muteUser.reqToJsonHandler(parameters: ["groupId": groupId,
                                                                "muteUserId": muteUserId,
                                                                "muteType": muteType]) { _ in
            completion()
        } failed: { error in
            ToastHud.showToastAction(message: error.localizedDescription)
        }
    }
    
    /// 创群
    static func create(_ name: String, 
                       joinMode: String = "0",
                       _ icon: String, completion: @escaping () -> Void) {
        NetAPI.GroupAPI.create.reqToJsonHandler(parameters: ["name": name,
                                                              "joinMode": joinMode,
                                                              "icon": icon]) { _ in
            completion()
        } failed: { error in
            ToastHud.showToastAction(message: error.localizedDescription)
        }
    }
    
    /// groupList
    static func groupList(_ dict: [String: Any],
                          completion: @escaping (_ list: [NIMGroupModel]) -> Void,
                          failCom: @escaping () -> Void) {
        NetAPI.GroupAPI.groupList.reqToListHandler(parameters: dict, model: NIMGroupModel.self) { list, _ in
            completion(list)
        } failed: { _ in
            failCom()
        }
    }
    
    /// 群校验
    static func groupValidate(completion: @escaping () -> Void) {
        NetAPI.GroupAPI.groupValidate.reqToJsonHandler(parameters: nil) { _ in
            completion()
        } failed: { error in
            if error.callback == "alert" {
                /// 创群限制弹窗
                AlertPopView.show(titles: "tip".globalLocalizable(),
                                  contents: "youHaveReachedTheMaximumNumber".msgLocalizable(),
                                  sures: "iUnderstand".msgLocalizable(),
                                  cacnces: "") {
                } cancelCompletion: {
                }
            }
        }
        
    }
    
    /// 礼物列表
    static func giftList(_ dict: [String: Any], 
                         completion: @escaping (_ list: [GiftItemModel]) -> Void) {
        NetAPI.MessageAPI.giftList.reqToListHandler(parameters: dict, model: GiftItemModel.self) { list, _ in
            completion(list)
        } failed: { _ in
            
        }
    }
    
    /// 发礼物
    static func sendGift(_ dict: [String: Any],
                         completion: @escaping () -> Void) {
        NetAPI.MessageAPI.sendGift.reqToJsonHandler(parameters: dict) { _ in
            completion()
        } failed: { error in
            if error.status == "less_coin" {
                // 表示 金币余额不足
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                     RechargeCoinSheet(source: .gift).show()
                }
            }
        }
    }
    
}
