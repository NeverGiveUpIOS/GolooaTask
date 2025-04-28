//
//  NImManager+Group.swift
//  Golaa
//
//  Created by duke on 2024/5/8.
//

import NIMSDK

extension NImManager {
    
    /// 检查是否在群
    func checkInTeam(_ teamId: String) -> Bool {
        NIMSDK.shared().teamManager.isMyTeam(teamId)
    }
    
    /// 获取群信息
    func fetchTeam(_ teamId: String, completion: ((NIMTeam?) -> Void)?) {
        NIMSDK.shared().teamManager.fetchTeamInfo(teamId) { error, team in
            if error == nil {
                completion?(team)
                return
            }
            completion?(nil)
        }
    }
    
    /// 获取群成员信息
    func fetchTeamMember(_ teamId: String, userId: String) -> NIMTeamMember? {
        let member = NIMSDK.shared().teamManager.teamMember(userId, inTeam: teamId)
        return member
    }
}

// MARK: - NIMTeamManagerDelegate
extension NImManager: NIMTeamManagerDelegate {
    
    /// 群信息更新 头像或者昵称
    func onTeamUpdated(_ team: NIMTeam) {        
        // 更新会话群组群组信息
        getSeverGroupInfo(team.teamId ?? "") { [weak self] groupInfo in
            self?.updateSesGroupInfo(groupInfo)
            self?.chatSessionDelegate?.updateGroupInfo(groupInfo.groupId)
        }
    }
    
    /// 群成员,以及属性变动
    func onTeamMemberChanged(_ team: NIMTeam) {
        // 更新聊天群组信息
        chatSessionDelegate?.updateGroupInfo(team.teamId ?? "")
    }

}

// MARK: - NIMSDKConfigDelegate
extension NImManager: NIMSDKConfigDelegate {
    
    func shouldIgnoreNotification(_ notification: NIMNotificationObject) -> Bool {
        
        if let content = notification.content as?  NIMTeamNotificationContent {
            
            switch content.operationType {
            case .invite:
                return false
            case .kick: // 群成员移除
                if let ids = content.targetIDs {
                    let isSelf = ids.contains(LoginTl.shared.usrId)
                    return !isSelf
                }
                return true
            case .dismiss:
                chatSessionDelegate?.dissolveGroup()
                return false
            default:
                return true
            }
        }
        
        return true
    }
}
