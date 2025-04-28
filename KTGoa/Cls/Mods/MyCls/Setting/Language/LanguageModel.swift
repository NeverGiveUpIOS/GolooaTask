//
//  LanguageModel.swift
//  Golaa
//
//  Created by Cb on 2024/5/16.
//

import Foundation

struct LanguageModel {
    var type: LanguageType
    var isSelect: Bool = false
    
    mutating func resetSelect(_ isSelect: Bool = false) {
        self.isSelect = isSelect
    }
}
