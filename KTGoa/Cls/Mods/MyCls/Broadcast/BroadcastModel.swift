//
//  BroadcastModel.swift
//  Golaa
//
//  Created by Cb on 2024/5/17.
//

import Foundation

struct BroadcastModel {
    var type: BroadcastType
    var isSelect: Bool = false
    
    mutating func resetSelect(_ isSelect: Bool = false) {
        self.isSelect = isSelect
    }
}
