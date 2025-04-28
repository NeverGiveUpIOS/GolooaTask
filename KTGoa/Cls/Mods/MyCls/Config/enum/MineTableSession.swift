//
//  MineTableSession.swift
//  Golaa
//
//  Created by Cb on 2024/5/13.
//

import Foundation

enum MineTableSession {
    case section(type: MineTableModule, items: [MineTableModule])
}

extension MineTableSession: SectionModelType, MineCellLayoutable {
    typealias Item = MineTableModule
    
    var items: [MineTableModule] {
        switch self {
        case .section(_, let items):
            return items
        }
    }
    
    init(original: MineTableSession, items: [MineTableModule]) {
        switch original {
        case .section(let type, let items):
            self = .section(type: type, items: items)
        }
    }
    
    var isTask: Bool {
        switch self {
        case .section(let type, _):
            return type.isTask
        }
    }
    
    var isHeader: Bool {
        switch self {
        case .section(let type, _):
            return type.isHeader
        }
    }
    
    func itemWidth(indexPath: IndexPath) -> CGFloat {
        screW
    }
    
    static func caseList() -> [MineTableSession] {
        let model = LoginTl.shared.userInfo ?? GUsrInfo()
        var list = [
            MineTableSession.section(type: .header, items: [MineTableModule.header]),
            MineTableSession.section(type: .task, items: [MineTableModule.task]),
            MineTableSession.section(type: .common, items: [MineTableModule.common])
        ]
        if model.isAgent && !GlobalHelper.shared.inEndGid { // 是代理商，且不是审核状态
            list.append(MineTableSession.section(type: .agent, items: [MineTableModule.agent]))
        }
        return list
    }
    
}

enum MineTableModule: MineCellLayoutable {
    case header
    case task
    case common
    case agent
    
    var title: String {
        switch self {
        case .header:
            return ""
        case .task:
            return "taskRecords".meLocalizable()
        case .common:
            return "commonFeatures".meLocalizable()
        case .agent:
            return "agencyFunction".meLocalizable()
        }
    }
    
    var isTask: Bool { self == .task }
    var isHeader: Bool { self == .header }
    
    var moduleList: [MineCellLayoutable] {
        switch self {
        case .header:
            return MineHeaderType.modules
        case .task:
            return MineTaskType.modules
        case .common:
            return MineCommonType.modules
        case .agent:
            return MineAgentType.modules
        }
    }
    
    func itemHeight(section: Int) -> CGFloat {
        switch self {
        case .header:
            return MineHeaderType.totalHeight()
        case .task:
            return MineTaskType.totalHeight()
        case .common:
            return MineCommonType.totalHeight()
        case .agent:
            return MineAgentType.totalHeight()
        }
    }
}
