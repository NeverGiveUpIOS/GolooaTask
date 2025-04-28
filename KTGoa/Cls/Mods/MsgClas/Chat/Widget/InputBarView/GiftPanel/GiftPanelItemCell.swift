//
//  GiftPanelItemCell.swift
//  Golaa
//
//  Created by chenkaisong on 2024/5/23.
//

import UIKit

class GiftPanelItemCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var model: GiftItemModel? {
        didSet {
            guard let model = model else { return  }
            
            pic.normalImageUrl(model.icon)
            name.text = model.name
            price.setTitle(" \(model.coin)", for: .normal)
            price.setImage(.msgGiftCoin, for: .normal)
            containerView.setBoardLine(model.isSelected ? .appColor : .clear, 2)
            containerView.gt.setCornerRadius(model.isSelected ? 10 : 0)
        }
    }
    
    lazy var containerView: UIView = {
        let view = UIView(frame: .zero)
        return view
    }()
    
    /// 图片
    private lazy var pic: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var name: UILabel = {
        let label = UILabel()
        label.font = UIFontReg(14)
        label.textColor = .black
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    lazy var price: UIButton = {
        let button = UIButton(type: .custom)
        button.contentHorizontalAlignment = .center
        button.setTitleColor(.hexStrToColor("#999999"), for: .normal)
        button.titleLabel?.font = UIFontReg(15)
        return button
    }()
    
}

extension GiftPanelItemCell {
    
    private func setupSubviews() {
        
        containerView.addSubview(pic)
        containerView.addSubview(name)
        containerView.addSubview(price)
        contentView.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.bottom.equalTo(-12)
        }
        
        pic.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(5)
            make.width.height.equalTo(60)
            make.height.equalTo(pic.snp.width)
        }
        
        name.snp.makeConstraints { make in
            make.leading.equalTo(3)
            make.trailing.equalTo(-3)
            make.top.equalTo(pic.snp.bottom).offset(6)
        }
        
        price.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(-3)
        }
    }
    
}
