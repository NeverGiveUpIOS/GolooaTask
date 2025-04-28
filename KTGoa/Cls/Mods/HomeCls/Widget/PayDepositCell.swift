//
//  PayDepositCell.swift
//  Golaa
//
//  Created by duke on 2024/5/17.
//

import UIKit

class PayDepositCell: UICollectionViewCell {
    private let itemW = (screW - 30 - 18*2)/3.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildUI() {
        contentView.addSubview(itemBtn)
        itemBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(itemW)
            make.height.equalTo(55)
        }
    }
    
    var model: PayDepositModel?
    func bind(model: PayDepositModel) {
        self.model = model
        itemBtn.setTitle(model.value, for: .normal)
        if !model.isEnabled {
            itemBtn.layer.borderWidth = 0
            itemBtn.backgroundColor = .xf2
            itemBtn.setTitleColor(.hexStrToColor("#999999"), for: .normal)
        } else {
            itemBtn.layer.borderWidth = 2
            itemBtn.layer.borderColor = model.isSelected ? UIColor.appColor.cgColor : UIColor.xf2.cgColor
            itemBtn.backgroundColor = .clear
            itemBtn.setTitleColor(.black, for: .normal)
        }
        
        let textSize = model.value.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 25), options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [.font: UIFontSemibold(18)], context: nil).size
        itemBtn.snp.updateConstraints { make in
            make.width.equalTo(max(itemW, textSize.width + 50))
        }
    }
    
    private lazy var itemBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFontSemibold(18)
        btn.layer.borderWidth = 2
        btn.layer.borderColor = UIColor.xf2.cgColor
        btn.layer.cornerRadius = 8
        btn.isUserInteractionEnabled = false
        return btn
    }()
}
