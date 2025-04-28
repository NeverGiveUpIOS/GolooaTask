//
//  GroupMemberCell.swift
//  Golaa
//
//  Created by xiaoxuhui on 2024/5/24.
//

import UIKit

class GroupMemberCell: GroupMemberBaseCell {
    
    var muteBlock: ((_ model: GroupMemberModel) -> Void)?
    var kickBlock: ((_ model: GroupMemberModel) -> Void)?
    
    var model: GroupMemberModel?
    
    override func buildUI() {
        super.buildUI()
        
        contentView.addSubview(avatar)
        contentView.addSubview(nameLabel)
        contentView.addSubview(muteDer)
        contentView.addSubview(kickDer)
        
        
        muteDer.addSubview(muteEr)
        kickDer.addSubview(kickEr)
        
        avatar.snp.makeConstraints { make in
            make.size.equalTo(52)
            make.leading.equalTo(15)
            make.centerY.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(avatar.snp.trailing).offset(10)
            make.trailing.lessThanOrEqualTo(muteDer.snp.leading).offset(-10)
        }
        
        kickDer.snp.makeConstraints { make in
            make.height.equalTo(36)
            make.trailing.equalTo(-15)
            make.centerY.equalToSuperview()
        }
        
        muteDer.snp.makeConstraints { make in
            make.height.equalTo(36)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(kickDer.snp.leading).offset(-10)
        }
        
        muteEr.snp.makeConstraints { make in
            make.leading.equalTo(10)
            make.trailing.equalTo(-10)
            make.top.bottom.equalToSuperview()
            make.width.greaterThanOrEqualTo(50)
        }
        
        kickEr.snp.makeConstraints { make in
            make.leading.equalTo(10)
            make.trailing.equalTo(-10)
            make.top.bottom.equalToSuperview()
            make.width.greaterThanOrEqualTo(50)
        }
    }
    
    func bind(model: GroupMemberModel) {
        self.model = model
        nameLabel.text = model.name
        avatar.headerImageUrl(model.avtr)
        
        if model.mute {
            muteEr.title("unmute".msgLocalizable())
        } else {
            muteEr.title("mute".msgLocalizable())
        }
        
        muteDer.isHidden = true
        kickDer.isHidden = true
        
        guard let group = model.group else {
            muteDer.isHidden = true
            kickDer.isHidden = true
            return
        }
        
        if model.juese == .owner {
            muteDer.isHidden = true
            kickDer.isHidden = true
        } else if group.isAdmin {
            muteDer.isHidden = false
            kickDer.isHidden = false
        } else {
            muteDer.isHidden = true
            kickDer.isHidden = true
        }
    }
    
    // MARK: -
    // MARK: Lazy
    lazy var muteEr: UIButton = {
        let btn = UIButton(type: .custom)
        btn.textColor(.white)
        btn.font(UIFontReg(14))
        btn.title("mute".msgLocalizable())
        btn.addTarget(self, action: #selector(muteErClick), for: .touchUpInside)
        return btn
    }()
    
    lazy var kickEr: UIButton = {
        let btn = UIButton(type: .custom)
        btn.textColor(.black)
        btn.font(UIFontReg(14))
        btn.title("remove".msgLocalizable())
        btn.addTarget(self, action: #selector(kickErClick), for: .touchUpInside)
        return btn
    }()
    
    lazy var kickDer: UIView = {
        let view = UIView()
        view.gt.setCornerRadius(36 * 0.5)
        view.backgroundColor = .appColor
        return view
    }()
    
    lazy var muteDer: UIView = {
        let view = UIView()
        view.gt.setCornerRadius(36 * 0.5)
        view.backgroundColor = UIColorHex("#F96464")
        return view
    }()
}

extension GroupMemberCell {
    
    @objc func muteErClick() {
        guard let model = model else { return }
        muteBlock?(model)
    }
    
    @objc func kickErClick() {
        guard let model = model else { return }
        kickBlock?(model)
    }
}
