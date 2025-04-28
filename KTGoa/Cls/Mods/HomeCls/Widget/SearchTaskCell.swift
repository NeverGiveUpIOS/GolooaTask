//
//  SearchTaskCell.swift
//  Golaa
//
//  Created by duke on 2024/5/21.
//

import UIKit

class SearchTaskCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildUI() {
        contentView.addSubview(iconView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        
        iconView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(15)
            make.width.height.equalTo(60)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconView.snp.trailing).offset(12)
            make.top.equalTo(iconView.snp.top).offset(6)
            make.trailing.equalTo(-15)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.leading.equalTo(nameLabel.snp.leading)
        }
    }
    
    var model: HomeListModel?
    func bind(model: HomeListModel) {
        self.model = model
        iconView.normalImageUrl(model.img)
        nameLabel.text("\(model.name)\(model.search)")
        nameLabel.gt.setSpecificTextColor(model.search, color: .hexStrToColor("#697FF0"))
        priceLabel.text = model.picDes
    }
    
    private lazy var iconView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.gt.setCornerRadius(8)
        return img
    }()
    
    private lazy var nameLabel: UILabel = {
        let lab = UILabel()
        lab.font = UIFontSemibold(14)
        lab.textColor = .black
        return lab
    }()
    
    private lazy var priceLabel: UILabel = {
        let lab = UILabel()
        lab .font = .oswaldDemiBold(16)
        lab .textColor = .hexStrToColor("#FF5722")
        return lab
    }()

    override func setSelected(_ selected: Bool, animated: Bool) {
       
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        
    }

}
