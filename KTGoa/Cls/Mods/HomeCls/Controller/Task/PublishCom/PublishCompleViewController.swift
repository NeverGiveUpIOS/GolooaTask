//
//  PublishCompleViewController.swift
//  Golaa
//
//  Created by duke on 2024/5/17.
//

import UIKit

class PublishCompleViewController: BasClasVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
    }
    
    private func buildUI() {
        navTitle("paymentSuccessful".homeLocalizable())
        view.addSubview(iconView)
        view.addSubview(title1Label)
        view.addSubview(title2Label)
        view.addSubview(bottomTaskBtn)
        view.addSubview(bottomBackBtn)
        
        iconView.snp.makeConstraints { make in
            make.top.equalTo(105 + naviH)
            make.centerX.equalToSuperview()
            make.width.equalTo(190)
            make.height.equalTo(136)
        }
        
        title1Label.snp.makeConstraints { make in
            make.top.equalTo(iconView.snp.bottom).offset(53)
            make.centerX.equalToSuperview()
        }
        
        title2Label.snp.makeConstraints { make in
            make.top.equalTo(title1Label.snp.bottom).offset(13)
            make.centerX.equalToSuperview()
        }
        
        bottomTaskBtn.snp.makeConstraints { make in
            make.bottom.equalTo(bottomBackBtn.snp.top).offset(-17)
            make.leading.equalTo(28)
            make.trailing.equalTo(-28)
            make.height.equalTo(52)
        }
        
        bottomBackBtn.snp.makeConstraints { make in
            make.bottom.equalTo(-60 - safeAreaTp)
            make.leading.equalTo(28)
            make.trailing.equalTo(-28)
            make.height.equalTo(52)
        }
    }
    
    private lazy var iconView: UIImageView = {
        let img = UIImageView()
        img.image = .publishCompleIcon
        return img
    }()
    
    private lazy var title1Label: UILabel = {
        let lab = UILabel()
        lab.font = UIFontSemibold(20)
        lab.textColor = .black
        lab.text = "paymentSuccessful".homeLocalizable()
        lab.textAlignment = .center
        return lab
    }()
    
    private lazy var title2Label: UILabel = {
        let lab = UILabel()
        lab.font = UIFontReg(14)
        lab.textColor = .hexStrToColor("#666666")
        lab.text = "waitingForPlatformTo".homeLocalizable()
        lab.textAlignment = .center
        return lab
    }()
    
    private lazy var bottomTaskBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("viewMyPosts".homeLocalizable(), for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFontSemibold(14)
        btn.layer.borderColor = UIColor.black.cgColor
        btn.layer.borderWidth = 1
        btn.gt.setCornerRadius(8)
        btn.gt.handleClick { [weak self] _ in
            RoutinStore.push(.chorePublishManager)
        }
        return btn
    }()
    
    private lazy var bottomBackBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("returnToHome".homeLocalizable(), for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFontSemibold(14)
        btn.backgroundColor = .appColor
        btn.gt.setCornerRadius(8)
        btn.gt.handleClick { [weak self] _ in
            RoutinStore.dismissRoot(animated: false)
            RoutinStore.tabBarDidSelected(index: 0)
        }
        return btn
    }()
}
