//
//  GroupTableBaseCell.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/8/3.
//

import UIKit

class GroupTableBaseCell: UIView {
    
    lazy var titleLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = .black
        lab.font = UIFontMedium(14)
        return lab
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCoder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCoder() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.height.equalTo(50)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
        }
    }
}
