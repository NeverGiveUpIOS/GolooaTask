//
//  WebContentScene.swift
//  Golaa
//
//  Created by Cb on 2024/5/20.
//

import Foundation

enum WebContentScene {
    case url(String)
    case taskIncome
    case agentProfit
    case agentNextLevel
    case agentInvite
    case coinExtra
    case agreement
    case privacy
    case refill
    
    var url: String {
        switch self {
        case .url(let string):
            return string
        case .taskIncome:
            // https://test.golaatech.com/h5#/withdraw?accountType=0
            return GlobalHelper.shared.dataConfigure.taskCashUrl
        case .agentProfit:
            // https://test.golaatech.com/h5#/incomeWithdrawal
            return GlobalHelper.shared.dataConfigure.agentCashUrl
        case .agentNextLevel:
            // https://test.golaatech.com/h5#/juniorManage
            return GlobalHelper.shared.dataConfigure.agentChildUrl
        case .agentInvite:
            // https://test.golaatech.com/h5#/make
            return GlobalHelper.shared.dataConfigure.agentHomeUrl
        case .coinExtra:
            // https://test.golaatech.com/h5#/withdraw?accountType=3
            return GlobalHelper.shared.dataConfigure.goldCashUrl
        case .agreement:
            // https://test-oss.golaatech.com/agreement/agree.html
            return GlobalHelper.shared.dataConfigure.userAgreementUrl
        case .privacy:
            // https://test-oss.golaatech.com/agreement/privacy.html
            return GlobalHelper.shared.dataConfigure.privacyPolicyUrl
        case .refill:
            return GlobalHelper.shared.dataConfigure.rechargeProtocolUrl
        }
    }
    
    var title: String? {
        switch self {
        default:
            return nil
        }
    }
}

extension WebContentScene: Equatable {
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.url, .url):
            return true
        case (.taskIncome, .taskIncome):
            return true
        default:
            return false
        }
    }
    
}
