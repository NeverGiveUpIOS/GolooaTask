//
//  BroadcastType.swift
//  Golaa
//
//  Created by Cb on 2024/5/17.
//

import Foundation
import AudioUnit

enum BroadcastSectionType {
    case section(items: [BroadcastModel])
}

extension BroadcastSectionType: SectionModelType {
    var items: [BroadcastModel] {
        switch self {
        case .section(let items):
            return items
        }
    }
    
    init(original: BroadcastSectionType, items: [BroadcastModel]) {
        switch original {
        case .section(let items):
            self = .section(items: items)
        }
    }
    
    typealias Item = BroadcastModel
}

enum BroadcastType: CaseIterable, CellStyleable {
    case newMsgNotice
    case vibrate
    
    static var caseModels: [BroadcastModel] { allCases.map { BroadcastModel(type: $0, isSelect: $0 == .vibrate ? vibrateState : false) } }
    
    private static var vibrateState: Bool { UserDefaults.standard.bool(forKey: CacheKey.vibrateState) }
    
    // 震动反馈
    static func vibrateOccurred() {
        if !vibrateState { return }
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
    static func caseNoteState(_ note: Bool, list: [BroadcastModel]) -> [BroadcastModel] {
        var lists = list
        for (index, i) in list.enumerated() {
            if i.type == .newMsgNotice {
                lists[index].isSelect = note
            } else if i.type == .vibrate {
                lists[index].isSelect = vibrateState
            }
        }
        return lists
    }
    
    static func caseNoteStateModels(_ result: Bool) -> [BroadcastModel] {
        allCases.map {BroadcastModel(type: $0, isSelect: ($0 == .newMsgNotice ? result : false))}
    }
        
    // 展示的文字
    var rawValue: String {
        switch self {
        case .newMsgNotice:
            return "newMessageNotification".meLocalizable()
        case .vibrate:
            return "vibration".meLocalizable()
        }
    }
    
    var roundStyle: CellRoundStyle {
        switch self {
        case .newMsgNotice:
            return .top
        case .vibrate:
            return .bottom
        }
    }
}
