//
//  HomeHeaderView.swift
//  Golaa
//
//  Created by duke on 2024/5/14.
//

import UIKit

class HomeHeaderView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildUI()
        bind()
        setupContents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildUI() {
        backgroundColor = .xf2
        addSubview(titleLabel)
        addSubview(fabuBtn)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(24.dbw + safeAreaTp)
            make.leading.equalTo(15.dbw)
        }
        
        fabuBtn.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.trailing.equalTo(-13.dbw)
            make.width.height.equalTo(43.dbw)
        }
    }
    
    func setupContents() {
        if GlobalHelper.shared.inEndGid {
            if contentView.subviews.count > 0 {
                contentView.gt.removeSubviews()
            }
            if contentView.superview != nil {
                contentView.removeFromSuperview()
            }
        } else {
            if contentView.superview != nil { return }
            if contentView.subviews.count > 0 { return }
            
            addSubview(contentView)
            contentView.addSubview(taskTitleLab)
            contentView.addSubview(taskValueLab)
            contentView.addSubview(taskDescLab)
            contentView.addSubview(tixianBtn)
            
            contentView.snp.makeConstraints { make in
                make.top.equalTo(fabuBtn.snp.bottom).offset(10.dbw)
                make.leading.equalTo(15.dbw)
                make.trailing.equalTo(-15.dbw)
                make.height.equalTo(120.dbw)
            }
            
            taskTitleLab.snp.makeConstraints { make in
                make.top.equalTo(18.dbw)
                make.leading.equalTo(24.dbw)
            }
            
            taskValueLab.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.leading.equalTo(24.dbw)
            }
            
            taskDescLab.snp.makeConstraints { make in
                make.bottom.equalTo(-22.dbw)
                make.leading.equalTo(24.dbw)
            }
            
            tixianBtn.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.trailing.equalTo(-20.dbw)
                make.width.equalTo(52.dbw)
                make.height.greaterThanOrEqualTo(40.dbw)
            }
        }
    }
    
    private func bind() {
        
        fabuBtn.gt.handleClick { [weak self] _ in
            self?.mutatePublishCheck()
            FlyerLibHelper.log(.toPublishClick)
        }
        
        tixianBtn.gt.handleClick { _ in
            RoutinStore.push(.webScene(.taskIncome))
            FlyerLibHelper.log(.incomeWithdrawalClick)
        }
    }
    
    /// 发布检查
    func mutatePublishCheck() {
        NetAPI.HomeAPI.publishCheck.reqToJsonHandler(parameters: nil, success: { [weak self] _ in
            self?.loadUserInfo()
        }, failed: { error in
            if error.status == "deposit_exceed",
               let extra = error.extra as? [String: Any],
               let taskId = extra["taskId"] as? Int {
                MakeupDepositAlert.show(taskId: taskId, date: "", content: error.localizedDescription)
            }
            print("error: \(error)")
        })
    }
    
    private func loadUserInfo() {
        
        LoginTl.shared.getCurUserInfo { [weak self] model in
            guard let model = model else {
                return
            }
            
            if model.isDisabled {
                ToastHud.showToastAction(message: "youHaveBeenDisabled".homeLocalizable())
            } else if model.publishVerifying {
                RoutinStore.push(.authComplete)
            } else if !model.isPublish {
                RoutinStore.push(.auth)
            } else if !model.hasRsa {
                self?.showAlert()
            } else {
                RoutinStore.push(.publish)
            }
        }
    }
    
    /// 配置RSA弹窗提示
    private func showAlert() {
        AlertPopView.show(titles: "tip".homeLocalizable(),
                          contents: "promptpleaseConfigureTheRsaPublicKey".meLocalizable(),
                          sures: "configureNow".meLocalizable(),
                          cacnces: "contactService".meLocalizable(),
                          cacncesColor: .hexStrToColor("#2697FF"),
                          completion: {
            RoutinStore.push(.publisher)
        }, cancelCompletion: {
            // 去联系客服
            RoutinStore.pushOnlineService()
        })
    }
    
    var model: HomeTaskDataModel?
    func bind(_ model: HomeTaskDataModel) {
        self.model = model
        self.taskValueLab.text = "$ \(model.taskAccount.totalAmt)"
        titleLabel.text = "taskHall".homeLocalizable()
        taskTitleLab.text = "taskEarnings".homeLocalizable()
        taskDescLab.text = "\("todaysEarnings".homeLocalizable()) \(model.todayImeDes)"
    }
    
    private lazy var titleLabel: UILabel = {
        let lab = UILabel()
        lab.font = UIFontSemibold(22.dbw)
        lab.textColor = .black
        lab.text = "taskHall".homeLocalizable()
        return lab
    }()
    
    private lazy var fabuBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.image(.homeFb)
        return btn
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .appColor
        view.gt.setCornerRadius(8.dbw)
        return view
    }()
    
    private lazy var taskTitleLab: UILabel = {
        let lab = UILabel()
        lab.textColor = .black
        lab.font = UIFontSemibold(12.dbw)
        lab.text = "taskEarnings".homeLocalizable()
        return lab
    }()
    
    private lazy var taskValueLab: UILabel = {
        let lab = UILabel()
        lab.textColor = .black
        lab.font = .oswaldDemiBold(26.dbw)
        lab.text = "$ 0"
        return lab
    }()
    
    private lazy var taskDescLab: UILabel = {
        let lab = UILabel()
        lab.textColor = .black.withAlphaComponent(0.5)
        lab.font = UIFontReg(12.dbw)
        lab.text = "\("todaysEarnings".homeLocalizable())  $ 0.00"
        return lab
    }()
    
    private lazy var tixianBtn: UIButton = {
        let btn =  UIButton(type: .custom)
        btn.backgroundColor = .white
        btn.gt.setCornerRadius(6.dbw)
        btn.image(.homeTaskTx)
        return btn
    }()
}
