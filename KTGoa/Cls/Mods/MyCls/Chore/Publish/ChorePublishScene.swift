//
//  ChorePublishScene.swift
//  Golaa
//
//  Created by Cb on 2024/5/21.
//

import Foundation

enum ChorePublishScene: Int, CaseIterable {
    case all                        = -1                // 全部
    case needCheck                  = 0                 // 待核对
    case checked                    = 2                 // 已核对
    case finish                     = 3                 // 已完成
    case appeal                     = 1                 // 申诉中
    
    var value: Int? {
        if self == .all { return nil }
        return rawValue
    }
    
    var title: String {
        switch self {
        case .all:
            return "all".meLocalizable()
        case .needCheck:
            return "toBeVerified".meLocalizable()
        case .checked:
            return "verified".meLocalizable()
        case .finish:
            return "completed".meLocalizable()
        case .appeal:
            return "appeal".meLocalizable()
        }
    }
    
    var controller: JXSegmentedListContainerViewListDelegate {
        ChorePublishContentController(scene: self)
    }
    
    static func caseStatus(_ status: Int) -> Self? {
        if let scene = ChorePublishScene(rawValue: status) {
            return scene
        }
        return nil
    }
    
    var icon: String {
        switch self {
        case .needCheck:
            return "mine_publish_uncheck"
        case .checked:
            return "mine_publish_checked"
        case .finish:
            return "mine_publish_finish"
        case .appeal:
            return "mine_publish_appeal"
        case .all:
            return ""
        }
    }
    
    var isEnable: Bool { self == .appeal || self == .needCheck }

    var enableColor: UIColor {
        switch self {
        case .needCheck:
            return UIColor.hexStrToColor("#F99F35")
        case .checked:
            return UIColor.hexStrToColor("#999999")
        case .finish:
            return UIColor.hexStrToColor("#999999")
        case .appeal:
            return UIColor.hexStrToColor("#F96464")
        case .all:
            return UIColor.hexStrToColor("#999999")
        }
    }
    
    func enabelContent(_ content: String) -> String {
        content + (self == .needCheck ? ">>" : "")
    }

}
