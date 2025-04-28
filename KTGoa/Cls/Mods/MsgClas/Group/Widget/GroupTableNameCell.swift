//
//  GroupTableNameCell.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/8/3.
//

import UIKit

class GroupTableNameCell: GroupTableBaseCell {
    
    override func setupCoder() {
        super.setupCoder()
        addSubview(nameLabel)
        addSubview(editNameBtn)
        
        nameLabel.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
        editNameBtn.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.trailing.equalTo(-15)
            make.centerY.equalTo(nameLabel)
        }
    }
    
    lazy var nameLabel: UITextField = {
        let text = UITextField()
        text.gt.setCornerRadius(8)
        text.textColor = .black
        text.backgroundColor = .xf2
        text.font = UIFontReg(14)
        text.gt.addLeftTextPadding(10)
        text.isUserInteractionEnabled = false
        return text
    }()
    
    lazy var editNameBtn: UIButton = {
        let bt = UIButton()
        bt.image(.groupEditName)
        return bt
    }()
}
