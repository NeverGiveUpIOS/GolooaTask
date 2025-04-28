//
//  NImManager.swift
//  Golaa
//
//  Created by chenkaisong on 2024/5/8.
//

let mm = NImManager.shared

class NImManager: NSObject {
    
    static let shared = NImManager()
    
    //    /// 当前聊天 NIMSession
    var curSession: NIMSession?
    
    /// 未读消息 protocol
    var unReadMsgDelegate: NimUnReadMsgDelegate?
    /// 会话列表 protocol
    var conSessionDelegate: NimConSessionDelegate?
    /// 聊天页  protocol
    var chatSessionDelegate: NimChatSessionDelegate?
    
    lazy var allSessions = [MsgSessionModel]()
    lazy var allMsgs = [ChatMsgModel]()

    private override init() {
        super.init()
        addListener()
    }
    
    /// 初始化NIMSDK
    func registerWithOption() {
        
        NIMSDKConfig.shared().delegate = self
        NIMSDKConfig.shared().shouldConsiderRevokedMessageUnreadCount = true
        
        let serSet = NIMServerSetting()
        serSet.httpsEnabled = true
        NIMSDK.shared().serverSetting = serSet
        
        let option = NIMSDKOption()
        option.appKey = NimAppKey
        option.apnsCername = NimApnsCername
        NIMSDK.shared().register(with: option)
        
        // 自定义消息注册
        NIMCustomObject.registerCustomDecoder(ChatAttachmentDecoder())
    }
    
    /// 传/更新 DeviceToken 至云信服务器
    func updateApnsToken(_ deviceToken: Data) {
        let _ =  NIMSDK.shared().updateApnsToken(deviceToken)
        // print("推送返回字符串: \(priString)")
    }
    
    /// 添加监听
    func addListener() {
        removeListener()
        NIMSDK.shared().loginManager.add(self)
        NIMSDK.shared().conversationManager.add(self)
        NIMSDK.shared().chatManager.add(self)
        NIMSDK.shared().teamManager.add(self)
        NIMSDK.shared().userManager.add(self)
    }
    
    /// 移除监听
    func removeListener() {
        NIMSDK.shared().loginManager.remove(self)
        NIMSDK.shared().conversationManager.remove(self)
        NIMSDK.shared().chatManager.remove(self)
        NIMSDK.shared().teamManager.remove(self)
        NIMSDK.shared().userManager.remove(self)
    }
}
