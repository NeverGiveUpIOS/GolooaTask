//
//  NIMGroupModel.swift
//  Golaa
//
//  Created by duke on 2024/5/8.
//

import UIKit
import NIMSDK

enum GroupUserStatus: Int, HandyJSONEnum, Codable {
    case kicked  = -2       // 被踢用户
    case visitor = -1       // 游客
    case user    = 0        // 普通用户
    case admin   = 1        // 管理员
    case owner   = 2        // 群主
}

enum NImGroupJinyanState {
    case none       // 没有禁言
    case jinyan     // 单人禁言
    case allJinyan  // 全员禁言
}

class NIMGroupModel: HandyJSON {
    required init() {}
    var id = ""
    var top: Int = 0
    var team: NIMTeam?
    var name: String = ""
    var maxCount: Int = 0
    var expi: Bool = false
    var white: Bool = false
    var notice: String = ""
    var teamId: String = ""
    var avatar: String = ""
    var ownerUserId: String = ""
    var summary: String = ""
    var memberCount: Int = 0
    var member: NIMTeamMember?
    var status: GroupUserStatus = .user
    var isApply: Bool = false
    var isJoined: Bool = false
    var isRemind: Bool = false

    var applyCount: Int = 0
    var manageCount: Int = 0
    
    var isOwner: Bool {
        return status == .owner
    }
    
    var isAdmin: Bool {
        return (status == .admin || status == .owner)
    }

    // 加群模式：0=不用验证；1=需要验证
    var jiaMode = 0
    
    // 禁言类型：0=否；1=是
    var jinyanType = 0
    
    // 启用状态： 0=停用；1=启用；-1=解散
    var enableSta = 0

    var isAllJinyan: Bool {
        team?.inAllMuteMode() ?? false
    }
    
    // 是否禁言
    var isJinyan: Bool {
        jinyanType == 1 || member?.isMuted == true
    }
    
    // 在群角色
    var role: NIMTeamMemberType {
        member?.type ?? .normal
    }
    
    var jinyanState: NImGroupJinyanState {
        if role == .manager {
            // 是管理员 全员禁言，可以发言
            return isJinyan ? .jinyan : .none
        } else if role == .normal {
            // 是成员 全员禁言，不能发言
            return isAllJinyan ? .allJinyan : (isJinyan ? .jinyan : .none)
        } else {
            return .none
        }
    }

    func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &expi, name: "expire")
        mapper.specify(property: &avatar, name: "icon")
        mapper.specify(property: &summary, name: "intro")
        mapper.specify(property: &teamId, name: "imId")
        mapper.specify(property: &isJoined, name: "join")
        mapper.specify(property: &notice, name: "announcement")
        mapper.specify(property: &memberCount, name: "count")
        mapper.specify(property: &jiaMode, name: "joinMode")
        mapper.specify(property: &jinyanType, name: "muteType")
        mapper.specify(property: &enableSta, name: "enableStatus")
        mapper.specify(property: &isApply, name: "joinWaiting")
        mapper.specify(property: &isRemind, name: "remind")
    }
}
