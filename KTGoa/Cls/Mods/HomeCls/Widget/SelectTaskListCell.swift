//
//  SelectTaskListCell.swift
//  Golaa
//
//  Created by duke on 2024/5/22.
//

import UIKit

class SelectTaskListCell: UITableViewCell {
    var tapSendBlock: ((SelectTaskListModel) -> Void)?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.addSubview(container)
        container.addSubview(iconView)
        container.addSubview(nameLabel)
        if !GlobalHelper.shared.inEndGid {
            container.addSubview(priceLabel)
        }
        container.addSubview(sendBtn)
        
        container.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.height.equalTo(90)
        }
        
        iconView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(15)
            make.width.height.equalTo(60)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconView.snp.trailing).offset(15)
            make.top.equalTo(iconView).offset(8)
            make.trailing.equalTo(sendBtn.snp.leading).offset(-15)
        }
        
        if !GlobalHelper.shared.inEndGid {
            priceLabel.snp.makeConstraints { make in
                make.top.equalTo(nameLabel.snp.bottom).offset(6)
                make.leading.equalTo(nameLabel)
            }
        }
        
        sendBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(-15)
            make.width.equalTo(76)
            make.height.equalTo(40)
        }
    }
    
    var model: SelectTaskListModel?
    func bind(model: SelectTaskListModel) {
        self.model = model
        
        iconView.normalImageUrl(model.img)
        nameLabel.text = model.name
        priceLabel.text = model.jiageDes
    }
    
    @objc private func clickSendBtn(sender: UIButton) {
        guard let model = model else { return }
        tapSendBlock?(model)
    }
    
    private lazy var container:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.gt.setCornerRadius(12)
        return view
    }()
    
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
        lab.font = .oswaldDemiBold(16)
        lab.textColor = UIColorHex("#F06C3C")
        return lab
    }()
    
    private lazy var sendBtn: UIButton =  {
        let btn = UIButton(type: .custom)
        btn.setTitle("send".msgLocalizable(), for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFontSemibold(14)
        btn.backgroundColor = .appColor
        btn.gt.setCornerRadius(8)
        btn.addTarget(self, action: #selector(clickSendBtn), for: .touchUpInside)
        return btn
    }()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        
    }
}
