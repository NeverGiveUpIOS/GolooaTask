//
//  MakeupDepositAlert.swift
//  Golaa
//
//  Created by duke on 2024/5/24.
//

import UIKit

class MakeupDepositAlert: NSObject {
    
    static func show(taskId: Int, date: String, content: String) {
        AlertPopView.show(titles: "importantNoticeTaskDepositInsufficient".meLocalizable(), contents: content, sures: "goToPay".meLocalizable(), cacnces: "contactCustomerService".meLocalizable(), cacncesColor: .hexStrToColor("#2697FF")) { // 去支付保证金
            RoutinStore.push(.makeupDeposit, param: ["date": date, "taskId": taskId])
        } cancelCompletion: {
            // 去联系客服
            RoutinStore.pushOnlineService()
        }
    }
}
