//
//  STSTokenModel.swift
//  Golaa
//
//  Created by duke on 2024/5/15.
//

import UIKit

class STSTokenModel: HandyJSON {
    required init() {}
    
    var acceId = ""
    var key = ""
    var exp = ""
    var acceSec = ""
    var main = ""
    var secToken = ""
    var buck = ""
    var endPoint: String {
        "https://" + main
    }
    var domain: String {
        "https://\(buck).\(main)/"
    }
    
    func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &main, name: "host")
        mapper.specify(property: &exp, name: "expire")
        mapper.specify(property: &buck, name: "bucket")
        mapper.specify(property: &acceId, name: "accessId")
        mapper.specify(property: &acceSec, name: "accessSecret")
        mapper.specify(property: &secToken, name: "securityToken")
    }
}
