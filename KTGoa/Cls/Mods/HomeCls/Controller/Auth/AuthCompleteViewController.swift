//
//  AuthCompleteViewController.swift
//  Golaa
//
//  Created by duke on 2024/5/15.
//

import UIKit

class AuthCompleteViewController: BasClasVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        bind()
    }
    
    private func buildUI() {
        navTitle("submitVerification".homeLocalizable())
        view.addSubview(iconView)
        view.addSubview(titleLa)
        view.addSubview(bottomBtn)
        
        iconView.snp.makeConstraints { make in
            make.top.equalTo(46 + naviH)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(300)
        }
        
        titleLa.snp.makeConstraints { make in
            make.top.equalTo(iconView.snp.bottom).offset(7)
            make.centerX.equalToSuperview()
        }
        
        bottomBtn.snp.makeConstraints { make in
            make.bottom.equalTo(-71 - safeAreaBt)
            make.leading.equalTo(28)
            make.trailing.equalTo(-28)
            make.height.equalTo(52)
        }
    }
    
    private func bind() {
        bottomBtn.gt.handleClick { button in
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    private lazy var iconView: UIImageView = {
        let img = UIImageView()
        img.image = .homeAuthRzIcon
        return img
    }()
    
    private lazy var titleLa: UILabel = {
        let lab = UILabel()
        lab.font = UIFontReg(16)
        lab.textColor = .black
        let high = "publisher".homeLocalizable()
        let text = "publisherIdentityAwaitingPlatformReview".homeLocalizable()
        lab.text(text)
        lab.gt.setSpecificTextColor(high, color: .hexStrToColor("#2697FF"))
        lab.textAlignment = .center
        return lab
    }()
    
    private lazy var bottomBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("returnToHome".homeLocalizable(), for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFontSemibold(14)
        btn.backgroundColor = .appColor
        btn.gt.setCornerRadius(8)
        return btn
    }()
}
