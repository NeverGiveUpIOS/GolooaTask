//
//  AccuseTypeCell.swift
//  Golaa
//
//  Created by duke on 2024/5/29.
//

import UIKit

class AccuseTypeCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildUI() {
        contentView.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    var model: AccuseTypeModel?
    func bind(model: AccuseTypeModel) {
        self.model = model
        
        label.text = model.name
        label.layer.borderWidth = model.isSelected ? 1 : 0
        label.backgroundColor = model.isSelected ? .hexStrToColor("#FFDA00", 0.3) : .xf2
    }
    
    private lazy var label: GTPaddingLabel = {
        let lab = GTPaddingLabel()
        lab.textColor = .black
        lab.font = UIFontReg(14)
        lab.paddingTop = 9
        lab.paddingLeft = 18
        lab.paddingBottom = 9
        lab.paddingRight = 18
        lab.gt.setCornerRadius(21)
        lab.layer.borderColor = UIColor.appColor.cgColor
        return lab
    }()
}
