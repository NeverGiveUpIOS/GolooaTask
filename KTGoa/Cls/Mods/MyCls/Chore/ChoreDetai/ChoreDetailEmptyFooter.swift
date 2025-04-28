//
//  ChoreDetailEmptyFooter.swift
//  Golaa
//
//  Created by Cb on 2024/5/21.
//

import Foundation

class ChoreDetailEmptyFooter: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configViews()
        configActions()
        configData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configViews() {
        backgroundColor = .white
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func configActions() {
        
    }
    
    private func configData() {
        titleLabel.text = "noDataAvailableUpdatedTheNext".meLocalizable()
        layer.cornerRadius = 10
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        layer.masksToBounds = true
    }
    
    // MARK: - 属性
    private let titleLabel: UILabel = {
        let lab = UILabel()
        lab.textAlignment = .center
        lab.textColor = UIColor.hexStrToColor("#999999")
        lab.font = .systemFont(ofSize: 12)
        lab.numberOfLines = 0
        return lab
    }()
}
