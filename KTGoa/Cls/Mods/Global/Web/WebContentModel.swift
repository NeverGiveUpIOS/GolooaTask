//
//  WebContentModel.swift
//  Golaa
//
//  Created by duke on 2024/5/25.
//

import UIKit

class WebContentModel: HandyJSON {
    required init() {}
    
    var id = ""
    var uid = ""
    var name = ""
    var jumpName = ""
    var url = ""
    var isSendSvga = false
    
    // 海报分享相关
    var qrCo = ""
    var invCo = ""
    var link = ""
    var title = ""
    
    func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &uid, name: "userId")
        mapper.specify(property: &jumpName, name: "pageName")
        mapper.specify(property: &isSendSvga, name: "isSendGift")
        mapper.specify(property: &qrCo, name: "qrCode")
        mapper.specify(property: &invCo, name: "inviteCode")
        mapper.specify(property: &link, name: "url")
    }
}
