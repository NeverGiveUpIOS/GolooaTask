//
//  MineBenefitView.swift
//  Golaa
//
//  Created by Cb on 2024/5/14.
//

import UIKit

enum MineBenefitScene {
    case mine                       // 我的
    case pouch                      // 钱包
    case ensure                     // 保证金
    case chore                      // 任务
    case coinPouch                  // 金币余额
    case coinDetail                 // 金币首页
    
    var rawValue: String {
        switch self {
        case .mine:
            return "walletBalance".meLocalizable()
        case .pouch:
            return "walletBalance".meLocalizable()
        case .ensure:
            return "deposit".meLocalizable()
        case .chore:
            return "taskEarnings".meLocalizable()
        case .coinPouch:
            return "coinBalance".meLocalizable()
        case .coinDetail:
            return "coinEarnings".meLocalizable()
        }
    }
    
    var detail: String {
        switch self {
        case .mine:
            return "todaysEarnings".meLocalizable()
        case .pouch:
            return "todaysEarnings".meLocalizable()
        case .ensure:
            return "frozen".meLocalizable()
        case .chore:
            return "todaysEarnings".meLocalizable()
        case .coinPouch:
            return "rechargeCoins".globalLocalizable()
        case .coinDetail:
            return "todaysEarnings".meLocalizable()
        }
    }
    
    var rightTitle: String {
        switch self {
        case .mine:
            return "myWallet".meLocalizable()
        case .chore:
            return "withdrawEarnings".homeLocalizable()
        case .pouch:
            return ""
        case .ensure:
            return ""
        case .coinPouch:
            return ""
        case .coinDetail:
            return "withdrawEarnings".homeLocalizable()
        }
    }
    
    func coinRighDetail(_ text: String) -> String {
        "pendingSettlement".meLocalizable() + " \(text)"
    }
    
    var rawColor: UIColor {
        switch self {
        case .mine:
            return UIColor.black
        case .pouch:
            return UIColor.black
        case .ensure:
            return UIColor.black
        case .chore:
            return UIColor.black
        case .coinPouch:
            return UIColor.black
        case .coinDetail:
            return UIColor.black
        }
    }
    
    var detailColor: UIColor {
        switch self {
        case .mine:
            UIColor.black.withAlphaComponent(0.6)
        case .pouch:
            UIColor.black.withAlphaComponent(0.6)
        case .ensure:
            UIColor.black.withAlphaComponent(0.6)
        case .chore:
            UIColor.black.withAlphaComponent(0.6)
        case .coinPouch:
            UIColor.black.withAlphaComponent(0.6)
        case .coinDetail:
            UIColor.black.withAlphaComponent(0.6)
        }
    }
    
    var bgColor: UIColor {
        switch self {
        case .mine:
            return UIColor.appColor
        case .pouch:
            return UIColor.hexStrToColor("#5DE873")
        case .ensure:
            return UIColor.hexStrToColor("#5DE873")
        case .chore:
            return UIColor.appColor
        case .coinPouch:
            return UIColor.appColor
        case .coinDetail:
            return UIColor.appColor
        }
    }
    
    var bottomTitle: String {
        switch self {
        case .mine:
            return "earningsDetails".meLocalizable()
        case .pouch:
            return "earningsDetails".meLocalizable()
        case .ensure:
            return "depositDetails".meLocalizable()
        case .chore:
            return "earningsDetails".meLocalizable()
        case .coinPouch:
            return "earningsDetails".meLocalizable()
        case .coinDetail:
            return "earningsDetails".meLocalizable()
        }
    }
    
    var rightIcon: String {
        switch self {
        case .mine:
            return ""
        case .pouch:
            return "mine_ensure_right"
        case .ensure:
            return "mine_ensure_right"
        case .chore:
            return "home_task_tx"
        case .coinPouch:
            return "mine_pouch_right"
        case .coinDetail:
            return "home_task_tx"
        }
    }
}

class MineBenefitView: UIView {
    
    private let scene: MineBenefitScene
    
    init(scene: MineBenefitScene) {
        self.scene = scene
        super.init(frame: .zero)
        configViews()
        configActions()
        refreshContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configViews() {
        backgroundColor = scene.bgColor
        gt.setCornerRadius(12)
        titleLabel.textColor = scene.rawColor
        middleLabel.textColor = scene.rawColor
        bottomLabel.textColor = scene.detailColor
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(11)
            make.leading.equalTo(MineLayout.benefitLeading)
        }
        addSubview(middleLabel)
        middleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(titleLabel.snp.leading)
        }
        
        if scene == .mine || scene == .coinDetail || scene == .chore {
            addSubview(bottomLabel)
            bottomLabel.snp.makeConstraints { make in
                make.bottom.equalTo(-12)
                make.leading.equalTo(titleLabel.snp.leading)
            }
            
            addSubview(rightBtn)
            rightBtn.snp.makeConstraints { make in
                make.trailing.equalTo(-19)
                if scene == .mine {
                    make.centerY.equalToSuperview()
                } else {
                    make.top.equalTo(15)
                }
                make.width.equalTo(52)
                make.height.equalTo(40)
            }
            rightBtn.setImage(UIImage(named: scene.rightIcon), for: .normal)
            
            if scene == .coinDetail || scene == .chore {
                bottomRightLabel.textColor = scene.detailColor
                addSubview(bottomRightLabel)
                bottomRightLabel.snp.makeConstraints { make in
                    make.left.equalTo(snp.centerX)
                    make.bottom.equalTo(-12)
                }
            }
        } else if scene == .coinPouch {
            bottomBtn.setTitleColor(scene.detailColor, for: .normal)
            addSubview(bottomBtn)
            bottomBtn.snp.makeConstraints { make in
                make.bottom.equalTo(-12)
                make.leading.equalTo(titleLabel.snp.leading)
            }
            
            bottomBtn.setTitle(scene.detail, for: .normal)
            bottomBtn.setImage(UIImage(named: "mine_pouch_arrow"), for: .normal)
            bottomBtn.gt.setImageTitlePos(.imgRight, spacing: 0)
            
            pouchIcon.image = UIImage(named: scene.rightIcon)
            
            addSubview(pouchIcon)
            pouchIcon.snp.makeConstraints { make in
                make.trailing.equalTo(-17)
                make.centerY.equalToSuperview()
            }
            
        } else {
            addSubview(bottomLabel)
            bottomLabel.snp.makeConstraints { make in
                make.bottom.equalTo(-12)
                make.leading.equalTo(titleLabel.snp.leading)
            }
            
            pouchIcon.image = UIImage(named: scene.rightIcon)
            
            addSubview(pouchIcon)
            pouchIcon.snp.makeConstraints { make in
                make.trailing.equalTo(-17)
                make.centerY.equalToSuperview()
            }
        }
    }
    
    private func configActions() {
        rightBtn.gt.handleClick { [weak self] _ in
            if self?.scene == .coinDetail {
                RoutinStore.push(.webScene(.coinExtra))
            } else if self?.scene == .chore {
                RoutinStore.push(.webScene(.taskIncome))
                FlyerLibHelper.log(.incomeWithdrawalClick)
            } else {
                RoutinStore.push(.pouch)
            }
        }
        
        bottomBtn.gt.handleClick { _ in
            RoutinStore.push(.buyCoin, param: BuyCoinSource.qb.rawValue)
        }
        
    }
    
    func refreshContent() {
        if scene == .coinPouch {
            bottomBtn.setTitle(scene.detail, for: .normal)
            bottomBtn.gt.setImageTitlePos(.imgRight, spacing: 0)
        }
        bottomLabel.text = scene.detail
        titleLabel.text = scene.rawValue
    }
    
    private var model: HomeBalanceModel?
    private var subModel: HomeBalanceAccount?
    
    func configureItem(_ item: HomeBalanceModel) {
        self.model = item
        titleLabel.text = scene.rawValue
        middleLabel.text = item.totalAmtDes
        bottomLabel.text = scene.detail + " \(item.todayInmDes)"
    }
    
    func configureSubItem(_ item: HomeBalanceAccount) {
        self.subModel = item
        titleLabel.text = scene.rawValue
        if scene == .coinPouch {
            middleLabel.text = "\(Int(item.totalAmt))"
        } else {
            middleLabel.text = item.totalAmtDes
        }
        
        let text = scene == .ensure ? " \(item.frozenAmtDes)" : scene == .chore ? " \(item.todayImeDes)" : " \(item.totalAmtDes)"
        bottomLabel.text = scene.detail + text
        if scene == .coinDetail || scene == .coinPouch || scene == .chore {
            bottomRightLabel.text = scene.coinRighDetail(item.frozenAmtDes)
        }
    }
    
    // MARK: - 属性
    private let titleLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = .black
        lab.font = UIFontSemibold(12)
        return lab
    }()
    
    private let middleLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = .black
        lab.font = .oswaldDemiBold(26)
        lab.text = "$ 8327143"
        return lab
    }()
    
    private let bottomLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = .hexStrToColor("#999999", 0.6)
        lab.font = .systemFont(ofSize: 12)
        return lab
    }()
    
    private let bottomBtn: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.hexStrToColor("#999999", 0.6), for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 12)
        return btn
    }()
    
    private let bottomRightLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = .hexStrToColor("#999999", 0.6)
        lab.font = .systemFont(ofSize: 12)
        return lab
    }()
    
    private lazy var rightBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .white
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 14)
        btn.titleLabel?.numberOfLines = 0
        btn.titleLabel?.textAlignment = .center
        btn.gt.setCornerRadius(8)
        return btn
    }()
    
    private lazy var pouchIcon:UIImageView = {
        let img = UIImageView(image: UIImage(named: "mine_pouch_right"))
        img.contentMode = .scaleAspectFill
        return img
    }()
}
