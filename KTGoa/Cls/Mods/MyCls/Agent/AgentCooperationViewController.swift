//
//  AgentCooperationViewController.swift
//  Golaa
//
//  Created by Cb on 2024/5/20.
//

import Foundation

class AgentCooperationViewController: BasClasVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        configViews()
        configActions()
    }
    
    func configViews() {
        
        navBagColor(.clear)
        backItem(.backWhite)
        
        view.insertSubview(bgIcon, at: 0)
        bgIcon.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(confirmBtn)
        confirmBtn.snp.makeConstraints { make in
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.bottom.equalTo(-150-safeAreaBt)
        }
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.top.equalTo(confirmBtn.snp.bottom).offset(19)
        }
    }
    
    func configActions() {
        confirmBtn.gt.handleClick { _ in
            RoutinStore.pushOnlineService()
        }
    }
    
    private let bgIcon: UIImageView = {
        let img = UIImageView()
        let name = LanguageTl.shared.curLanguage == .portuguese ? "mine_agent_bg_pt" : "mine_agent_bg_en"
        img.image = UIImage(named: name)
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    private let confirmBtn: UIButton = {
        let btn = UIButton()
        let name = LanguageTl.shared.curLanguage == .portuguese ? "mine_agent_contact_pt" : "mine_agent_contact_en"
        btn.setBackgroundImage(UIImage(named: name), for: .normal)
        btn.setBackgroundImage(UIImage(named: name), for: .highlighted)
        return btn
    }()
    
    private let label: UILabel = {
        let lab = UILabel()
        lab.numberOfLines = 0
        lab.textAlignment = .center
        lab.textColor = .white
        lab.font = .systemFont(ofSize: 12)
        lab.text = "contactOfficial".meLocalizable() + GlobalHelper.shared.dataConfigure.contactEmail
        return lab
    }()
}
