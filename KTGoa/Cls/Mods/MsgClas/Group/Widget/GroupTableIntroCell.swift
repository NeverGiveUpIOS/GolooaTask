//
//  GroupTableIntroCell.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/8/3.
//

import UIKit

class GroupTableIntroCell: GroupTableBaseCell {
    
    override func setupCoder() {
        super.setupCoder()
        addSubview(limitText)
        limitText.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.bottom.trailing.equalToSuperview()
        }
    }
    
    lazy var limitText: LimitedTextView = {
        let view = LimitedTextView()
        view.gt.setCornerRadius(8)
        view.backgroundColor = .xf2
        return view
    }()
}
