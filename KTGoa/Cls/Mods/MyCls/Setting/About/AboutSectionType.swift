//
//  AboutSectionType.swift
//  Golaa
//
//  Created by Cb on 2024/5/17.
//

import Foundation

enum AboutSectionType {
    case section(items: [AboutType])
}

extension AboutSectionType: SectionModelType {
    var items: [AboutType] {
        switch self {
        case .section(let items):
            return items
        }
    }
    
    init(original: AboutSectionType, items: [AboutType]) {
        switch original {
        case .section(let items):
            self = .section(items: items)
        }
    }
    
    typealias Item = AboutType
}

enum AboutType: CaseIterable, CellStyleable {
    case userAgree
    case privacy
    case contact
    
    static var modulues: [AboutType] { allCases }
    
    var rawValue: String {
        switch self {
        case .userAgree:
            return "userAgreement".meLocalizable()
        case .privacy:
            return "privacyPolicy".meLocalizable()
        case .contact:
            return "contactMe".meLocalizable()
        }
    }
    
    var roundStyle: CellRoundStyle {
        switch self {
        case .userAgree:
            return .top
        case .contact:
            return .bottom
        default:
            return .noRound
        }
    }
    
    func push() {
        switch self {
        case .userAgree:
            RoutinStore.push(.webScene(.agreement))
        case .privacy:
            RoutinStore.push(.webScene(.privacy))
        case .contact:
            RoutinStore.push(.contact)
        }
    }
}
