//
//  MineCellType.swift
//  Golaa
//
//  Created by Cb on 2024/5/13.
//

import Foundation

enum MineHeaderType: Int, MineCellLayoutable, CaseIterable {
    case userInfo
    case benefit
    case pouch
    case pouchCoin
    
    static var modules: [MineHeaderType] { GlobalHelper.shared.inEndGid ? [.userInfo, .pouchCoin] : [.userInfo, .pouch] }
    
    func itemWidth(indexPath: IndexPath) -> CGFloat { screW - MineLayout.padingLeading * 2.0 }
    
    func itemHeight(row: Int) -> CGFloat {
        switch self {
        case .userInfo:
            return MineLayout.userAvatar
        case .benefit:
            return MineLayout.benefitHeight
        case .pouch,
                .pouchCoin:
            return MineLayout.pouchHeight
        }
    }
    
    
    static func totalHeight() -> CGFloat {
        var height = safeAreaTp + 15.0 + 40.0 + CGFloat(modules.count - 1) * 20.0
        for i in modules {
            height += i.itemHeight(row: 0)
        }
        return height
    }
}

enum MineTaskType: MineCellLayoutable, CaseIterable {
    case total
    //    case check
    case settlement
    case finish
    
    var title: String {
        switch self {
        case .total:
            return "all".meLocalizable()
            //        case .check:
            //            return "toBeVerified".meLocalizable()
        case .settlement:
            return GlobalHelper.shared.inEndGid ? "inProgress".meLocalizable() : "pendingSettlement".meLocalizable()
        case .finish:
            return GlobalHelper.shared.inEndGid ? "completed".meLocalizable() : "alreadySettled".meLocalizable()
        }
    }
    
    var icon: String {
        switch self {
        case .total:
            return "mine_need_check"
            //        case .check:
            //            return "mine_need_check"
        case .settlement:
            return "mine_need_js"
        case .finish:
            return "mine_finished"
        }
    }
    
    func push() {
        switch self {
        case .total:
            RoutinStore.push(.choreRecord, param: ChoreRecordScene.all)
        case .settlement:
            RoutinStore.push(.choreRecord, param: ChoreRecordScene.wait)
        case .finish:
            RoutinStore.push(.choreRecord, param: ChoreRecordScene.finish)
        }
    }
    
    static var modules: [MineTaskType] { allCases }
}

enum MineCommonType: MineCellLayoutable, CaseIterable {
    case service
    case publishManager
    case cooperation
    case publishInformation
    case setting
    
    var title: String {
        switch self {
        case .service:
            return "onlineCustomerService".meLocalizable()
        case .publishManager:
            return "publishManagement".meLocalizable()
        case .cooperation:
            return "agencyCooperation".meLocalizable()
        case .publishInformation:
            return "publisherInformation".meLocalizable()
        case .setting:
            return "moreSettings".meLocalizable()
        }
    }
    
    var icon: String {
        switch self {
        case .service:
            return "mine_zx_kf"
        case .publishManager:
            return "mine_fb_gl"
        case .cooperation:
            return "mine_dl_hz"
        case .publishInformation:
            return "mine_pub_info"
        case .setting:
            return "mine_sz"
        }
    }
    
    var iconHeight: CGFloat { MineLayout.iconMinHeight }
    
    func push() {
        switch self {
        case .service:
            RoutinStore.pushOnlineService()
        case .publishManager:
            RoutinStore.push(.chorePublishManager)
        case .cooperation:
            RoutinStore.push(.agentCooperation)
        case .publishInformation:
            RoutinStore.push(.publisher)
        case .setting:
            RoutinStore.push(.setting)
        }
    }
    
    static var modules: [MineCommonType] { GlobalHelper.shared.inEndGid ? [.service, .publishManager, .setting] : allCases  }
    
}

enum MineAgentType: MineCellLayoutable, CaseIterable {
    case profit
    case nextLevel
    case invitation
    
    var title: String {
        switch self {
        case .profit:
            return "agencyEarnings".meLocalizable()
        case .nextLevel:
            return "subordinateManagement".meLocalizable()
        case .invitation:
            return "inviteToMakeMoney".meLocalizable()
        }
    }
    
    var icon: String {
        switch self {
        case .profit:
            return "mine_dl_sy"
        case .nextLevel:
            return "mine_xj_gl"
        case .invitation:
            return "mine_yq"
        }
    }
    
    var iconHeight: CGFloat { MineLayout.iconMinHeight }
    
    func push() {
        switch self {
        case .profit:
            RoutinStore.push(.webScene(.agentProfit))
        case .nextLevel:
            RoutinStore.push(.webScene(.agentNextLevel))
        case .invitation:
            RoutinStore.push(.webScene(.agentInvite))
        }
    }
    
    static var modules: [MineAgentType] { allCases }
}
