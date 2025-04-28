//
//  PayDepositModel.swift
//  Golaa
//
//  Created by duke on 2024/5/17.
//

import UIKit

class PayDepositModel: NSObject {
    var value = ""
    var isSelected = false
    var isEnabled = true
    init(value: String, isSelected: Bool = false, isEnabled: Bool = true) {
        self.value = value
        self.isSelected = isSelected
        self.isEnabled = isEnabled
    }
}
