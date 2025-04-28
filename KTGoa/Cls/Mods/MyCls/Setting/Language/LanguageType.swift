//
//  LanguageType.swift
//  Golaa
//
//  Created by Cb on 2024/5/16.
//

import Foundation

enum LanguageSectionType {
    case section(items: [LanguageModel])
}

extension LanguageSectionType: SectionModelType {
    var items: [LanguageModel] {
        switch self {
        case .section(let items):
            return items
        }
    }
    
    init(original: LanguageSectionType, items: [LanguageModel]) {
        switch original {
        case .section(let items):
            self = .section(items: items)
        }
    }
    
    typealias Item = LanguageModel
}

enum LanguageType: CaseIterable, CellStyleable {
    case zhHans
    case en
    case portuguese
    
    /*
     zh-CN => 中文（简体）
     zh => 中文（繁体）
     vi => 越南语
     en => 英语
     ja-JP => 日语
     ko-KR => 韩语
     in-ID => 印尼语
     th-TH => 泰语
     pt => 葡萄牙语
     */
    
    static var caseModels: [LanguageModel] { allCases.map { LanguageModel(type: $0, isSelect: LanguageTl.shared.curLanguage == $0) } }
    
    static func caseLangValue(_ value: String) -> Self {
        for i in allCases where i.netValue == value {
            return i
        }
        return .en
    }
    
    var netValue: String {
        switch self {
        case .zhHans:
            return "zh-CN"
        case .en:
            return "en"
        case .portuguese:
            return "pt"
        }
    }
    
    // 国际化语言本地文件命名
    var lprojValue: String {
        switch self {
        case .zhHans:
            return "zh-Hans"
        case .en:
            return "en"
        case .portuguese:
            return "pt-BR"
        }
    }
    
    // 展示的文字
    var rawValue: String {
        switch self {
        case .zhHans:
            return "简体中文"
        case .en:
            return "English"
        case .portuguese:
            return "Português"
        }
    }
    
    var roundStyle: CellRoundStyle {
        switch self {
        case .zhHans:
            return .top
        case .en:
            return .noRound
        case .portuguese:
            return .bottom
        }
    }
}
