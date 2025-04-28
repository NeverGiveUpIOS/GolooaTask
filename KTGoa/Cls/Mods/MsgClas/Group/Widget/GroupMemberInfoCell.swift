//
//  GroupMemberInfoCell.swift
//  Golaa
//
//  Created by duke on 2024/5/9.
//

import UIKit

class GroupMemberInfoCell: UICollectionViewCell {
    var model: GroupMemberModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildUI() {
        
        contentView.addSubview(avatarView)
        contentView.addSubview(tagView)
        contentView.addSubview(nameLabel)
        avatarView.addSubview(addIcon)
        
        avatarView.snp.makeConstraints { make in
            make.centerX.top.equalToSuperview()
            make.width.height.equalTo(52)
        }
        
        tagView.snp.makeConstraints { make in
            make.width.equalTo(28)
            make.height.equalTo(12)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(avatarView.snp.bottom).offset(4)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
        }
        
        addIcon.snp.makeConstraints { make in
            make.size.equalTo(26)
            make.center.equalToSuperview()
        }
    }
    
    func bind(model: GroupMemberModel) {
        self.model = model
        nameLabel.text = model.name
        addIcon.isHidden = !model.isAdd
        nameLabel.isHidden = model.isAdd
        tagView.isHidden = !model.isOwner
        
        if model.isAdd {
            avatarView.image = nil
        } else {
            avatarView.headerImageUrl(model.avtr)
        }
    }
    
    private lazy var avatarView: UIImageView = {
        let img = UIImageView()
        img.gt.setCornerRadius(52 * 0.5)
        img.contentMode = .scaleAspectFill
        img.backgroundColor = UIColorHex("#F2F2F2")
        return img
    }()
    
    private lazy var tagView: UIView = {
        let view = UIView()
        view.gt.setCornerRadius(6)
        view.backgroundColor = .appColor
        let label = UILabel()
        label.text = "群主"
        label.textColor = .black
        label.font = UIFontReg(8)
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        view.isHidden = true
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let lab =  UILabel()
        lab.color(.black)
        lab.font(UIFontReg(12))
        lab.textAlignment(.center)
        return lab
    }()
    
    private lazy var addIcon: UIImageView = {
        let img = UIImageView()
        img.gt.setCornerRadius(26)
        img.image = .groupAdd2
        img.contentMode = .scaleAspectFill
        return img
    }()
}
