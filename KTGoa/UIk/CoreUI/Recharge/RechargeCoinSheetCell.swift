//
//  RechargeCoinSheetCell.swift
//  Golaa
//
//  Created by duke on 2024/5/23.
//

import UIKit

class RechargeCoinSheetCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildUI() {
        contentView.layer.cornerRadius = 12
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.xf2.cgColor
        
        contentView.addSubview(coinView)
        coinView.addSubview(icon)
        coinView.addSubview(coinLabel)
        contentView.addSubview(priceLabel)
        
        coinView.snp.makeConstraints { make in
            make.top.equalTo(16.5)
            make.centerX.equalToSuperview()
            make.height.equalTo(24)
            make.leading.greaterThanOrEqualTo(0)
            make.trailing.lessThanOrEqualTo(0)
        }
        
        icon.snp.makeConstraints { make in
            make.leading.bottom.top.equalToSuperview()
            make.width.equalTo(24)
        }
        
        coinLabel.snp.makeConstraints { make in
            make.centerY.equalTo(icon.snp.centerY)
            make.leading.equalTo(icon.snp.trailing).offset(4)
            make.trailing.equalToSuperview()
        }
        
        priceLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(-13)
        }
    }
    
    var model: PayProductListModel?
    func bind(model: PayProductListModel) {
        self.model = model
        coinLabel.text = "\(model.jinbi)"
        priceLabel.text = model.jiageDes
        contentView.layer.borderColor = model.isSelected ? UIColor.appColor.cgColor : UIColor.xf2.cgColor
    }
    
    private lazy var icon: UIImageView = {
        let img = UIImageView()
        img.image = .payCoin2
        return img
    }()
    
    private lazy var coinView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var coinLabel: UILabel = {
        let lab = UILabel()
        lab.font = UIFontSemibold(18)
        lab.textColor = .black
        return lab
    }()
    
    private lazy var priceLabel: UILabel = {
        let lab = UILabel()
        lab.font = UIFontSemibold(14)
        lab.textColor = .hexStrToColor("#999999")
        lab.textAlignment = .center
        return lab
    }()
}
