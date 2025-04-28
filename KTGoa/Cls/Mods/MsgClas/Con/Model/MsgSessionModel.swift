//
//  MsgSessionModel.swift
//  Golaa
//
//  Created by chenkaisong on 2024/5/8.
//

import UIKit

class MsgSessionModel: NSObject {
    
    /// 昵称
    var name = ""
    /// 头像
    var avatar = ""
    /// 消息显示
    var showMessage = ""
    /// 最后一条消息时间戳
    var timestamp: TimeInterval = 0
    var showTime: String = ""
    /// 未读数
    var unreadCount: Int = 0
    /// 当前会话类型
    var sessionType: SessionType?
    /// 最后一条消息id
    var messageId: String = ""
    /// 当前会话id即用户ID或者群组ID
    var sessionId: String = ""
    /// 当前会话
    var curSession: NIMRecentSession?
    /// 最后一条消息
    var lastMessage: NIMMessage?
    /// 最后一条消息 发送者id
    var msgFrom: String = ""
    /// 用户信息
    var user: GUsrInfo?
    /// 用户信息
    var group: MsgGroupInfoModel?
    
    /// 系统通知号
    var sysMsgnumber: YXSystemMsgnumber? {
        if sessionId == YXSystemMsgnumber.sysNoti.notiId {
            return .sysNoti
        } else if sessionId == YXSystemMsgnumber.onleCustomer.customerId {
            return .onleCustomer
        } else if sessionId == YXSystemMsgnumber.newFeiend.newFeiendId {
            return .newFeiend
        } else {
            return .nomal
        }
    }
    
    var sysMsgHead: UIImage? {
        switch sysMsgnumber {
        case .sysNoti:
            return .msgNotice
        case .onleCustomer:
            return .msgCustomer
        case .newFeiend:
            return .msgFriend
        default:
            return sessionType == .singleChat ? .publicDefault : .publicPlaceholder
        }
    }
    
    /// 会话变更类型
    var changeType: SessionChangeTyoe = .nomal
}

/// 云信系统消息号
enum YXSystemMsgnumber {
    case  sysNoti // 系统通知
    case  onleCustomer // 在线客服
    case  newFeiend // 新的好友
    case  nomal

    var notiId: String {
        switch NetAPI.curEnvironment {
        case .pro:
            return "g8"
        case .dev:
            return "t8"
        default:
            return "u8"
        }
    }
    
    var customerId: String {
        switch NetAPI.curEnvironment {
        case .pro:
            return "g9"
        case .dev:
            return "t9"
        default:
            return "u9"
        }
    }
    
    var newFeiendId: String {
        switch NetAPI.curEnvironment {
        case .pro:
            return "g10"
        case .dev:
            return "t10"
        default:
            return "u10"
        }
    }
}

enum SessionChangeTyoe {
    /// 获取会话
    case getSession
    /// 更新会话
    case updateSession
    /// 删除会话
    case deleteSession
    /// 信息会话
    case addASession
    /// 会话消息全部已读
    case allSessionRead
    /// nomal
    case nomal
}
