//
//  MineMinCell.swift
//  Golaa
//
//  Created by Cb on 2024/5/27.
//

import Foundation

class MineMinCell: MineCell {
    override func configViews() {
        super.configViews()
        icon.snp.remakeConstraints { make in
            make.width.height.equalTo(MineLayout.iconMinHeight)
            make.centerX.top.equalToSuperview()
        }
    }
}
