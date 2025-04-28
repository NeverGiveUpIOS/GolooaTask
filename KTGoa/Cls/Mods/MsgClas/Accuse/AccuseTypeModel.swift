//
//  AccuseTypeModel.swift
//  Golaa
//
//  Created by duke on 2024/5/29.
//

import UIKit

class AccuseTypeModel: HandyJSON {
    required init() {}
    
    var id = 0
    var type = 0
    var typeDes = ""
    var name = ""
    
    // 扩展字段
    var isSelected = false
    
    func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &typeDes, name: "type_")
    }
}
