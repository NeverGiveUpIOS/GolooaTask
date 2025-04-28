//
//  GroupMemberApplyCell.swift
//  Golaa
//
//  Created by xiaoxuhui on 2024/5/24.
//

import UIKit

class GroupMemberApplyCell: GroupMemberBaseCell {
    
    var model: GroupApplyModel?
    
    var nextCompleted: ((_ status: Int, _ model: GroupApplyModel) -> Void)?
    
    override func buildUI() {
        super.buildUI()
        
        contentView.addSubview(avatar)
        contentView.addSubview(nameLabel)
        contentView.addSubview(remarkLabel)
        
        contentView.addSubview(agree)
        contentView.addSubview(refuse)
        
        avatar.snp.makeConstraints { make in
            make.size.equalTo(52)
            make.leading.equalTo(15)
            make.centerY.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.trailing.equalTo(-110)
            make.top.equalTo(avatar.snp.top).offset(5)
            make.leading.equalTo(avatar.snp.trailing).offset(10)
        }
        
        remarkLabel.snp.makeConstraints { make in
            make.trailing.equalTo(-110)
            make.leading.equalTo(nameLabel.snp.leading)
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
        }
        
        agree.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.trailing.equalTo(-15)
            make.centerY.equalToSuperview()
        }
        
        refuse.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(agree.snp.leading).offset(-25)
        }
    }
    
    func bind(model: GroupApplyModel) {
        self.model = model
        nameLabel.text = model.nickname
        remarkLabel.text = model.remark
        avatar.normalImageUrl(model.avatar)
        
        switch model.status {
        case -1:
            agree.isHidden = true
            refuse.isHidden = false
            refuse.image(.groupApplyRefuse.withRenderingMode(.alwaysTemplate))
            refuse.tintColor = .hexStrToColor("#999999")
            agree.isUserInteractionEnabled = false
            refuse.isUserInteractionEnabled = false
            refuse.snp.remakeConstraints { make in
                make.size.equalTo(24)
                make.trailing.equalTo(-15)
                make.centerY.equalToSuperview()
            }
        case 0:
            agree.isHidden = false
            refuse.isHidden = false
            agree.image(.groupApplyAgree)
            refuse.image(.groupApplyRefuse)
            agree.isUserInteractionEnabled = true
            refuse.isUserInteractionEnabled = true
        case 1:
            agree.isHidden = false
            refuse.isHidden = true
            agree.image(.groupApplyAgree.withRenderingMode(.alwaysTemplate))
            agree.tintColor = .hexStrToColor("#999999")
            agree.isUserInteractionEnabled = false
            refuse.isUserInteractionEnabled = false
            agree.snp.remakeConstraints { make in
                make.size.equalTo(24)
                make.trailing.equalTo(-15)
                make.centerY.equalToSuperview()
            }
        case 2:
            agree.isHidden = true
            refuse.isHidden = true
        default:
            agree.isHidden = true
            refuse.isHidden = true
        } 
    }
    
    // MARK: -
    // MARK: Lazy
    lazy var remarkLabel: UILabel = {
        let lab = UILabel()
        lab.font = UIFontSemibold(11)
        lab.textColor = .hexStrToColor("#000000", 0.3)
        return lab
    }()
    
    lazy var agree: UIButton = {
        let btn = UIButton(type: .custom)
        btn.image(.groupApplyAgree)
        btn.addTarget(self, action: #selector(agreeClick), for: .touchUpInside)
        return btn
    }()
    
    lazy var refuse: UIButton = {
        let btn = UIButton(type: .custom)
        btn.image(.groupApplyRefuse)
        btn.addTarget(self, action: #selector(refuseClick), for: .touchUpInside)
        return btn
    }()
}

extension GroupMemberApplyCell {
    
    @objc func agreeClick() {
        guard let model = model else { return }
        nextCompleted?(1, model)
    }
    
    @objc func refuseClick() {
        guard let model = model else { return }
        nextCompleted?(-1, model)
    }
}
