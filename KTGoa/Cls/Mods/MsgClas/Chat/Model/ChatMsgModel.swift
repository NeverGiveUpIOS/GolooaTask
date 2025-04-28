//
//  ChatMsgModel.swift
//  Golaa
//
//  Created by chenkaisong on 2024/5/11.
//

import UIKit

class ChatMsgModel: NSObject {
    
    /// 消息发送状态
    var msgStatus: IMMsgStatue = .sending
    
    /// 消息读取状态
    var msgReadStatue: IMMsgReadStatue = .read
    
    /// 消息发送方向
    var msgDirection: IMMsgDirection = .sender
    
    /// 用户信息
    var userInfo: GUsrInfo?
    
    /// 消息
    var msg: NIMMessage?
    
    /// 当前会话
    var sesstion: NIMSession? {
        return msg?.session
    }

    /// 图片消息
    var imageObject: NIMImageObject?
    
    /// 视频消息
    var videoObject: NIMVideoObject?
    
    /// 语音消息
    var audioObject: NIMAudioObject?
    /// 语音消息状态
    var audioStatue: ChatAudioStatue?
    
    /// 任务消息
    var taskAttachMent: TaskCustomAttachMent?
    
    /// 礼物消息
    var giftAttachMent: GiftCustomAttachMent?
    
    /// 群邀请人进群信息
    var teamInviteModel: ChatTeamNotiMsgModel?
    
    /// 系统消息 扩展内容
    var systemModel: ChatSystemModel?
    
    /// 消息回调
    var callbackModel: ChatCallbackExtModel?
        
    /// 消息类型
    var msgType: IMMsgType?
    
    /// 会话类型
    var sessionType: SessionType?
    
    /// 消息id
    var msgId: String = ""

    /// 消息发送者id
    var msgFrome: String = ""
    
    /// 消息时间
    var msgTime: TimeInterval = 0
    
    /// 是否显示用户头像
    var isShowUserHead = true
    /// 是否时间
    var isShowTime = true
    /// 是否需要长按
    var isLongPress = true
    
    /// 发送方气泡图片
    var sendbubbleImg = "chat_bubble_right"
    /// 接收方气泡图标
    var recivebubbleImg = "chat_bubble_left"

    /// 消息变化类型 用于消息更新, 删除等操作
    var msgChangeType: NimMsgChangeType = .nomal
    
    /// 录音时长
    var audioDuration = 0
}

struct ChatAudioStatue: HandyJSON {
    var statue: IMMsgAudioStatue?
    /// 是否继续播放下一条语音
    var isplayNext: Bool?
}

/// 消息的回调
struct ChatCallbackExtModel: HandyJSON {
    var msg = ""
    var status = ""
    var code: NimMsgCallbackType = .other
}

/// 系统通知消息
struct ChatSystemModel: HandyJSON {
    var color = ""
    var highlight = ""
    var url = ""
    var type: ChatSystemjumpType = .highlight
}

enum ChatSystemjumpType: Int, HandyJSONEnum {
    case highlight = 0 // 仅高亮 无需调整
    case jumpApp = 1 // 跳转APP
    case jumpH5 = 2 // 跳转H5
    case tipLabel = 126 // 撤回消息的tip标记
}

enum NimMsgChangeType {
    /// 消息即将发送
    case willSendMsg
    /// 消息更新
    case updateMsg
    /// 消息撤回
    case revokeMsg
    /// 收到消息回执
    case receiptsMsg
    /// 获取消息
    case getMsgs
    /// 收到消息
    case reciveMsgs
    /// 默认
    case nomal
}

enum NimMsgCallbackType: Int, HandyJSONEnum {
    /// 存在拉黑
    case black = 20004
    /// 群禁用
    case groupDisabled = 20010
    /// 群解散
    case groupdissolve = 20012
    /// 其他
    case other
}

/**
 20001 => 验签失败
 20004 => 存在拉黑
 20089 => 没有VIP（用户必须要开通VIP才能和对方聊天）
 20097 => 数美检测拦截
 20098 => 余额不足（且未充值过）
 20099 => 余额不足（但充值过）
 20010 => 群禁用
 20011 => 群过期
 20012 => 群解散
 20013 => 需要设置推广员
 */
