//
//  SelectTaskListModel.swift
//  Golaa
//
//  Created by duke on 2024/5/22.
//

import UIKit

class SelectTaskListModel: HandyJSON {
    required init() {}
    var img = ""
    var id = 0
    var isReVery = false
    var name = ""
    var jiageDes = ""
    
    func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &img, name: "cover")
        mapper.specify(property: &isReVery, name: "isSecurity")
        mapper.specify(property: &jiageDes, name: "price_")
    }
}
