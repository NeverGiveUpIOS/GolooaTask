//
//  ChorePublishHeaderCell.swift
//  Golaa
//
//  Created by Cb on 2024/6/15.
//

import UIKit

class ChorePublishHeaderCell: ChorePublishCell {
    
    override func configViews() {
        contentView.backgroundColor = .white
        contentView.gt.setCornerRadius(8)
        
        contentView.addSubview(avatarIcon)
        avatarIcon.snp.makeConstraints { make in
            make.width.height.equalTo(66)
            make.top.leading.equalTo(15)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarIcon)
            make.leading.equalTo(avatarIcon.snp.trailing).offset(12)
            make.trailing.equalTo(-15)
        }
        
        contentView.addSubview(countLabel)
        countLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarIcon.snp.trailing).offset(12)
            make.top.equalTo(titleLabel.snp.bottom).offset(7)
        }
                
        contentView.addSubview(bottomContainer)
        bottomContainer.snp.makeConstraints { make in
            make.height.equalTo(79)
            make.leading.equalTo(15)
            make.bottom.trailing.equalTo(-15)
        }
                
        contentView.addSubview(supplyLabel)
        supplyLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarIcon.snp.trailing).offset(12)
            make.trailing.equalTo(-15)
            make.bottom.equalTo(bottomContainer.snp.top).offset(-12)
        }
        
        bottomContainer.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(-12)
        }
        
        if !GlobalHelper.shared.inEndGid {
            stackView.addArrangedSubview(leftStackView)
            leftStackView.addArrangedSubview(leftLabel)
            leftStackView.addArrangedSubview(leftDetailLabel)
        }
        
        stackView.addArrangedSubview(middleStackView)
        middleStackView.addArrangedSubview(middleLabel)
        middleStackView.addArrangedSubview(middleDetailLabel)
        
        stackView.addArrangedSubview(rightStackView)
        rightStackView.addArrangedSubview(rightLabel)
        rightStackView.addArrangedSubview(rightDetailLabel)

    }

}
