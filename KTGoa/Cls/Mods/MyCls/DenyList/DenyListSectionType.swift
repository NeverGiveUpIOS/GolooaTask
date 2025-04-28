//
//  DenyListSectionType.swift
//  Golaa
//
//  Created by Cb on 2024/5/17.
//

import Foundation

enum DenyListSectionType {
    case section(items: [DenyListModel])
}

extension DenyListSectionType: SectionModelType {
    var items: [DenyListModel] {
        switch self {
        case .section(let items):
            return items
        }
    }
    
    init(original: DenyListSectionType, items: [DenyListModel]) {
        switch original {
        case .section(let items):
            self = .section(items: items)
        }
    }
    
    typealias Item = DenyListModel
}
