//
//  AuthViewController.swift
//  Golaa
//
//  Created by duke on 2024/5/15.
//

import UIKit

class ReadyAuthViewController: BasClasVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
    }
    
    private func buildUI() {
        navTitle("submitVerification".homeLocalizable())
        view.addSubview(iconView)
        view.addSubview(titleLabel)
        view.addSubview(bottomBtn)
        
        iconView.snp.makeConstraints { make in
            make.top.equalTo(46 + naviH)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(300)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconView.snp.bottom).offset(7)
            make.centerX.equalToSuperview()
        }
        
        bottomBtn.snp.makeConstraints { make in
            make.bottom.equalTo(-71 - safeAreaBt)
            make.leading.equalTo(28)
            make.trailing.equalTo(-28)
            make.height.equalTo(52)
        }
        
        bottomBtn.gt.handleClick { [weak self] _ in
            guard let self = self else { return }
            let vc = AuthViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    
    private lazy var iconView: UIImageView = {
        let img = UIImageView()
        img.image = .homeAuthRzIcon
        return img
    }()
    
    private lazy var titleLabel: UILabel = {
        let lab = UILabel()
        lab.font = UIFontReg(16)
        lab.textColor = .black
        let high = "publisher".homeLocalizable()
        let text = "verifyPublisherIdentityFirst".homeLocalizable()
        lab.text = text
        lab.gt.setSpecificTextColor(high, color: .hexStrToColor("#2697FF"))
        lab.textAlignment = .center
        return lab
    }()
    
    private lazy var bottomBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("verifyNow".homeLocalizable(), for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFontSemibold(14)
        btn.backgroundColor = .appColor
        btn.gt.setCornerRadius(8)
        return btn
    }()
}
