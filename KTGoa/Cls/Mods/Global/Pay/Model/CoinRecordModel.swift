//
//  CoinRecordModel.swift
//  Golaa
//
//  Created by duke on 2024/5/25.
//

import UIKit

enum CoinRecordFlowType: Int, HandyJSONEnum {
    case none = 0        // 不变
    case income = 1      // 收入
    case disburse = -1   // 支出
}

class CoinRecordModel: HandyJSON {
    required init() {}
    
    var addDateDes = ""
    var text = ""
    var fType: CoinRecordFlowType = .none
    var high = ""
    var id = 0
    var taskId = 0
    var toUId = ""
    var tradeJinerDes = ""
    var tradeType = ""
    var remark = ""
    
    func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &addDateDes, name: "addTime_")
        mapper.specify(property: &text, name: "content")
        mapper.specify(property: &fType, name: "flow")
        mapper.specify(property: &high, name: "highlight")
        mapper.specify(property: &toUId, name: "toUserId")
        mapper.specify(property: &tradeJinerDes, name: "tradeAmount_")
    }
}
