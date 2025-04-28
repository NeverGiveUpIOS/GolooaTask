//
//  ReceiveCompleViewController.swift
//  Golaa
//
//  Created by duke on 2024/5/21.
//

import UIKit

class ReceiveCompleViewController: BasClasVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        bind()
    }
    
    private func buildUI() {
        navTitle("awaitingReview".homeLocalizable())
        view.addSubview(iconView)
        view.addSubview(titleLabel)
        view.addSubview(bottomBtn)
        
        iconView.snp.makeConstraints { make in
            make.top.equalTo(77 + naviH)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(200)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconView.snp.bottom).offset(7)
            make.centerX.equalToSuperview()
        }
        
        bottomBtn.snp.makeConstraints { make in
            make.bottom.equalTo(-60 - safeAreaBt)
            make.leading.equalTo(30)
            make.trailing.equalTo(-30)
            make.height.equalTo(52)
        }
    }
    
    private func bind() {
        bottomBtn.gt.handleClick { _ in
            RoutinStore.dismiss()
        }
    }
    
    private lazy var iconView: UIImageView = {
        let img = UIImageView()
        img.image = .taskReceivedIcon
        return img
    }()
    
    private lazy var titleLabel: UILabel = {
        let lab = UILabel()
        lab.font = UIFontSemibold(18)
        lab.textColor = .black
        lab.text = "pendingPlatformReview".homeLocalizable()
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
