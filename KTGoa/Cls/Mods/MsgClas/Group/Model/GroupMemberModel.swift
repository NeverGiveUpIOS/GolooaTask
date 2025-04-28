//
//  GroupMemberModel.swift
//  Golaa
//
//  Created by duke on 2024/5/13.
//

import UIKit

enum GroupMemberJuese: Int, HandyJSONEnum {
    case user = 0
    case admin = 1
    case owner = 2
}

class GroupMemberModel: HandyJSON {
    required init() {}
    var avtr: String = ""
    var name: String = ""
    var mute: Bool = false
    var isAdd: Bool = false
    var userId: String = ""
    var group: NIMGroupModel?
    
    var isOwner: Bool {
        return (juese == .owner)
    }
//
//    var isCurOwner: Bool = false
//    var isCurAdmin: Bool = false
    
    // 成员状态：2：管理员 1：管理员 0：普通成员
    var juese: GroupMemberJuese = .user
    
    func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &userId, name: "id")
        mapper.specify(property: &avtr, name: "avatar")
        mapper.specify(property: &juese, name: "status")
        mapper.specify(property: &mute, name: "muteType")
        mapper.specify(property: &name, name: "nickname")
    }
}

class GroupApplyModel: HandyJSON {
    required init() {}
    var id: Int = 0
    var status: Int = 0
    var toId: String = ""
    var gender: Gender = .body
    var avatar: String = ""
    var remark: String = ""
    var groupId: String = ""
    var nickname: String = ""
}
