//
//  SettingType.swift
//  Golaa
//
//  Created by Cb on 2024/5/15.
//

import Foundation

enum CellRoundStyle {
    case top
    case bottom
    case noRound
    case all
}

protocol CellStyleable {
    var roundRadius: CGFloat { get }
    var roundStyle: CellRoundStyle { get }
    func roundView(_ view: UIView)
}

extension CellStyleable {
    var roundRadius: CGFloat { 12.0 }
    
    var roundStyle: CellRoundStyle { .noRound }
    
    func roundView(_ view: UIView) {
        var maskedCorners: CACornerMask = []
        var radius = 0.0
        switch roundStyle {
        case .top:
            radius = roundRadius
            maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        case .bottom:
            radius = roundRadius
            maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        case .noRound:
            radius = 0.0
            maskedCorners = []
        default:
            radius = roundRadius
            maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        }
        view.layer.cornerRadius = radius
        view.layer.maskedCorners = maskedCorners
        view.layer.masksToBounds = true
    }
}

enum SettingType: CaseIterable, CellStyleable {
    case language
    case broadcast
//    case faceScore
    case denyList
    case fillCode
    case about
    case writeOff
    
    static var modulues: [SettingType] { allCases }
    
    var rawValue: String {
        switch self {
        case .language:
            return "languageSettings".meLocalizable()
        case .broadcast:
            return "notificationSettings".meLocalizable()
//        case .faceScore:
//            return "beautySetting".meLocalizable()
        case .denyList:
            return "blacklist".meLocalizable()
        case .fillCode:
            return "invitationCode".meLocalizable()
        case .about:
            return "aboutUs".meLocalizable()
        case .writeOff:
            return "accountDeactivation".meLocalizable()
        }
    }
    
    var roundStyle: CellRoundStyle {
        switch self {
        case .language:
            return .top
        case .writeOff:
            return .bottom
        default:
            return .noRound
        }
    }
    
    func push() {
        switch self {
        case .language:
            RoutinStore.push(.language)
        case .broadcast:
            RoutinStore.push(.broadcast)
        case .denyList:
            RoutinStore.push(.denyList)
        case .fillCode:
            RoutinStore.push(.fillCode)
        case .about:
            RoutinStore.push(.about)
        case .writeOff:
            RoutinStore.push(.writeOff)
//        default:
//            break
        }
    }
}

enum SettingSectionType {
    case section(items: [SettingType])
}

extension SettingSectionType: SectionModelType {
    var items: [SettingType] {
        switch self {
        case .section(let items):
            return items
        }
    }
    
    init(original: SettingSectionType, items: [SettingType]) {
        switch original {
        case .section(let items):
            self = .section(items: items)
        }
    }
    
    typealias Item = SettingType
}
