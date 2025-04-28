//
//  ChorePublishDetailModel.swift
//  Golaa
//
//  Created by Cb on 2024/5/24.
//

import Foundation

class ChorePublishDetailModel: JsonModelProtocol {
    required init() {}
    var settleDateDesc = ""
    var consumeDesc = ""
    var finishCount = 0
    var statusDesc = ""
    var recNum = 0
    var status = 0
    var scene: ChorePublishScene? { ChorePublishScene(rawValue: status) }
    var statusShow: String { scene?.enabelContent(statusDesc) ?? statusDesc }

    func mapping(mapper: HelpingMapper) {
        mapper <<< settleDateDesc <-- "settleDate_"
        mapper <<< consumeDesc <-- "consume_"
        mapper <<< statusDesc <-- "status_"
        mapper.specify(property: &recNum, name: "receiveNum")
    }
}
