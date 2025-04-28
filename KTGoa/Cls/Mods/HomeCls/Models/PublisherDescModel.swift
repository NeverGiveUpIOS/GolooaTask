//
//  PublisherDescModel.swift
//  Golaa
//
//  Created by duke on 2024/5/21.
//

import UIKit

class PublisherDescUser: HandyJSON {
    required init() {}
    var name = ""
    var publishName = ""
    var id = ""
    var avatar = ""
    var slogan = ""
    var isSelf = false
}

class PublisherDescExtra: HandyJSON {
    required init() {}
    var user = PublisherDescUser()
}

class PublisherDescModel: HandyJSON {
    required init() {}
    
    var list: [HomeListModel] = []
    var extra = PublisherDescExtra()
}
