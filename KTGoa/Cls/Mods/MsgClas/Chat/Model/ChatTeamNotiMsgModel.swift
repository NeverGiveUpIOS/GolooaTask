//
//  ChatTeamNotiMsgModel.swift
//  Golaa
//
//  Created by chenkaisong on 2024/5/21.
//

/// 进群类型
enum ChatTeamNotiAttachType: String, HandyJSONEnum {
    /// 他人邀请
    case invite = "GROUP_INVITE_JOIN"
    /// 主动申请群主审核
    case apply = "GROUP_APPLY_JOIN"

}
struct ChatTeamNotiMsgModel: HandyJSON {
    
    /// 邀请用户的id
    var ids: [String]?
    /// 群成员信息
    var userList: [TeamNotiInfoModel]?
    /// 群组信息
    var teamInfo: TeamNotiTinfoModel?
    /// 1.禁言 0.解禁
    var mute: String = ""
    var attach: String = ""

    var attachModel: ChatTeamNotiAttach? {
        return ChatTeamNotiAttach.deserialize(from: attach)
    }

    mutating func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.userList <-- "uinfos"
        mapper <<<
            self.teamInfo <-- "tinfo"
    }
    
}

struct TeamNotiTinfoModel: HandyJSON {
    /// 群主id
    var id: String?
    /// 云信群id
    var teamId: String?
    /// 群服务器数据
    var severInfo: TeamNotiSeverModel?
    /// 群昵称
    var name: String = ""
    /// 群头像
    var avatar: String = ""

    mutating func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.id <-- "5"
        mapper <<<
            self.teamId <-- "1"
        mapper <<<
            self.name <-- "3"
        mapper <<<
            self.avatar <-- "20"
        mapper <<<
            self.severInfo <-- "19"
    }
}

struct TeamNotiSeverModel: HandyJSON {
    
    /// 服务器群id
    var teamSeverId: String = ""
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.teamSeverId <-- "id"
    }
}

struct TeamNotiInfoModel: HandyJSON {
    
    /// 用户id
    var userId: String = ""
    /// 用户昵称
    var name: String = ""
    /// 用户头像
    var avatar: String = ""
    /// 用户账号
    var account: String = ""

    mutating func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.userId <-- "1"
        mapper <<<
            self.name <-- "3"
        mapper <<<
            self.avatar <-- "4"
        mapper <<<
            self.account <-- "7"
        mapper <<<
            self.name <-- "3"
    }
}

struct ChatTeamNotiAttach: HandyJSON {
    
    var joinType: ChatTeamNotiAttachType = .invite
}
