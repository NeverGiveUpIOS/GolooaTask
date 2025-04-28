//
//  CoinRecordCell.swift
//  Golaa
//
//  Created by duke on 2024/5/25.
//

import UIKit

class CoinRecordCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildUI() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(priceLabel)
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.leading.equalTo(15)
            make.trailing.lessThanOrEqualTo(priceLabel.snp.leading).offset(-10)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(6)
            make.leading.equalTo(15)
            make.bottom.equalTo(-10)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.trailing.equalTo(-15)
            make.centerY.equalToSuperview()
        }
    }
    
    var model: CoinRecordModel?
    func bind(model: CoinRecordModel) {
        self.model = model
        nameLabel.text(model.text)
        nameLabel.gt.setSpecificTextColor(model.high, color: .hexStrToColor("#F99F35"))
        timeLabel.text = model.addDateDes
        priceLabel.text = model.tradeJinerDes
        priceLabel.textColor = model.fType == .disburse ? .hexStrToColor("#F96464") : .hexStrToColor("#2697FF")
    }
    
    private lazy var nameLabel: UILabel = {
        let lab = UILabel()
        lab.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        lab.font = UIFontReg(14)
        lab.textColor = .black
        lab.numberOfLines = 0
        return lab
    }()
    
    private lazy var timeLabel: UILabel = {
        let lab = UILabel()
        lab.font = UIFontReg(12)
        lab.textColor = .hexStrToColor("#CBCBCB")
        return lab
    }()
    
    private lazy var priceLabel: UILabel = {
        let lab = UILabel()
        lab.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        lab.font = .oswaldDemiBold(16)
        lab.textColor = .hexStrToColor("#2697FF")
        return lab
    }()

    override func setSelected(_ selected: Bool, animated: Bool) {

    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        
    }
}
