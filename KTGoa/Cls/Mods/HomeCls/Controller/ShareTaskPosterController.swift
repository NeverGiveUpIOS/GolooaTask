//
//  ReceivePosterShareController.swift
//  Golaa
//
//  Created by duke on 2024/5/27.
//

import UIKit

class ShareTaskPosterController: BasClasVC {
    var id = 0
    var link = ""
    
    override func routerParam(param: Any?, router: RoutinRouter?) {
        if let params = param as? [String: Any], let id = params["id"] as? Int, let link = params["link"] as? String {
            self.id = id
            self.link = link
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildUI()
        bind()
    }
    
    private func buildUI() {
        navBagColor(.clear)
        navTitle("claimSuccess".homeLocalizable())
        
        view.addSubview(posterImgView)
        view.addSubview(bgView)
        view.addSubview(qrContent)
        qrContent.addSubview(qrCodeView)
        qrContent.addSubview(qrTitle)
        qrContent.addSubview(saveBtn)
        view.addSubview(linkTitle)
        view.addSubview(linkContent)
        linkContent.addSubview(linkLabel)
        linkContent.addSubview(copyBtn)
        view.addSubview(bottomBtn)
        linkLabel.text = link
        let qrImage = UIImage.gt.QRImage(with: link, size: .init(width: 161, height: 161), logoSize: .zero)
        qrCodeView.image = qrImage
        (posterImgView.viewWithTag(100) as? UIImageView)?.image = qrImage
        
        bgView.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        posterImgView.snp.makeConstraints { make in
            make.top.equalTo(naviH)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(-safeAreaBt)
        }
        
        qrContent.snp.makeConstraints { make in
            make.top.equalTo(45 + naviH)
            make.leading.equalTo(56)
            make.trailing.equalTo(-56)
            make.height.equalTo(323)
        }
        
        qrCodeView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(48)
            make.width.height.equalTo(161)
        }
        
        qrTitle.snp.makeConstraints { make in
            make.top.equalTo(qrCodeView.snp.bottom).offset(23)
            make.centerX.equalToSuperview()
        }
        
        saveBtn.snp.makeConstraints { make in
            make.bottom.equalTo(-30)
            make.centerX.equalToSuperview()
        }
        
        linkTitle.snp.makeConstraints { make in
            make.top.equalTo(qrContent.snp.bottom).offset(27)
            make.leading.equalTo(29)
            make.trailing.equalTo(-29)
        }
        
        linkContent.snp.makeConstraints { make in
            make.top.equalTo(linkTitle.snp.bottom).offset(12)
            make.leading.equalTo(29)
            make.trailing.equalTo(-29)
            make.height.greaterThanOrEqualTo(55)
        }
        
        linkLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(15)
            make.trailing.lessThanOrEqualTo(copyBtn.snp.leading).offset(-10)
            make.top.greaterThanOrEqualTo(5)
            make.bottom.lessThanOrEqualTo(-5)
        }
        
        copyBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(-12)
            make.width.height.equalTo(15)
        }
        
        bottomBtn.snp.makeConstraints { make in
            make.bottom.equalTo(-25 - safeAreaBt)
            make.leading.equalTo(30)
            make.trailing.equalTo(-30)
            make.height.equalTo(52)
        }
    }
    
    private func bind() {
        saveBtn.gt.handleClick { [weak self] _ in
            guard let self = self else { return }
            UIImage.saveAlbum(self.posterImgView)
        }
        copyBtn.gt.handleClick { [weak self] _ in
            guard let self = self else { return }
            UIPasteboard.general.string = self.link
            ToastHud.showToastAction(message: "copySuccessful".homeLocalizable())
        }
        
        bottomBtn.gt.handleClick { [weak self] _ in
            guard let self = self else { return }
            self.share()
        }
    }
    
    private func share() {
        TaskShareSheet().show(id: id, link: link)
    }
    
    private lazy var bgView: UIImageView = {
        let img = UIImageView()
        img.image = .getTaskShareBg
        return img
    }()
    
    private lazy var posterImgView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.image = .shareTaskHaibaoBg
        let label = UILabel()
        label.text = "iFoundASuperFunAppComeAndExperienceItNow".homeLocalizable()
        label.font = UIFontSemibold(16)
        label.textColor = .black
        label.numberOfLines = 0
        img.addSubview(label)
        let image = UIImageView()
        image.tag = 100
        img.addSubview(image)
        label.snp.makeConstraints { make in
            make.bottom.equalTo(-95)
            make.leading.equalTo(15)
            make.trailing.equalTo(image.snp.leading).offset(-15)
        }
        image.snp.makeConstraints { make in
            make.bottom.equalTo(-70)
            make.trailing.equalTo(-17)
            make.width.height.equalTo(120)
        }
        
        return img
    }()
    
    private lazy var qrContent:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.gt.setCornerRadius(16)
        return view
    }()
    
    private lazy var qrCodeView = UIImageView()
    
    private lazy var qrTitle: UILabel = {
        let lab = UILabel()
        lab.font = UIFontSemibold(18)
        lab.textColor = .black
        lab.text = "shareTaskPoster".homeLocalizable()
        return lab
    }()
    
    private lazy var saveBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("saveQrCode".homeLocalizable(), for: .normal)
        btn.setTitleColor(.hexStrToColor("#999999"), for: .normal)
        btn.titleLabel?.font = UIFontReg(14)
        return btn
    }()
    
    private lazy var linkTitle: UILabel = {
        let lab = UILabel()
        lab.font = UIFontSemibold(14)
        lab.textColor = .black
        lab.text = "importantExclusiveTaskLink".homeLocalizable()
        lab.numberOfLines = 0
        return lab
    }()
    
    private lazy var linkContent: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.gt.setCornerRadius(8)
        return view
    }()
    
    private lazy var linkLabel: UILabel = {
        let lab = UILabel()
        lab.font = .systemFont(ofSize: 12)
        lab.textColor = .hexStrToColor("#5B6FA3")
        lab.numberOfLines = 0
        return lab
    }()
    
    private lazy var copyBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.image(.taskIdCopy)
        return btn
    }()
    
    private lazy var bottomBtn: UIButton =  {
        let btn = UIButton(type: .custom)
        btn.setTitle("startPromotingNow".homeLocalizable(), for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFontSemibold(14)
        btn.backgroundColor = .appColor
        btn.gt.setCornerRadius(8)
        return btn
    }()
}
