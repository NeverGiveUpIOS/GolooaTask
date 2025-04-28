//
//  BuyCoinCell.swift
//  Golaa
//
//  Created by duke on 2024/5/24.
//

import UIKit

class BuyCoinCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildUI() {
        contentView.layer.cornerRadius = 12
        contentView.layer.borderColor = UIColor.xf2.cgColor
        contentView.layer.borderWidth = 2
        
        contentView.addSubview(icon)
        contentView.addSubview(coinLabel)
        contentView.addSubview(giveLabel)
        contentView.addSubview(priceLabel)
        
        icon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(15)
            make.width.height.equalTo(32)
        }
        
        coinLabel.snp.makeConstraints { make in
            make.leading.equalTo(icon.snp.trailing).offset(6)
            make.centerY.equalToSuperview()
        }
        
        giveLabel.snp.makeConstraints { make in
            make.leading.equalTo(coinLabel.snp.trailing).offset(5)
            make.trailing.lessThanOrEqualTo(priceLabel.snp.leading).offset(-10)
            make.centerY.equalToSuperview()
        }
        
        priceLabel.snp.makeConstraints { make in
            make.trailing.equalTo(-15)
            make.centerY.equalToSuperview()
        }
    }
    
    var model: PayProductListModel?
    func bind(model: PayProductListModel) {
        self.model = model
        
        coinLabel.text = "\(model.jinbi)"
        giveLabel.isHidden = model.freeJinbi <= 0
        giveLabel.text = String(format: "+%d %@", model.freeJinbi, "bonus".globalLocalizable())
        priceLabel.text = model.jiageDes
        contentView.layer.borderColor = model.isSelected ? UIColor.appColor.cgColor : UIColor.xf2.cgColor
    }
    
    private lazy var icon = UIImageView(image: .payCoin2)
    
    private lazy var coinLabel: UILabel = {
        let lab = UILabel()
        lab.font = .oswaldDemiBold(24)
        lab.textColor = .black
        return lab
    }()
    
    private lazy var giveLabel: UILabel = {
        let lab = UILabel()
        lab.font = UIFontMedium(14)
        lab.textColor = .black
        lab.isHidden = true
        return lab
    }()
    
    private lazy var priceLabel = {
        let lab = UILabel()
        lab.font = .oswaldDemiBold(18)
        lab.textColor = .hexStrToColor("#666666")
        return lab
    }()
}
