//
//  MakeupDepositModel.swift
//  Golaa
//
//  Created by duke on 2024/5/24.
//

import UIKit

class MakeupDepositModel: HandyJSON {
    required init() {}
    
    var img = ""
    var id = 0
    var exceedJinerDes = ""
    var exceedJiner = 0
    var exceedNum = 0
    var exceedJinbi = 0

    var name = ""
    var jiage = 0
    var jiageDes = ""
    var payType: IAPPayType = .coin
    var zfPlatforms: [TaskPublishZFPlatforms] = []
    
    func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &img, name: "cover")
        mapper.specify(property: &exceedJinerDes, name: "exceedAmount_")
        mapper.specify(property: &exceedJiner, name: "exceedAmount")
        mapper.specify(property: &exceedNum, name: "exceedCount")
        mapper.specify(property: &exceedJinbi, name: "exceedCoin")
        mapper.specify(property: &jiage, name: "price")
        mapper.specify(property: &jiageDes, name: "price_")
        mapper.specify(property: &zfPlatforms, name: "payPlatforms")
    }

}
