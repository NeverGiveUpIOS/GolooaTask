//
//  MineCell.swift
//  Golaa
//
//  Created by Cb on 2024/5/13.
//

import Foundation

class MineCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configViews()
    }
    
    func configViews() {
        backgroundColor = .white
        contentView.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.width.height.equalTo(MineLayout.iconHeight)
            make.centerX.top.equalToSuperview()
        }

        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(icon.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 属性
    let icon: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    let titleLabel: UILabel = {
        let lab = UILabel()
        lab.numberOfLines = 0
        lab.textAlignment = .center
        lab.textColor = .black
        lab.font = UIFontReg(12)
        return lab
    }()
}
