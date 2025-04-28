//
//  PouchContentCell.swift
//  Golaa
//
//  Created by Cb on 2024/5/20.
//

import Foundation

class PouchContentCell: UICollectionViewCell {
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        configViews()
        configActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configViews() {
        contentView.gt.setCornerRadius(12)
        contentView.backgroundColor = .white
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.top.equalTo(15)
        }
        
        contentView.addSubview(rightIcon)
        rightIcon.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(0)
            make.centerY.equalTo(titleLabel)
        }
        
        contentView.addSubview(detailLabel)
        detailLabel.snp.makeConstraints { make in
            make.leading.equalTo(15)
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.trailing.equalTo(-5)
        }
    }
    
    private func configActions() {}
    
    private var type: PouchContentType?
    
    private var model: PouchContentModel?
    
    func configModel(_ model: PouchContentModel) {
        self.model = model
        detailLabel.text = model.model.totalAmtDes
        configType(model.type, model: model)
    }
    
    func configType(_ type: PouchContentType, model: PouchContentModel) {
        self.type = type
        titleLabel.text = type.rawValue
        detailLabel.textColor = type.showTextColor(totalAmt: model.model.totalAmt)
    }
    
    // MARK: - 属性
    private let titleLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.hexStrToColor("#999999")
        lab.font = UIFontSemibold(12)
        lab.numberOfLines = 0
        lab.text = ""
        return lab
    }()
    
    private let rightIcon = UIImageView(image: UIImage(named: "mine_pouch_arrow"))
    
    private let detailLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.hexStrToColor("#000000")
        lab.font = .oswaldDemiBold(26)
//        $0.numberOfLines = 0
        return lab
    }()
}
