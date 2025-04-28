//
//  NewFriendListModel.swift
//  Golaa
//
//  Created by chenkaisong on 2024/5/20.
//

import UIKit

class NewFriendListModel: JsonModelProtocol, Codable {

    var remark = ""
    /// -1=已拒绝 0=待处理 1=已接受
    var status = ""
    var status_ = ""
    var toUser: NewFriendTouserModel?
    
    required init() {}

}

class NewFriendTouserModel: JsonModelProtocol, Codable {

    var avatar = ""
    var id = ""
    var name = ""
    var isPublish = false
    
    required init() {}

}
