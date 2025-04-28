//
//  MsgFriendCell.swift
//  Golaa
//
//  Created by chenkaisong on 2024/5/20.
//

import UIKit

class MsgFriendCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        contentView.gt.addSubviews([userHead, userName, arrow])
        
        userHead.snp.makeConstraints { make in
            make.leading.equalTo(15)
            make.width.height.equalTo(52)
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
        }
        
        arrow.snp.makeConstraints { make in
            make.trailing.equalTo(-15)
            make.centerY.equalToSuperview()
        }
        
        userName.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(userHead.snp.trailing).offset(10)
            make.trailing.equalTo(-60)
        }
    }
        
    func setupAddUserInfo(_ info: GUsrInfo) {
        userHead.headerImageUrl(info.avatar, placeholder: .publicDefault)
        userName.text = info.showName
    }
    
    func setupGroupInfo(_ info: NIMGroupModel) {
        userHead.headerImageUrl(info.avatar)
        userName.text = "\(info.name) (\(info.memberCount))"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var userHead: UIImageView = {
        let imageView = UIImageView()
        imageView.gt.setCornerRadius(52/2)
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    private lazy var userName: UILabel = {
        let label = UILabel()
        label.font = UIFontSemibold(15)
        label.textColor = UIColorHex("#000000")
        label.textAlignment = .left
        return label
    }()
    
    private lazy var arrow: UIImageView = {
        let imageView = UIImageView()
        imageView.imageWithString("setting_right")
        return imageView
    }()
    
}
