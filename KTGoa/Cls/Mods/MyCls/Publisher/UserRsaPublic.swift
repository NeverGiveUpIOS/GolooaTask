//
//  UserRsaPublic.swift
//  Golaa
//
//  Created by xiaoxuhui on 2024/6/4.
//

import UIKit

class UserRsaPublic: JsonModelProtocol, Codable {
    required init() {}
    var doc: String = ""
    var key: String = ""
    
    func mapping(mapper: HelpingMapper) {
        mapper <<< doc <-- ["reportDocUrl"]
        mapper <<< key <-- ["rsaPublicKey"]
    }
}
