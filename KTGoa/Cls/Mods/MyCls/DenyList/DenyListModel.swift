//
//  DenyListModel.swift
//  Golaa
//
//  Created by Cb on 2024/5/17.
//

import Foundation

class DenyListModel: JsonModelProtocol {
    required init() {}
    var id = 0
    var user = DenyUser()
    
    func mapping(mapper: HelpingMapper) {
        mapper <<< user <-- "toUser"
    }
}

class DenyUser: JsonModelProtocol {
    required init() {}
    var id = ""
    var avatar = ""
    var userId = ""
    var name = ""
}
