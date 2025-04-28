//
//  PosterShareAlert.swift
//  Golaa
//
//  Created by duke on 2024/5/27.
//

import UIKit

class PosterShareAlert: AlertBaseView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildUI()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildUI() {
        addSubview(contentVew)
        contentVew.addSubview(bgView)
        contentVew.addSubview(logo)
        contentVew.addSubview(titleLabel)
        contentVew.addSubview(avatarView)
        contentVew.addSubview(nameLabel)
        contentVew.addSubview(codeLabel)
        contentVew.addSubview(qrContent)
        qrContent.addSubview(qrCodeView)
        addSubview(saveBtn)
        
        contentVew.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(53)
            make.trailing.equalTo(-53)
            make.width.equalTo(screW - 53*2)
            make.height.equalTo(479)
        }
        
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        logo.snp.makeConstraints { make in
            make.width.equalTo(83)
            make.height.equalTo(26)
            make.top.equalTo(20)
            make.leading.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(logo.snp.bottom).offset(16)
            make.leading.equalTo(20)
            make.trailing.equalTo(-7)
        }
        
        avatarView.snp.makeConstraints { make in
            make.bottom.equalTo(nameLabel.snp.top).offset(-5)
            make.leading.equalTo(15)
            make.width.height.equalTo(30)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(15)
            make.bottom.equalTo(codeLabel.snp.top).offset(-5)
        }
        
        codeLabel.snp.makeConstraints { make in
            make.leading.equalTo(15)
            make.bottom.equalTo(qrCodeView.snp.top).offset(-16)
        }
        
        qrContent.snp.makeConstraints { make in
            make.leading.equalTo(15)
            make.bottom.equalTo(-15)
            make.width.height.equalTo(62)
        }
        
        qrCodeView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(50)
        }
        
        saveBtn.snp.makeConstraints { make in
            make.top.equalTo(contentVew.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(169)
            make.height.equalTo(56)
            make.bottom.equalToSuperview()
        }
    }
    
    private func bind() {
        saveBtn.gt.handleClick { [weak self] _ in
            guard let self = self else { return }
            UIImage.saveAlbum(self.contentVew)
            self.dismissView()
        }
        
    }
    
    func show(model: WebContentModel) {
        avatarView.headerImageUrl(LoginTl.shared.userInfo?.avatar ?? "")
        titleLabel.text = model.title
        nameLabel.text = LoginTl.shared.userInfo?.nickname
        codeLabel.text = "invitationCode".meLocalizable() + ": " + model.invCo
        let image = UIImage.gt.QRImage(with: model.link, size: .init(width: 50, height: 50), logoSize: .zero)
        qrCodeView.image = image
        show(position: .center)
    }
    
    private lazy var contentVew: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var bgView: UIImageView = {
        let img = UIImageView()
        img.image = .haibaoBg
        return img
    }()
    
    private lazy var logo: UIImageView = {
        let img = UIImageView()
        img.image = .shareAppLogo
        return img
    }()
    
    private lazy var titleLabel: UILabel = {
        let lab = UILabel()
        lab.font = .gilroyHeavy(26)
        lab.textColor = .hexStrToColor("#FFEF6F")
        lab.numberOfLines = 0
        return lab
    }()
    
    private lazy var avatarView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.gt.setCornerRadius(15)
        return img
    }()
    
    private lazy var nameLabel: UILabel = {
        let lab = UILabel()
        lab.font = UIFontSemibold(12)
        lab.textColor = .black
        return lab
    }()
    
    private lazy var codeLabel: UILabel = {
        let lab = UILabel()
        lab.font = UIFontSemibold(12)
        lab.textColor = .hexStrToColor("#FA002B")
        return lab
    }()
    
    private lazy var qrContent: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.gt.setCornerRadius(8)
        return view
    }()
    
    private lazy var qrCodeView = UIImageView()
    
    private lazy var saveBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.image(.haibaoSave)
        return btn
    }()
}
