//
//  ChoreRecordModel.swift
//  Golaa
//
//  Created by Cb on 2024/5/24.
//

import Foundation

class ChoreRecordModel: JsonModelProtocol {
    required init() {}
    var settleDesc = ""
    var finishCount = 0
    var statusDesc = ""
    var incomeDesc = ""
    var status = 0
    var scene: ChoreRecordScene? { ChoreRecordScene(rawValue: status) }
    var statusShow: String { scene?.enabelContent(statusDesc) ?? statusDesc }

    func mapping(mapper: HelpingMapper) {
        mapper <<< settleDesc <-- "settleDate_"
        mapper <<< incomeDesc <-- "income_"
        mapper <<< statusDesc <-- "status_"
    }
}
