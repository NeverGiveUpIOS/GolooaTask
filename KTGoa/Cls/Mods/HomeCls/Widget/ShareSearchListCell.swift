//
//  ShareSearchListCell.swift
//  Golaa
//
//  Created by duke on 2024/5/22.
//

import UIKit

class ShareSearchListCell: UITableViewCell {
    var tapSelectBlock: ((ShareSearchListModel) -> Void)?
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
        contentView.addSubview(checkboxBtn)
        
        iconView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(15)
            make.width.height.equalTo(52)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconView.snp.trailing).offset(10)
            make.trailing.equalTo(checkboxBtn.snp.leading).offset(-15)
            make.centerY.equalToSuperview()
        }
        
        checkboxBtn.snp.makeConstraints { make in
            make.trailing.equalTo(-19.5)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(15)
        }
    }
    
    var model: ShareSearchListModel?
    func bind(model: ShareSearchListModel) {
        self.model = model
        iconView.normalImageUrl(model.avatar)
        nameLabel.text = model.name
        checkboxBtn.isSelected = model.isSelected
    }
    
    @objc private func clickCheckboxBtn(sender: UIButton) {
        guard let model = model else { return }
        tapSelectBlock?(model)
    }
    
    private lazy var iconView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.gt.setCornerRadius(26)
        return img
    }()
    
    private lazy var nameLabel: UILabel = {
        let lab = UILabel()
        lab.font = UIFontSemibold(15)
        lab.textColor = .black
        return lab
    }()
    
    private lazy var checkboxBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.image(.checkboxNor, .normal)
        btn.image(.checkboxSel, .selected)
        btn.addTarget(self, action: #selector(clickCheckboxBtn), for: .touchUpInside)
        return btn
    }()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        
    }

}
