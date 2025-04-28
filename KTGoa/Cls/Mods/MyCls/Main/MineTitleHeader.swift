//
//  MineTitleHeader.swift
//  Golaa
//
//  Created by Cb on 2024/5/13.
//

import Foundation

class MineTitleHeader: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configViews()
        configActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configViews() {
        backgroundColor = .white
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(MineLayout.headerLeading)
            make.top.equalToSuperview().offset(MineLayout.padingLeading)
        }
    }
    
    private func configActions() {}
    
    // MARK: - 属性
    let titleLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = .black
        lab.font = .boldSystemFont(ofSize: 16)
        return lab
    }()
}
