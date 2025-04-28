//
//  TaskPublishConfig.swift
//  Golaa
//
//  Created by duke on 2024/5/16.
//

import UIKit

enum TaskPublishZFType: Int, HandyJSONEnum {
    case coin = 1
    case yuer = 2
    case apple = 4
    case paymax = 5
}

class TaskPublishZFPlatforms: HandyJSON {
    required init() {}
    
    var name = ""
    var zfType = ""
    var yuer = ""
    var img = ""
    var jinbiToUSD = 0 // 金币兑换美元的除数，默认为10 即 1金币 = 1/10 美元
    var url = ""
    var type: TaskPublishZFType = .yuer
    
    func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &zfType, name: "value")
        mapper.specify(property: &yuer, name: "balance_")
        mapper.specify(property: &img, name: "icon")
        mapper.specify(property: &jinbiToUSD, name: "coinToUSDDivisor")
        mapper.specify(property: &type, name: "value")
    }
}

class TaskPublishConfig: HandyJSON {
    required init() {}
    
    var actAmnt = 0
    var minDate = 0
    var maxDate = 0
    var taskList: [Int] = []
    var zfPlatforms: [TaskPublishZFPlatforms] = []
    
    func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &actAmnt, name: "activeAmount")
        mapper.specify(property: &minDate, name: "minDay")
        mapper.specify(property: &maxDate, name: "maxDay")
        mapper.specify(property: &taskList, name: "taskCounts")
        mapper.specify(property: &zfPlatforms, name: "payPlatforms")
    }
}
