//
//  LanguageCell.swift
//  Golaa
//
//  Created by Cb on 2024/5/16.
//

import Foundation

class LanguageCell: SettingBasicCell {
    
    func configItem(_ item: LanguageModel) {
        self.item = item
        titleLabel.text = item.type.rawValue
        item.type.roundView(bgView)
        let icon = item.isSelect ? "language_select" : "language_no_select"
        rightBtn.setImage(UIImage(named: icon), for: .normal)
    }
    
    // MARK: - 属性
    private var item: LanguageModel?
}
