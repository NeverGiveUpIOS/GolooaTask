//
//  MsgOrdinaryUserInfoView.swift
//  Golaa
//
//  Created by chenkaisong on 2024/5/20.
//

import UIKit

class MsgOrdinaryUserInfoView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupSubviews()
    }
    
    private func addfriend() {
        MessageReq.addFriend(info?.id ?? "") { [weak self] in
            self?.submitButon.backgroundColor = UIColorHex("#2697FF", alpha: 0.5)
            self?.submitButon.setTitleColor(.white, for: .normal)
            self?.submitButon.setTitle("waitingForApproval".msgLocalizable(), for: .normal)
            self?.submitButon.isUserInteractionEnabled = false
        }
    }
    
    var info: GUsrInfo? {
        didSet {
            guard let info = info else { return  }
            bigUserHead.headerImageUrl(info.avatar, placeholder: .publicDefault)
            circleUserHead.headerImageUrl(info.avatar, placeholder: .publicDefault)
            userName.text = info.showName
            idButton.setTitle(" \(info.id)", for: .normal)
            idButton.setImage(UIImage(named: "msg_ordinaryUser_id"), for: .normal)
            desTip.text = "personalIntroduction".homeLocalizable()
            desInfo.text = info.userInfo?.slogan
            
            let hiddenINfo = !(info.userInfo?.slogan.count ?? 0 > 0)
            desInfo.isHidden = hiddenINfo
            
            idButton.isHidden = !(info.id.count > 0)
            
            let subHidden = info.isFrozen || info.isInvalid || info.id == LoginTl.shared.usrId
            submitButon.isHidden = subHidden
            
            if info.isFriend {
                submitButon.backgroundColor = .appColor
                submitButon.setTitleColor(UIColorHex("#000000"), for: .normal)
                submitButon.setTitle("chat".msgLocalizable(), for: .normal)
                submitButon.setImage(UIImage(named: "msg_ordinaryUser_send"), for: .normal)
                submitButon.setImage(UIImage(named: "msg_ordinaryUser_send"), for: .highlighted)
                
                submitButon.gt.handleClick { _ in
                    RoutinStore.push(.singleChat, param: info.id)
                    FlyerLibHelper.log(.enterSingleTalkScreen, source: "2")
                }
            } else {
                
                if info.isFriendVerifying {
                    submitButon.backgroundColor = UIColorHex("#2697FF", alpha: 0.5)
                    submitButon.setTitleColor(.white, for: .normal)
                    submitButon.setTitle("waitingForApproval".msgLocalizable(), for: .normal)
                    submitButon.isUserInteractionEnabled = false
                } else {
                    submitButon.backgroundColor = UIColorHex("#2697FF")
                    submitButon.setTitleColor(.white, for: .normal)
                    submitButon.setTitle("add".msgLocalizable(), for: .normal)
                    submitButon.setImage(UIImage(named: "msg_ordinaryUser_add"), for: .normal)
                    submitButon.setImage(UIImage(named: "msg_ordinaryUser_add"), for: .highlighted)
                    submitButon.gt.handleClick{ [weak self] _ in
                        self?.addfriend()
                    }
                }
            }
        }
    }
    
    private lazy var bigUserHead: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var circleUserHead: UIImageView = {
        let imageView = UIImageView()
        imageView.setBoardLine(.white, 2)
        imageView.gt.setCornerRadius(45)
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var infoView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var userName: UILabel = {
        let label = UILabel()
        label.font = UIFontSemibold(20)
        label.textColor = UIColorHex("#000000")
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()
    
    lazy var idButton: UIButton = {
        let button = UIButton(type: .custom)
        button.contentHorizontalAlignment = .center
        button.setTitleColor(UIColorHex("#999999"), for: .normal)
        button.titleLabel?.font = UIFontReg(12)
        return button
    }()
    
    private lazy var desTip: UILabel = {
        let label = UILabel()
        label.font = UIFontSemibold(16)
        label.textColor = UIColorHex("#000000")
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var desInfo: GTPaddingLabel = {
        let label = GTPaddingLabel()
        label.font = UIFontSemibold(16)
        label.textColor = UIColorHex("#000000")
        label.textAlignment = .left
        label.paddingTop = 15
        label.paddingLeft = 15
        label.paddingBottom = 15
        label.paddingRight = 15
        label.gt.setCornerRadius(5)
        label.backgroundColor = UIColorHex("#F2F2F2")
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    lazy var submitButon: UIButton = {
        let button = UIButton(type: .custom)
        button.contentHorizontalAlignment = .center
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFontSemibold(16)
        button.gt.setCornerRadius(8)
        return button
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        infoView.gt.addCorner(conrners: [.topLeft, .topRight], radius: 16)
    }
}

extension MsgOrdinaryUserInfoView {
    
    private func setupSubviews() {
        
        gt.addSubviews([
            bigUserHead,
            infoView,
            circleUserHead
        ])
        
        infoView.gt.addSubviews([
            userName,
            idButton,
            desTip,
            desInfo,
            submitButon
        ])
        
        bigUserHead.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(355)
        }
        
        infoView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.top.equalTo(bigUserHead.snp.bottom)
        }
        
        circleUserHead.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.width.height.equalTo(90)
            make.centerY.equalTo(infoView.snp.top).offset(15)
        }
        
        userName.snp.makeConstraints { make in
            make.leading.equalTo(120)
            make.top.equalTo(7)
            make.trailing.equalTo(-15)
        }
        
        idButton.snp.makeConstraints { make in
            make.leading.equalTo(userName)
            make.top.equalTo(userName.snp.bottom).offset(6)
        }
        
        submitButon.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(52)
            make.bottom.equalTo(-safeAreaBt-20)
        }
        
        desTip.snp.makeConstraints { make in
            make.leading.equalTo(15)
            make.top.equalTo(idButton.snp.bottom).offset(30)
        }
        
        desInfo.snp.makeConstraints { make in
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.top.equalTo(desTip.snp.bottom).offset(10)
        }
    }
    
}
