//
//  GetTaskConfig.swift
//  Golaa
//
//  Created by duke on 2024/5/20.
//

import UIKit

class GetTaskConfigItem: HandyJSON {
    required init() {}
    var label = ""
    var value = ""
    
    // 扩展字段
    var text = ""
}

class GetTaskConfig: HandyJSON {
    required init() {}
    var fansArr: [GetTaskConfigItem] = []
    var receiveArr: [Int] = []
    var channelsArr: [GetTaskConfigItem] = []
    var chatHomeArr: [GetTaskConfigItem] = []
    
    func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &fansArr, name: "fansLevels")
        mapper.specify(property: &receiveArr, name: "receiveCounts")
        mapper.specify(property: &channelsArr, name: "taskChannels")
        mapper.specify(property: &chatHomeArr, name: "socialHomeTypes")
    }
}
