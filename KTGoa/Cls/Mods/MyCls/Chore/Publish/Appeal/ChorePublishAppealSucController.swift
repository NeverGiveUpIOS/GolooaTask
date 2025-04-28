//
//  ChorePublishAppealSucController.swift
//  Golaa
//
//  Created by Cb on 2024/5/21.
//

import Foundation

class ChorePublishAppealSucController: BasClasVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createViews()
        createActions()
    }
    
    private func createViews() {
        navTitle("Enviar autenticação")
        view.addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.top.equalTo(105 + naviH)
            make.centerX.equalToSuperview()
            make.width.equalTo(190)
            make.height.equalTo(136)
        }
        
        view.addSubview(title1Label)
        title1Label.snp.makeConstraints { make in
            make.top.equalTo(iconView.snp.bottom).offset(53)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(title2Label)
        title2Label.snp.makeConstraints { make in
            make.top.equalTo(title1Label.snp.bottom).offset(13)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(bottomBackBtn)
        bottomBackBtn.snp.makeConstraints { make in
            make.bottom.equalTo(-60 - safeAreaBt)
            make.leading.equalTo(28)
            make.trailing.equalTo(-28)
            make.height.equalTo(52)
        }
        
        view.addSubview(bottomTaskBtn)
        bottomTaskBtn.snp.makeConstraints { make in
            make.bottom.equalTo(bottomBackBtn.snp.top).offset(-17)
            make.leading.equalTo(28)
            make.trailing.equalTo(-28)
            make.height.equalTo(52)
        }
        
    }
    
    private func createActions() {
        bottomTaskBtn.gt.handleClick { _ in
            RoutinStore.dismissRoot(animated: false)
            RoutinStore.push(.chorePublishManager)
        }
        
        bottomBackBtn.gt.handleClick { [weak self] _ in
            guard let self = self else { return }
            guard let tab = self.tabBarController else { return }
            RoutinStore.dismissRoot(animated: false)
            tab.selectedIndex = 0
        }
        
    }
    
    private lazy var iconView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "publish_comple_icon")
        return img
    }()
    
    private lazy var title1Label: UILabel = {
        let lab = UILabel()
        lab.font = UIFontSemibold(20)
        lab.textColor = .black
        lab.text = "submissionSuccessful".meLocalizable()
        lab.textAlignment = .center
        return lab
    }()
    
    private lazy var title2Label: UILabel = {
        let lab = UILabel()
        lab.font = UIFontReg(14)
        lab.textColor = .hexStrToColor("#666666")
        lab.text = "waitingForPlatformVerification".meLocalizable()
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
        return btn
    }()
    
    private lazy var bottomBackBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("returnToHome".homeLocalizable(), for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFontSemibold(14)
        btn.backgroundColor = .appColor
        btn.gt.setCornerRadius(8)
        return btn
    }()
}
