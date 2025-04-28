//
//  MsgGroupInfoModel.swift
//  Golaa
//
//  Created by chenkaisong on 2024/5/17.
//

class MsgGroupInfoModel: JsonModelProtocol, Codable {
    
    var groupName = ""
    var groupAvatar = ""
    var groupId = ""
    var severId = ""
    var memberNumber = 0
    var status: GroupUserStatus = .user
    /// 是否解散
    var isDissolve = false
    /// 是否被禁用
    var isDisable = false
    
    required init() {}

}
