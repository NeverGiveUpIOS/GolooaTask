//
//  WriteOffViewController.swift
//  Golaa
//
//  Created by Cb on 2024/5/17.
//

import Foundation

class WriteOffViewController: BasClasVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        configViews()
        configActions()
        configData()
    }
    
    private func configViews() {
        navTitle("accountDeactivation".meLocalizable())
        
        view.insertSubview(scrollView, at: 0)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(screW)
        }
        
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(50)
            make.bottom.equalToSuperview()
            make.leading.equalTo(20)
            make.width.equalTo(screW - 40)
        }
        
        view.addSubview(confirmBtn)
        confirmBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-safeAreaBt-40)
            make.width.equalTo(screW - 30)
            make.height.equalTo(52)
        }
    }
    
    private func configActions() {
        confirmBtn.gt.handleClick { [weak self] _ in
            self?.confirmAction()
            print("accountDeactivation".meLocalizable())
        }
        
    }
    
    private func confirmAction() {
        MineReq.invalidUser { isSuccess, msg in
            if !isSuccess, let _ = msg {
                AlertPopView.show(titles: "提示".globalLocalizable(), contents: "itHasBeenDetectedThatYour".meLocalizable(), cacnces: "contactService".meLocalizable(), cancelCompletion: {
                    RoutinStore.pushOnlineService()
                })
            } else {
                LoginTl.shared.logout()
            }
            FlyerLibHelper.log(.cancelAccountResult, result: isSuccess)
        }
    }
    
    private func configData() {
        /*
         areYouSureYouWantTo="真的要离开Golaa吗？";
         weSuggestYouTryToContact="我们建议您先尝试联系客服";
         weWillDoOurBestTo="我们会竭力为您解决问题";
         afterAccountDeactivationYouWill="注销账户后将会...";
         yourFriendsWillNotBeAble="您的好友将无法联系您";
         deleteAllYourContacts="删除您所有的联系人";
         deleteYourUserProfile="删除您的用户资料";
         theAccountCannotBeRestored="无法恢复该账户";
         voluntarilyAbandonAllDataAssetsAnd="自愿放弃账户内的全部数据、资产和权益";
         itHasBeenDetectedThatYour="检测到您的账号正在进行某些任务，请先结束任务，再进行注销";
         */
        let contents = ["areYouSureYouWantTo", "weSuggestYouTryToContact", "weWillDoOurBestTo", "afterAccountDeactivationYouWill", "yourFriendsWillNotBeAble", "deleteAllYourContacts", "deleteYourUserProfile", "theAccountCannotBeRestored", "voluntarilyAbandonAllDataAssetsAnd"]
        
        for (index, i) in contents.enumerated() {
            let model = WriteOffModel.create(index, title: i.meLocalizable())
            let label = UILabel()
            //            label.preferredMaxLayoutWidth = ScreenWidth - 30
            label.numberOfLines = 0
            label.textColor = model.textColor
            label.font = model.font
            label.attributedText = model.attrText
            label.text = model.title
            //            label.text = model.title.meLocalizable()
            stackView.addArrangedSubview(label)
            label.snp.makeConstraints { make in
                make.width.equalTo(screW - 30)
            }
            if index == 2 {
                stackView.setCustomSpacing(30, after: label)
            }
        }
    }
    
    // MARK: - 属性
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.alwaysBounceVertical = true
        return view
    }()
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .leading
        view.spacing = 10
        return view
    }()
    
    private let confirmBtn: UIButton = {
        let btn = UIButton()
        btn.gt.setCornerRadius(8)
        btn.backgroundColor = UIColor.hexStrToColor("#F96464")
        btn.setTitle("accountDeactivation".meLocalizable(), for: .normal)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 16)
        btn.setTitleColor(UIColor.hexStrToColor("#FFFFFF"), for: .normal)
        return btn
    }()
    
}
