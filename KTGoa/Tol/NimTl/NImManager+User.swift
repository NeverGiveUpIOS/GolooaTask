//
//  NImManager+User.swift
//  Golaa
//
//  Created by chenkaisong on 2024/5/20.
//

// MARK: - 用户
extension NImManager {
    
    /// 更新用户云信信息
    func updateMyUserInfo() {
        
        let par = [NSNumber(value: NIMUserInfoUpdateTag.avatar.rawValue): LoginTl.shared.userInfo?.avatar ?? "",
                   NSNumber(value: NIMUserInfoUpdateTag.nick.rawValue): LoginTl.shared.userInfo?.showName ?? ""]
        NIMSDK.shared().userManager.updateMyUserInfo(par) { error in
            if error == nil {
            }
        }
        
    }
    
    /// 更新本地用户信息
    func updateLocaUserInfo(_ userData: GUsrInfo) {
        UserDefaults.gt.saveModelForKey(userData, forKey: "NIM_Chat_\(userData.id)")
    }
    
    /// 更新本地群组信息
    func updateLocaGroupInfo(_ groupInfo: MsgGroupInfoModel) {
        UserDefaults.gt.saveModelForKey(groupInfo, forKey: "NIM_Group_\(groupInfo.groupId)")
    }
    
    // 获取云信服务器用户信息
    func getSeverInfo(_ userId: String,
                      _ completion: @escaping (_ userInfo: GUsrInfo) -> Void) {
        
        GTAsyncs.async {
            NIMSDK.shared().userManager.fetchUserInfos([userId]) { userList, _ in
                if let user = userList?.first, let userInfo = user.userInfo {
                    let userData = GUsrInfo()
                    userData.id = user.userId ?? ""
                    let nickName = userInfo.nickName ?? ""
                    userData.username = nickName.count > 0 ? nickName : user.userId ?? ""
                    userData.nickname = nickName.count > 0 ? nickName : user.userId ?? ""
                    userData.avatar = userInfo.avatarUrl ?? ""
                    UserDefaults.gt.saveModelForKey(userData, forKey: "NIM_Chat_\(userId)")
                    DispatchQueue.main.async {
                        completion(userData)
                    }
                }
            }
        }
        
    }
    
    /// 获取本地云信用户信息
    func getLocauserInfo(_ userId: String) -> GUsrInfo? {
        
        if userId == LoginTl.shared.usrId {
            return LoginTl.shared.userInfo
        }
        
        /// 从本地缓存获取用户信息
        if let userData = UserDefaults.gt.getModelForKey(GUsrInfo.self, forKey: "NIM_Chat_\(userId)") {
            return userData
        }
        
        /// 从云信本地获取用户信息
        if  let user =  NIMSDK.shared().userManager.userInfo(userId), let userInfo = user.userInfo {
            let userData = GUsrInfo()
            userData.id = user.userId ?? ""
            let nickName = userInfo.nickName ?? ""
            userData.username = nickName.count > 0 ? nickName : user.userId ?? ""
            userData.nickname = nickName.count > 0 ? nickName : user.userId ?? ""
            userData.avatar = userInfo.avatarUrl ?? ""
            UserDefaults.gt.saveModelForKey(userData, forKey: "NIM_Chat_\(userId)")
            return userData
        }
        
        return nil
    }
    
    /// 获取云信服务群组信息
    func getSeverGroupInfo(_ groupId: String,
                           _ completion: @escaping (_ groupInfo: MsgGroupInfoModel) -> Void) {
        
        GTAsyncs.async { [weak self] in
            self?.fetchTeam(groupId, completion: { team in
                
                if team == nil { // 群已不存在
                    let group = MsgGroupInfoModel()
                    group.isDissolve = true
                    DispatchQueue.main.async {
                        completion(group)
                    }
                    return
                }
                
                let group = MsgGroupInfoModel()
                let teamName = team?.teamName ?? ""
                group.groupName = teamName.count > 0 ? teamName : team?.teamId ?? ""
                group.groupAvatar = team?.avatarUrl ?? ""
                group.groupId = team?.teamId ?? ""
                group.memberNumber = team?.memberNumber ?? 0
                if let serverCustomInfo = team?.serverCustomInfo?.jsonStringToDictionary(),
                   let severId = serverCustomInfo["id"] as? String {
                    group.severId = severId
                }
                UserDefaults.gt.saveModelForKey(group, forKey: "NIM_Group_\(groupId)")
                DispatchQueue.main.async {
                    completion(group)
                }
            })
        }
    }
    
    /// 获取本地云信群组信息
    func getLocaGroupInfo(_ groupId: String) -> MsgGroupInfoModel? {
        if let group = UserDefaults.gt.getModelForKey(MsgGroupInfoModel.self, forKey: "NIM_Group_\(groupId)") {
            return group
        }
        return nil
    }
}

// MARK: - NIMUserManagerDelegate
extension NImManager: NIMUserManagerDelegate {
    
    /// 好友用户信息更新,  收到消息时会收到该回调
    func onUserInfoChanged(_ user: NIMUser) {
        if user.userId == LoginTl.shared.usrId { return }
        
        getSeverInfo(user.userId ?? "") { [weak self] userData in
            // 更新会话列表用户信息
            self?.updateSesUserInfo(userData)
            self?.chatSessionDelegate?.updateUserInfo(userData.id)
        }
    }
}
