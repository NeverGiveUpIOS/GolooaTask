//
//  AboutCell.swift
//  Golaa
//
//  Created by Cb on 2024/5/17.
//

import Foundation

class AboutCell: SettingBasicCell {
    
    func configItem(_ item: AboutType) {
        self.item = item
        titleLabel.text = item.rawValue
        item.roundView(bgView)
    }
    
    // MARK: - 属性
    var item: AboutType?
}
