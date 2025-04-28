//
//  NImManagerConfgi.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/8/1.
//


// MARK: - 未读消息数
protocol NimUnReadMsgDelegate {
    func unReadNumber(_ count: Int)
}

// MARK: - 会话列表
protocol NimConSessionDelegate {
    /// 刷新会话列表
    func refreshConSessions()
}

// MARK: - 聊天页面
protocol NimChatSessionDelegate {
    /// 刷新聊天页信息
    func refreshChatMsg(_ isScrollBt: Bool)
    /// 更新群信息
    func updateGroupInfo(_ groupId: String)
    /// 更新用户信息
    func updateUserInfo(_ userId: String)
    /// 群解散
    func dissolveGroup()
}

/// 会话类型
enum SessionType {
    case singleChat // 单聊
    case groupChat  // 群聊
    case other      // 其他
}

/// IM消息类型
enum IMMsgType: IntegerLiteralType {
    case text // 文本消息
    case voice // 语音消息
    case picture // 图片消息
    case video // 视频消息
    case task // 任务消息
    case gift // 礼物消息
    case tip // tip消息
    case teamInviteNoti // 群通知, 邀请人进群消息
    case teamMuteNoti // 群通知, 群禁言消息
    case teamDisbandment // 群通知, 群解散
    case teamKick // 群通知, 删除群成员
    case other // 其他消息
}

/// IM消息状态
enum IMMsgStatue {
    case sending // 发送中
    case success // 发送成功
    case fail    // 发送失败
}

/// IM消息发送方向
enum IMMsgDirection {
    case sender // 发送方
    case reciver // 接收方
}

/// IM消息读取状态
enum IMMsgReadStatue {
    case read    // 已读
    case unRead  // 未读
    case other  //  不显示已读未读
}

/// 语音消息状态
enum IMMsgAudioStatue: String, HandyJSONEnum {
    case normal // 正常状态
    case palyIng // 播放中
}

