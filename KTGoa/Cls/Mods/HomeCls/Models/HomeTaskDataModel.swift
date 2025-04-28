//
//  HomeBalanceModel.swift
//  Golaa
//
//  Created by duke on 2024/5/14.
//

import UIKit

class HomeBalanceAccount: HandyJSON {
    required init() {}
    var id = 0
    var totalAmt = 0.00
    var totalAmtDes = ""
    var frozenAmt = 0.00
    var frozenAmtDes = ""
    var activeAmt = 0.00
    var activeAmtDes = ""
    var todayImeDes = ""
    
    func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &totalAmt, name: "totalAmount")
        mapper.specify(property: &totalAmtDes, name: "totalAmount_")
        mapper.specify(property: &frozenAmt, name: "frozenAmount")
        mapper.specify(property: &frozenAmtDes, name: "frozenAmount_")
        mapper.specify(property: &activeAmt, name: "activeAmount")
        mapper.specify(property: &activeAmtDes, name: "activeAmount_")
        mapper.specify(property: &todayImeDes, name: "todayIncome_")
    }

}

class HomeTaskDataModel: HandyJSON {
    required init() {}
    
    var isPub = false
    var pubVering = false
    var isDanbao = false
    var taskAccount = HomeBalanceAccount()
    var todayIme = 0.00
    var todayImeDes = ""
    
    public func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &isPub, name: "isPublish")
        mapper.specify(property: &pubVering, name: "publishVerifying")
        mapper.specify(property: &isDanbao, name: "isSecurity")
        mapper.specify(property: &taskAccount, name: "taskAccount")
        mapper.specify(property: &todayIme, name: "todayIncome")
        mapper.specify(property: &todayImeDes, name: "todayIncome_")
    }
}

class HomeBalanceModel: HandyJSON {
    required init() {}
    
    var agentAcc = HomeBalanceAccount()
    var depositAcc = HomeBalanceAccount()
    var taskAcc = HomeBalanceAccount()
    var coinAcc = HomeBalanceAccount()
    var goldAcc = HomeBalanceAccount()

    var todayInm = 0
    var todayInmDes = ""
    var totalActAmt = 0.00
    var totalAmt = 0.00
    var totalAmtDes = ""

    public func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &agentAcc, name: "agentAccount")
        mapper.specify(property: &depositAcc, name: "depositAccount")
        mapper.specify(property: &taskAcc, name: "taskAccount")
        mapper.specify(property: &todayInm, name: "todayIncome")
        mapper.specify(property: &todayInmDes, name: "todayIncome_")
        mapper.specify(property: &totalActAmt, name: "totalActiveAmount")
        mapper.specify(property: &totalAmt, name: "totalAmount")
        mapper.specify(property: &totalAmtDes, name: "totalAmount_")
        mapper.specify(property: &coinAcc, name: "coinAccount")
        mapper.specify(property: &goldAcc, name: "goldAccount")
    }
}
