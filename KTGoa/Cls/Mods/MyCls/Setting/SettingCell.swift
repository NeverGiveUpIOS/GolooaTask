//
//  SettingCell.swift
//  Golaa
//
//  Created by Cb on 2024/5/15.
//

import Foundation

class SettingCell: SettingBasicCell {
    
    func configItem(_ item: SettingType) {
        self.item = item
        titleLabel.text = item.rawValue
        item.roundView(bgView)
    }
    
    // MARK: - 属性
    private var item: SettingType?
}
