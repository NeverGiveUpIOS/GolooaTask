//
//  GroupTableHeadCell.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/8/3.
//

import UIKit

class GroupTableHeadCell: GroupTableBaseCell {
    
    override func setupCoder() {
        super.setupCoder()
        addSubview(avatar)
        addSubview(idLabel)
        avatar.addSubview(avatarCamera)
        
        idLabel.snp.makeConstraints { make in
            make.trailing.equalTo(-15)
            make.centerY.equalTo(titleLabel.snp.centerY)
        }
        
        avatar.snp.makeConstraints { make in
            make.size.equalTo(100)
            make.leading.equalTo(0)
            make.top.equalTo(titleLabel.snp.bottom)
        }
        
        avatarCamera.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.bottom.trailing.equalTo(-8)
        }
    }
    
    lazy var avatar: UIImageView = {
        let img = UIImageView()
        img.gt.setCornerRadius(12)
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    lazy var idLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = .x9
        lab.font = UIFontReg(12)
        return lab
    }()
    
    lazy var avatarCamera: UIImageView = {
        let img = UIImageView()
        img.image = .groupAvatarTake
        return img
    }()
}
