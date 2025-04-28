//
//  NImManager+Message.swift
//  Golaa
//
//  Created by chenkaisong on 2024/5/10.
//  消息处理

extension NImManager {
    
    /// 消息发送
    func sendMessage(msg: NIMMessage, session: NIMSession) {
        let setting = NIMMessageSetting()
        setting.apnsEnabled = true
        msg.setting = setting
        msg.env = NimMsgEnv
        msg.remoteExt = ChatMsgHandle.configureRemote(msg)
        
        NIMSDK.shared().chatManager.send(msg, to: session) { error in
            if let err = error {
                debugPrint("senMsg error in app : ", err.localizedDescription)
                ToastHud.showToastAction(message: err.localizedDescription)
            } else {
                // debugPrint("senMsg success in app : ")
            }
        }
    }
    
    /// 消息插入
    func insertMessage(msg: NIMMessage, session: NIMSession) {
        NIMSDK.shared().conversationManager.save(msg, for: session) { error in
            if let err = error {
                debugPrint("insert Msg error in app : ", err.localizedDescription)
            } else {
                // debugPrint("insert Msg success in app : ")
            }
        }
    }
    
    /// 更新消息
    func updateMessage(msg: NIMMessage, session: NIMSession) {
        NIMSDK.shared().conversationManager.update(msg, for: session) { [weak self] error in
            if error != nil {
                // debugPrint("消息更新失败: \(error.localizedDescription)")
            } else {
                // debugPrint("消息更新成功")
                let from = msg.from ?? ""
                let user = self?.getLocauserInfo(from)
                let msgModel = ChatMsgHandle.buildMessage(msg, user)
                msgModel.msgChangeType = .updateMsg
                self?.updateChatMsg(msgModel)
            }
        }
    }
    
    /// 从本地db读取一个会话里某条消息之前的若干条的消息
    func messagesInSession(_ session: NIMSession, _ message: NIMMessage?, _ isRefresh: Bool) {
        NIMSDK.shared().conversationManager.messages(in: session, message: message ?? nil, limit: 50) { [weak self] _, msgs in
            guard let msgs = msgs else {
                return
            }
            if msgs.count <= 0 {
                return
            }
            
            if session.sessionType == .P2P {
                let list = msgs.map({
                    let user = self?.getLocauserInfo($0.from ?? "") ?? GUsrInfo()
                    let msgModel = ChatMsgHandle.buildMessage($0, user)
                    msgModel.msgChangeType = .getMsgs
                    return msgModel
                })
                self?.getChatMsgs(list, isRefresh)
            }
            
            if session.sessionType == .team {
                let list = msgs.map({
                    let user = self?.getLocauserInfo($0.from ?? "") ?? GUsrInfo()
                    let msgModel = ChatMsgHandle.buildMessage($0, user)
                    msgModel.msgChangeType = .getMsgs
                    return msgModel
                })
                self?.getChatMsgs(list, isRefresh)

                // 获取本地没有用户信息的数据 从服务器拉取用户信息 更新消息
                let fromIds = msgs.filter({
                    ChatMsgHandle.buildMessage($0, self?.getLocauserInfo($0.from ?? "")).userInfo == nil
                }).filter({
                    $0.from != $0.from
                })
                
                fromIds.forEach { [weak self] tMsg in
                    self?.getSeverInfo(tMsg.from ?? "", { [weak self] userInfo in
                        let msgModel = ChatMsgHandle.buildMessage(tMsg, userInfo)
                        msgModel.msgChangeType = .updateMsg
                        self?.updateChatMsg(msgModel)
                    })
                }
            }
        }
    }
}

extension NImManager: NIMChatManagerDelegate {
    
    /// 消息即将发送
    func willSend(_ message: NIMMessage) {
        let msgModel = ChatMsgHandle.buildMessage(message, LoginTl.shared.userInfo)
        msgModel.msgChangeType = .willSendMsg
        willSendMsg(msgModel)
        if reqMagger.networkStatus == .notReachable {
            ToastHud.showToastAction(message: "noNetwork".globalLocalizable())
        }
    }
    
    /**
     *  发送消息完成回调
     *  @param message 当前发送的消息
     *  @param error   失败原因,如果发送成功则error为nil
     */
    func send(_ message: NIMMessage, didCompleteWithError error: (any Error)?) {
        // 消息发送完成更新状态
        let msgModel = ChatMsgHandle.buildMessage(message, LoginTl.shared.userInfo)
        msgModel.msgChangeType = .updateMsg
        updateChatMsg(msgModel)
    }
    
    /// 收到消息回调
    func onRecvMessages(_ messages: [NIMMessage]) {
         BroadcastType.vibrateOccurred() 
        
        guard let session = messages.first?.session else { return  }
        
        if session.sessionType == .P2P {
            
            if let from = messages.first?.from {
                let user = getLocauserInfo(from)
                let list = messages.map({
                    let msgModel =  ChatMsgHandle.buildMessage($0, user)
                    msgModel.msgChangeType = .reciveMsgs
                    return msgModel
                })
                
                reciveChatMsgs(list)
            }
            
            return
        }
        
        // 群聊处理
        let list = messages.map({
            let user = getLocauserInfo($0.from ?? "")
            let msgModel = ChatMsgHandle.buildMessage($0, user)
            msgModel.msgChangeType = .reciveMsgs
            return msgModel
        })
        
        reciveChatMsgs(list)

        // 获取本地没有用户信息的数据 从服务器拉取用户信息 更新消息
        let fromIds = messages.filter({
            ChatMsgHandle.buildMessage($0, getLocauserInfo($0.from ?? "")).userInfo == nil
        }).filter({
            $0.from != $0.from
        })
        
        fromIds.forEach { [weak self] tMsg in
            self?.getSeverInfo(tMsg.from ?? "", { [weak self] userInfo in
                let msgModel =  ChatMsgHandle.buildMessage(tMsg, userInfo)
                msgModel.msgChangeType = .updateMsg
                self?.updateChatMsg(msgModel)
            })
        }
    }
    
    /// 收到已读回执的回调
    func onRecvMessageReceipts(_ receipts: [NIMMessageReceipt]) {
        let msgModel =  ChatMsgModel()
        msgModel.msgChangeType = .receiptsMsg
        readMsgReceipts()
    }
    
    /// 收到消息撤回通知
    func onRecvRevokeMessageNotification(_ notification: NIMRevokeMessageNotification) {
        if let msg = notification.message {
            
            if mm.curSession != nil {
                let user = getLocauserInfo(msg.from ?? "")
                let msgModel =  ChatMsgHandle.buildMessage(msg, user)
                msgModel.msgChangeType = .revokeMsg
                onRecvRevokeMsg(msgModel)
            } else {
                let object = NIMTipObject()
                let message = NIMMessage()
                message.messageObject = object
                message.text = "recvRevokeMsg".msgLocalizable()
                message.from = msg.from ?? ""
                
                let msgSet = NIMMessageSetting()
                msgSet.shouldBeCounted = false
                message.setting = msgSet
                mm.insertMessage(msg: message, session: notification.session)
            }
            
        }
    }
}

extension NImManager {
    
    /// 获取消息
    private func getChatMsgs(_ msgs: [ChatMsgModel], _ isRefresh: Bool) {
        guard let msgModel = msgs.first, let sesstion = msgModel.sesstion else {
            msgResultHandle([], isRefresh)
            return
        }
        if sesstion.sessionId != mm.curSession?.sessionId {
            return
        }
        msgResultHandle(msgs, isRefresh)
        chatSessionDelegate?.refreshChatMsg(isRefresh ? false:true)
    }
    
    /// 收到消息
    private func reciveChatMsgs(_ msgs: [ChatMsgModel]){
        guard let msgModel = msgs.first, let sesstion = msgModel.sesstion else {
            return
        }
        if sesstion.sessionId != mm.curSession?.sessionId {
            return
        }
        msgResultHandle(msgs, false)
        chatSessionDelegate?.refreshChatMsg(true)
    }
    
    
    /// 消息即将发送
    private func willSendMsg(_ msg: ChatMsgModel) {
        guard let sesstion = msg.sesstion else {
            return
        }
        if sesstion.sessionId != mm.curSession?.sessionId {
            return
        }
        allMsgs.append(msg)
        chatSessionDelegate?.refreshChatMsg(true)
    }
    
    /// 消息更新
     func updateChatMsg(_ msg: ChatMsgModel) {
        guard let sesstion = msg.sesstion else {
            return
        }
        if sesstion.sessionId != mm.curSession?.sessionId {
            return
        }
        if let index = allMsgs.firstIndex(where: { $0.msgId == msg.msgId }) {
            allMsgs[index] = msg
        }
        chatSessionDelegate?.refreshChatMsg(false)        
    }
    
    /// 消息撤回
     func onRecvRevokeMsg(_ msg: ChatMsgModel) {
        guard let sesstion = msg.sesstion else {
            return
        }
        if sesstion.sessionId != mm.curSession?.sessionId {
            return
        }
        if let index = allMsgs.firstIndex(where: { $0.msgId == msg.msgId }) {
            if index < allMsgs.count {
                allMsgs.remove(at: index)
                ChatMsgHandle.recvRevokeMessage(msg: msg)
            }
        }
         DispatchQueue.main.asyncAfter(deadline: .now()+0.05) { [weak self] in
             self?.chatSessionDelegate?.refreshChatMsg(true)
         }
    }
    
    /// 删除一条消息
    func deleteMsg(_ msg: ChatMsgModel) {
        guard let sesstion = msg.sesstion else {
            return
        }
        if sesstion.sessionId != mm.curSession?.sessionId {
            return
        }
        if let index = allMsgs.firstIndex(where: { $0.msgId == msg.msgId }) {
            if index < allMsgs.count {
                allMsgs.remove(at: index)
            }
        }
        
        chatSessionDelegate?.refreshChatMsg(false)
    }
    
    /// 更新用户信息
    private func updateUserInfo(_ userId: String) {
        if let user = mm.getLocauserInfo(userId) {
            allMsgs.forEach { msgModel in
                if userId == msgModel.userInfo?.id {
                    msgModel.userInfo = user
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+0.05) { [weak self] in
            self?.chatSessionDelegate?.refreshChatMsg(false)
        }
    }
    
    /// 消息已读
    private func readMsgReceipts() {
        guard let sesstion = allMsgs.first?.sesstion else {
            return
        }
        if sesstion.sessionId != mm.curSession?.sessionId {
            return
        }
        allMsgs.forEach { msgModel in
            msgModel.msgReadStatue = .read
        }
        chatSessionDelegate?.refreshChatMsg(false)
    }
    
    /// 消息处理
    private func msgResultHandle(_ msgs: [ChatMsgModel], _ isRefresh: Bool) {
        
        if isRefresh {
            msgs.forEach { [weak self] msgModel in
                self?.allMsgs.insert(msgModel, at: 0)
            }
        } else {
            allMsgs.appends(msgs)
        }
        
        // 消息去重
        allMsgs = allMsgs.filterDuplicates({
            $0.msgId
        })
        
        mm.markAllMessagesRead(mm.curSession?.sessionId ?? "", mm.curSession?.sessionType ?? .P2P)
        
        if let lastMsg = allMsgs.last?.msg {
            let receipt = NIMMessageReceipt(message: lastMsg)
            NIMSDK.shared().chatManager.send(receipt)
        }
    }
    
    
}
