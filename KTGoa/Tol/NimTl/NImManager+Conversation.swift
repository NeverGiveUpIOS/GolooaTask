//
//  NImManager+Conversation.swift
//  Golaa
//
//  Created by chenkaisong on 2024/5/8.
//  会话处理

extension NImManager {
    
    /// 会话处理
    private func getSessionHandle(_ sessions: [NIMRecentSession]) {
        let msgs = sessions.map {
            let userInfo = getLocauserInfo($0.session?.sessionId ?? "")
            let groupInfo = getLocaGroupInfo($0.session?.sessionId ?? "")
            let sessionModel = ChatMsgHandle.buildSessionModel(session: $0, userInfo: userInfo, group: groupInfo)
            return sessionModel
        }
        
        getSessionsList(msgs)
        
        for sess in sessions {
            
            let sessionId = sess.session?.sessionId ?? ""
            
            // 单聊获取用户信息
            if sess.session?.sessionType == .P2P {
                getSeverInfo(sessionId) { [weak self] userInfo in
                    let sessionModel = ChatMsgHandle.buildSessionModel(session: sess, userInfo: userInfo)
                    sessionModel.changeType = .updateSession
                    self?.sessionUpdate(sessionModel)
                }
            }
            
            // 获取群组信息
            if sess.session?.sessionType == .team {
                getSeverGroupInfo(sessionId) { [weak self] group in
                    let sessionModel = ChatMsgHandle.buildSessionModel(session: sess, group: group)
                    sessionModel.changeType = .updateSession
                    self?.sessionUpdate(sessionModel)
                }
            }
        }
    }
    
    /// 获取最近所有会话
    func getAllRecentSessions() {
        guard let sessions = NIMSDK.shared().conversationManager.allRecentSessions() else {
            // 从服务器获取
            getServerSessions()
            return
        }
        
        if sessions.count <= 0 {
            // 从服务器获取
            getServerSessions()
            return
        }
        
        getSessionHandle(sessions)
    }
    
    /// 从服务器获取会话
    func getServerSessions() {
        NIMSDK.shared().conversationManager.fetchServerSessions(nil) { [weak self] _, sessions, _ in
            self?.getSessionHandle(sessions ?? [])
        }
    }
    
    /// 获取总未读数
    func getAllUnreadCount() {
        let allUnreadCount = NIMSDK.shared().conversationManager.allUnreadCount()
        unReadMsgDelegate?.unReadNumber(allUnreadCount)
    }
    
    /// 设置一个会话里所有消息置为已读
    func markAllMessagesRead(_ sessionId: String, _ sessionType: NIMSessionType) {
        let  session = NIMSession.init(sessionId, type: sessionType)
        NIMSDK.shared().conversationManager.markAllMessagesRead(in: session) { _ in
        }
    }
}

extension NImManager: NIMConversationManagerDelegate {
    
    /// 最近会话增加回调。当新增一条消息，并且本地不存在该消息所属的会话时，会触发此回调。
    func didAdd(_ recentSession: NIMRecentSession, totalUnreadCount: Int) {
        
        let sessionModel = ChatMsgHandle.buildSessionModel(session: recentSession)
        sessionModel.changeType = .addASession
        sessionUpdate(sessionModel)
        
        // 更新未读消息数
        getAllUnreadCount()
        
        let sessionId = recentSession.session?.sessionId ?? ""
        
        // 单聊获取用户信息
        if recentSession.session?.sessionType == .P2P {
            getSeverInfo(sessionId) { [weak self] userInfo in
                let sessionModel = ChatMsgHandle.buildSessionModel(session: recentSession, userInfo: userInfo)
                sessionModel.changeType = .updateSession
                self?.sessionUpdate(sessionModel)
            }
            
        }
        
        // 获取群组信息
        if recentSession.session?.sessionType == .team {
            getSeverGroupInfo(sessionId) { [weak self] group in
                let sessionModel = ChatMsgHandle.buildSessionModel(session: recentSession, group: group)
                sessionModel.changeType = .updateSession
                self?.sessionUpdate(sessionModel)
            }
        }
    }
    
    /// 最近会话更新回调
    func didUpdate(_ recentSession: NIMRecentSession, totalUnreadCount: Int) {
        let sessionId = recentSession.session?.sessionId ?? ""
        
        if recentSession.session?.sessionType == .P2P {
            let user = getLocauserInfo(sessionId)
            let sessionModel = ChatMsgHandle.buildSessionModel(session: recentSession, userInfo: user)
            sessionModel.changeType = .updateSession
            sessionUpdate(sessionModel)
        }
        
        if recentSession.session?.sessionType == .team {
            let group = getLocaGroupInfo(sessionId)
            let sessionModel = ChatMsgHandle.buildSessionModel(session: recentSession, group: group)
            sessionModel.changeType = .updateSession
            sessionUpdate(sessionModel)
        }
        
        getAllUnreadCount()
    }
    
    ///  最近会话删除回调。
    func didRemove(_ recentSession: NIMRecentSession, totalUnreadCount: Int) {
        let sessionModel = ChatMsgHandle.buildSessionModel(session: recentSession)
        sessionModel.changeType = .deleteSession
        sessionUpdate(sessionModel)
        getAllUnreadCount()
    }
    
    /// 未读数更新的回调 (markRead不会走此回调)
    func didUpdateUnreadCountDic(_ unreadCountDic: [AnyHashable: Any]) {
        getAllUnreadCount()
    }
    
    ///  所有消息已读的回调
    func allMessagesRead() {
        let sessionModel = MsgSessionModel()
        sessionModel.changeType = .allSessionRead
        sessionUpdate(sessionModel)
        getAllUnreadCount()
    }
}

// MARK: - Sessions Handle
extension NImManager {
    
    /// 获取会话
    func getSessionsList(_ sessions: [MsgSessionModel]) {
        let sortList = ChatMsgHandle.sortAllRecentSessions(sessions)
        self.allSessions.removeAll()
        self.allSessions = sortList
        self.conSessionDelegate?.refreshConSessions()
    }
    
    /// 会话更新
    func sessionUpdate(_ sessModel: MsgSessionModel) {
        
        var tList = self.allSessions
        
        switch sessModel.changeType {
        case .updateSession: // 更新
            if let index = tList.firstIndex(where: { $0.sessionId == sessModel.sessionId }) {
                tList[index] = sessModel
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { [weak self] in
                    self?.getSessionsList(tList)
                }
            }
        case .addASession: // 新增
            tList.append(sessModel)
            self.getSessionsList(tList)
        case .deleteSession: // 删除
            if let index = tList.firstIndex(where: { $0.sessionId == sessModel.sessionId }) {
                tList.remove(at: index)
                self.getSessionsList(tList)
            }
        case .allSessionRead: // 已读
            tList.forEach { msg in
                msg.unreadCount = 0
            }
            self.getSessionsList(tList)
        default:
            break
        }
        
    }
    
    /// 更新用户信息
    func updateSesUserInfo(_ userInfo: GUsrInfo) {
        var tList = self.allSessions
        
        if let index = tList.firstIndex(where: { $0.sessionId == userInfo.id }) {
            if let curSession = tList[index].curSession {
                let sessionModel = ChatMsgHandle.buildSessionModel(session: curSession, userInfo: userInfo)
                tList[index] = sessionModel
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { [weak self] in
                    self?.getSessionsList(tList)
                }
            }
        }
    }
    
    /// 更新群信息
    func updateSesGroupInfo(_ groupInfo: MsgGroupInfoModel) {
        var tList = self.allSessions
        
        if let index = allSessions.firstIndex(where: { $0.sessionId == groupInfo.groupId }) {
            if let curSession = tList[index].curSession {
                let sessionModel = ChatMsgHandle.buildSessionModel(session: curSession, group: groupInfo)
                tList[index] = sessionModel
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { [weak self] in
                    self?.getSessionsList(tList)
                }
            }
        }
    }
    
}
