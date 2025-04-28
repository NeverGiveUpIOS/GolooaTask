//
//  ChoreRecordScene.swift
//  Golaa
//
//  Created by Cb on 2024/5/20.
//

import Foundation

// 任务记录场景
enum ChoreRecordScene: Int, CaseIterable {
    case all            = -1
    case wait           = 0
    case finish         = 2
    
    static func caseStatus(_ status: Int) -> Self? {
        if let scene = ChoreRecordScene(rawValue: status) {
            return scene
        }
        return nil
    }
    
    var icon: String {
        switch self {
        case .all:
            return ""
        case .wait:
            return "mine_chore_wait"
        case .finish:
            return "mine_chore_finish"
        }
    }
    
    var index: Int {
        switch self {
        case .all:
            return 0
        case .wait:
            return 1
        case .finish:
            return 2
        }
    }
    
    var value: Int? {
        switch self {
        case .all:
            return nil
        case .wait:
            return rawValue
        case .finish:
            return rawValue
        }
    }
    
    var title: String {
        switch self {
        case .all:
            return "all".meLocalizable()
        case .wait:
            return GlobalHelper.shared.inEndGid ? "inProgress".meLocalizable() : "pendingSettlement".meLocalizable()
        case .finish:
            return GlobalHelper.shared.inEndGid ? "completed".meLocalizable() : "alreadySettled".meLocalizable()
        }
    }
    
    var controller: JXSegmentedListContainerViewListDelegate {
        ChoreRecordContentController(scene: self)
    }
    
    var isEnable: Bool { self == .wait }
    
    var enableColor: UIColor {
        switch self {
        case .wait:
            return UIColor.hexStrToColor("#F99F35")
        case .finish:
            return UIColor.hexStrToColor("#999999")
        case .all:
            return UIColor.hexStrToColor("#999999")
        }
    }
    
    func enabelContent(_ content: String) -> String { content }
}
