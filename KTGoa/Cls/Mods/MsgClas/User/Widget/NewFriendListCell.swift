//
//  NewFriendListCell.swift
//  Golaa
//
//  Created by chenkaisong on 2024/5/20.
//

import UIKit

class NewFriendListCell: UITableViewCell {
    
    var callChangeBlock: CallBackAnyBlock?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupSubviews()
    }
    
    var info: NewFriendListModel? {
        didSet {
            guard let info = info else { return  }
            
            userHead.headerImageUrl(info.toUser?.avatar ?? "", placeholder: .publicDefault)
            
            let name = info.toUser?.name ?? ""
            let userId = info.toUser?.id ?? ""
            userName.text = name.count > 0 ? name :userId
            
            desLab.text = info.remark
            
            // -1=已拒绝 0=待处理 1=已接受
            switch info.status {
            case "-1":
                agreeButton.isHidden = true
                refButton.isHidden = true
                nolStatue.text = "declined".msgLocalizable()
            case "0":
                agreeButton.isHidden = false
                refButton.isHidden = false
                nolStatue.text = ""
            default:
                agreeButton.isHidden = true
                refButton.isHidden = true
                nolStatue.text = "added".msgLocalizable()
            }
            
        }
    }
    
    private func friendVerify(_ status: Int) {
        guard let info = info else { return  }
        MessageReq.friendVerify(info.toUser?.id ?? "", status) { [weak self] in
            let tInfo = info
            tInfo.status = status == 1 ? "1" : "-1"
            self?.callChangeBlock?(tInfo)
            
            if status != 1 { return }
            RoutinStore.push(.singleChat, param: info.toUser?.id ?? "")
            FlyerLibHelper.log(.enterSingleTalkScreen, source: "0")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var userHead: UIImageView = {
        let imageView = UIImageView()
        imageView.gt.setCornerRadius(52/2)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var userName: UILabel = {
        let label = UILabel()
        label.font = UIFontSemibold(15)
        label.textColor = UIColorHex("#000000")
        label.textAlignment = .left
        return label
    }()
    
    private lazy var desLab: UILabel = {
        let label = UILabel()
        label.font = UIFontReg(11)
        label.textColor = UIColorHex("#999999")
        label.textAlignment = .left
        return label
    }()
    
    private lazy var nolStatue: UILabel = {
        let label = UILabel()
        label.font = UIFontReg(14)
        label.textColor = UIColorHex("#666666")
        label.textAlignment = .left
        return label
    }()
    
    /// 同意按钮
    lazy var agreeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.contentHorizontalAlignment = .center
        button.setTitleColor(UIColorHex("#2697FF"), for: .normal)
        button.titleLabel?.font = UIFontReg(14)
        button.setTitle("agree".msgLocalizable(), for: .normal)
        button.gt.handleClick{ [weak self] _ in
            self?.friendVerify(1)
        }
        return button
    }()
    
    /// 拒绝按钮
    lazy var refButton: UIButton = {
        let button = UIButton(type: .custom)
        button.contentHorizontalAlignment = .center
        button.setTitleColor(UIColorHex("#F96464"), for: .normal)
        button.titleLabel?.font = UIFontReg(14)
        button.setTitle("decline".msgLocalizable(), for: .normal)
        button.gt.handleClick { [weak self] _ in
            self?.friendVerify(0)
            
        }
        return button
    }()
}

extension NewFriendListCell {
    
    private func setupSubviews() {
        
        contentView.gt.addSubviews([
            userHead,
            userName,
            desLab,
            nolStatue,
            agreeButton,
            refButton
        ])
        
        userHead.snp.makeConstraints { make in
            make.leading.equalTo(15)
            make.width.height.equalTo(52)
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
        }
        
        userName.snp.makeConstraints { make in
            make.leading.equalTo(userHead.snp.trailing).offset(10)
            make.trailing.equalTo(-167)
            make.top.equalTo(16)
        }
        
        desLab.snp.makeConstraints { make in
            make.leading.trailing.equalTo(userName)
            make.bottom.equalTo(-16)
        }
        
        nolStatue.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(-15)
        }
        
        agreeButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(nolStatue)
        }
        
        refButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(agreeButton.snp.leading).offset(-20)
        }
    }
    
}
