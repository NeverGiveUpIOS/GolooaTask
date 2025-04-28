//
//  GroupMemberAddCell.swift
//  Golaa
//
//  Created by xiaoxuhui on 2024/5/24.
//

import UIKit

class GroupMemberAddCell: GroupMemberBaseCell {
    
    var model: GUsrInfo?
    var selValues: [String] = []
    var selectedBlock: ((_ model: GUsrInfo) -> Void)?
    
    override func buildUI() {
        super.buildUI()
        contentView.addSubview(avatar)
        contentView.addSubview(nameLabel)
        contentView.addSubview(selLabel)
        
        avatar.snp.makeConstraints { make in
            make.size.equalTo(52)
            make.leading.equalTo(15)
            make.centerY.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(avatar.snp.trailing).offset(10)
            make.trailing.equalTo(selLabel.snp.leading).offset(-5)
        }
        
        selLabel.snp.makeConstraints { make in
            make.size.equalTo(60)
            make.trailing.equalTo(-5)
            make.centerY.equalToSuperview()
        }
    }
    
    func bind(model: GUsrInfo, ids: [String]) {
        self.model = model
        nameLabel.text = model.nickname
        avatar.normalImageUrl(model.avatar)
        selLabel.isSelected = model.isSel
    }
    
    // MARK: -
    // MARK: Lazy
    lazy var selLabel: UIButton = {
        let btn = UIButton()
        btn.image(.groupNor, .normal)
        btn.image(.groupSel, .selected)
        btn.addTarget(self, action: #selector(selectedClick), for: .touchUpInside)
        return btn
    }()
    
    @objc func selectedClick() {
        guard let model = model else { return }
        selectedBlock?(model)
    }
}
