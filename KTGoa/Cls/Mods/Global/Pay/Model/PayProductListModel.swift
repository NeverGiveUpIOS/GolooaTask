//
//  PayProductListModel.swift
//  Golaa
//
//  Created by duke on 2024/5/23.
//

import UIKit

class PayProductListPayInfo: HandyJSON {
    required init() {}
    var activeJinbi = 0
    var zfPlatforms: [TaskPublishZFPlatforms] = []
    
    func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &activeJinbi, name: "activeCoin")
        mapper.specify(property: &zfPlatforms, name: "payPlatforms")
    }
}

class PayProductListExtra: HandyJSON {
    required init() {}
    var info = PayProductListPayInfo()
    
    func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &info, name: "payInfo")
    }
}

class PayProductModel: HandyJSON {
    required init() {}
    var list: [PayProductListModel] = []
    var extra = PayProductListExtra()
}

class PayProductListModel: HandyJSON {
    required init() {}
    
    var jinbi = 0
    var jinbiUnit = ""
    var freeJinbi = 0
    var id = 0
    var jiage = 0
    var jiageDes = ""
    var code = ""
    
    // 扩展字段
    var isSelected = false
    
    func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &jinbi, name: "coin")
        mapper.specify(property: &jinbiUnit, name: "currency")
        mapper.specify(property: &freeJinbi, name: "freeCoin")
        mapper.specify(property: &jiage, name: "price")
        mapper.specify(property: &jiageDes, name: "price_")
    }
}
