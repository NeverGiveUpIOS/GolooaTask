//
//  MakeupDepositViewController.swift
//  Golaa
//
//  Created by duke on 2024/5/24.
//

import UIKit

class MakeupDepositViewController: BasClasVC {
    
    private var id: Int = 0
    private var date: String = ""
    private var selectPayType: TaskPublishZFType = .yuer
    lazy var model = MakeupDepositModel()
    
    override func routerParam(param: Any?, router: RoutinRouter?) {
        if let id = param as? Int {
            self.id = id
        } else if let param = param as? [String: Any],
                  let id = param["taskId"] as? Int,
                  let date = param["date"] as? String {
            self.id = id
            self.date = date
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        FlyerLibHelper.log(.enterPayDepositScreen, source: 2)
        mutateLoadDeposit()
        bind()
    }
    
    private func buildUI() {
        navTitle("payDeposit".homeLocalizable())
        navBagColor(.clear)
        
        view.addSubview(maskBgView)
        view.addSubview(logoView)
        view.addSubview(nameLabel)
        view.addSubview(priceLabel)
        view.addSubview(arcView)
        view.addSubview(outCountTitle)
        view.addSubview(outCountLabel)
        view.addSubview(earnestTitleLab)
        view.addSubview(earnestContent)
        earnestContent.addSubview(earnestLabel)
        earnestContent.addSubview(earnestCoinLabel)
        view.addSubview(zfTitleLab)
        view.addSubview(zfContent)
        zfContent.addSubview(yuerPayBtn)
        zfContent.addSubview(paymaxBtn)
        zfContent.addSubview(coinPayBtn)
        let zfItemWidth = (screW - 4*15)/3.0
        let zfItemHeight = 65.0
        coinPayBtn.frame = .init(x: 15, y: 0, width: zfItemWidth, height: zfItemHeight)
        yuerPayBtn.frame = .init(x: 15 + (zfItemWidth + 15) * 1, y: 0, width: zfItemWidth, height: zfItemHeight)
        paymaxBtn.frame = .init(x: 15 + (zfItemWidth + 15) * 2, y: 0, width: zfItemWidth, height: zfItemHeight)
        view.addSubview(bottomBtn)
        
        maskBgView.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(162 + naviH)
        }
        
        logoView.snp.makeConstraints { make in
            make.top.equalTo(naviH + 24)
            make.leading.equalTo(15)
            make.width.height.equalTo(80)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(naviH + 28)
            make.leading.equalTo(logoView.snp.trailing).offset(15)
            make.trailing.equalTo(-15)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.leading.equalTo(logoView.snp.trailing).offset(15)
        }
        
        arcView.snp.makeConstraints { make in
            make.top.equalTo(logoView.snp.bottom).offset(25)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(33)
        }
        
        outCountTitle.snp.makeConstraints { make in
            make.top.equalTo(arcView.snp.bottom).offset(0)
            make.leading.equalTo(15)
        }
        
        outCountLabel.snp.makeConstraints { make in
            make.trailing.equalTo(-15)
            make.centerY.equalTo(outCountTitle.snp.centerY)
        }
        
        earnestTitleLab.snp.makeConstraints { make in
            make.top.equalTo(outCountTitle.snp.bottom).offset(30)
            make.leading.equalTo(15)
        }
        
        earnestContent.snp.makeConstraints { make in
            make.top.equalTo(earnestTitleLab.snp.bottom).offset(11)
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.height.equalTo(74)
        }
        
        earnestLabel.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.centerX.equalToSuperview()
        }
        
        earnestCoinLabel.snp.makeConstraints { make in
            make.bottom.equalTo(-10)
            make.centerX.equalToSuperview()
        }
        
        zfTitleLab.snp.makeConstraints { make in
            make.top.equalTo(earnestContent.snp.bottom).offset(30)
            make.leading.equalTo(15)
        }
        
        zfContent.snp.makeConstraints { make in
            make.top.equalTo(zfTitleLab.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(65)
        }
        
        bottomBtn.snp.makeConstraints { make in
            make.bottom.equalTo(-48 - safeAreaBt)
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.height.equalTo(52)
        }
    }
    
    private func updateUI(model: MakeupDepositModel) {
        logoView.normalImageUrl(model.img)
        nameLabel.text = model.name
        priceLabel.text = model.jiageDes
        outCountLabel.text = "\(model.exceedNum)"
        earnestLabel.text = model.exceedJinerDes
        earnestCoinLabel.text = String(format: "%d%@", model.exceedJinbi, "coins".globalLocalizable())
        let zfItemWidth = (screW - 4*15)/3.0
        let zfItemHeight = 65.0
        for item in model.zfPlatforms {
            switch item.type {
            case .coin:
                coinPayBtn.setTitle(item.yuer, for: .normal)
                coinPayBtn.gt.setImageTitlePos(.imgTop, spacing: 6)
                coinPayBtn.isHidden = false
                selectPayType = .coin
                coinPayBtn.layer.borderColor = UIColor.appColor.cgColor
            case .yuer:
                yuerPayBtn.setTitle(item.yuer, for: .normal)
                yuerPayBtn.gt.setImageTitlePos(.imgTop, spacing: 6)
                yuerPayBtn.isHidden = false
                if !model.zfPlatforms.contains(where: { $0.type == .coin }) {
                    yuerPayBtn.frame = .init(x: 15, y: 0, width: zfItemWidth, height: zfItemHeight)
                }
            case .paymax:
                paymaxBtn.isHidden = false
                if !model.zfPlatforms.contains(where: { $0.type == .coin }),
                   !model.zfPlatforms.contains(where: { $0.type == .yuer }) {
                    paymaxBtn.frame = .init(x: 15, y: 0, width: zfItemWidth, height: zfItemHeight)
                } else if !model.zfPlatforms.contains(where: { $0.type == .yuer }) ||
                            !model.zfPlatforms.contains(where: { $0.type == .coin }) {
                    paymaxBtn.frame = .init(x: 15 + (zfItemWidth + 15) * 1, y: 0, width: zfItemWidth, height: zfItemHeight)
                }
            default:
                break
            }
        }
    }
    
    @objc private func tapYuerAction(sender: UITapGestureRecognizer) {
        selectPayType = .yuer
        coinPayBtn.layer.borderColor = UIColor.xf2.cgColor
        paymaxBtn.layer.borderColor = UIColor.xf2.cgColor
        yuerPayBtn.layer.borderColor = UIColor.appColor.cgColor
    }
    
    @objc private func tapCoinAction(sender: UIButton) {
        selectPayType = .coin
        coinPayBtn.layer.borderColor = UIColor.appColor.cgColor
        paymaxBtn.layer.borderColor = UIColor.xf2.cgColor
        yuerPayBtn.layer.borderColor = UIColor.xf2.cgColor
    }
    
    @objc private func tapPaymaxAction(sender: UIButton) {
        selectPayType = .paymax
        coinPayBtn.layer.borderColor = UIColor.xf2.cgColor
        paymaxBtn.layer.borderColor = UIColor.appColor.cgColor
        yuerPayBtn.layer.borderColor = UIColor.xf2.cgColor
    }
    
    private lazy var maskBgView: UIView = {
        let view = UIView()
        view.backgroundColor = .xf2
        return view
    }()
    
    private lazy var logoView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.gt.setCornerRadius(6)
        return img
    }()
    
    private lazy var nameLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = .black
        lab.font = UIFontSemibold(14)
        lab.numberOfLines = 2
        return lab
    }()
    
    private lazy var priceLabel: UILabel = {
        let lab = UILabel()
        lab.font = .oswaldDemiBold(16)
        lab.textColor = .black
        return lab
    }()
    
    private lazy var arcView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.gt.setCustomCoRadius([.layerMinXMinYCorner, .layerMaxXMinYCorner], cornerRadius: 16)
        return view
    }()
    
    private lazy var outCountTitle: UILabel = {
        let lab = UILabel()
        lab.font = UIFontReg(14)
        lab.textColor = .hexStrToColor("#666666")
        lab.text = "exceedQuantity".meLocalizable()
        return lab
    }()
    
    private lazy var outCountLabel: UILabel = {
        let lab = UILabel()
        lab.font = .oswaldDemiBold(18)
        lab.textColor = .black
        return lab
    }()
    
    private lazy var earnestTitleLab: UILabel = {
        let view = UILabel()
        view.font = UIFontReg(14)
        view.textColor = .hexStrToColor("#666666")
        view.text = "payDeposit".homeLocalizable()
        return view
    }()
    
    private lazy var earnestContent: UIView = {
        let view = UIView()
        view.backgroundColor = .xf2
        view.gt.setCornerRadius(8)
        return view
    }()
    
    private lazy var earnestLabel: UILabel = {
        let lab = UILabel()
        lab.font = UIFontSemibold(24)
        lab.textColor = .hexStrToColor("#FF5722")
        return lab
    }()
    
    private lazy var earnestCoinLabel: UILabel = {
        let lab = UILabel()
        lab.font = UIFontMedium(14)
        lab.textColor = .hexStrToColor("#666666")
        return lab
    }()
    
    private lazy var zfTitleLab: UILabel = {
        let lab = UILabel()
        lab.font = UIFontReg(14)
        lab.textColor = .hexStrToColor("#666666")
        lab.text = "selectPaymentMethod".homeLocalizable()
        return lab
    }()
    
    private lazy var zfContent: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var yuerPayBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.layer.borderColor = UIColor.xf2.cgColor
        btn.layer.borderWidth = 2
        btn.layer.cornerRadius = 8
        btn.image(.zfQb)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFontSemibold(12)
        btn.setTitle("0", for: .normal)
        btn.gt.setImageTitlePos(.imgTop, spacing: 6)
        btn.addTarget(self, action: #selector(tapYuerAction), for: .touchUpInside)
        btn.isHidden = true
        return btn
    }()
    
    private lazy var coinPayBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.layer.borderColor = UIColor.xf2.cgColor
        btn.layer.borderWidth = 2
        btn.layer.cornerRadius = 8
        btn.image(.payCoin1)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFontSemibold(12)
        btn.setTitle("0", for: .normal)
        btn.gt.setImageTitlePos(.imgTop, spacing: 6)
        btn.addTarget(self, action: #selector(tapCoinAction), for: .touchUpInside)
        btn.isHidden = true
        return btn
    }()
    
    private lazy var paymaxBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.layer.borderColor = UIColor.xf2.cgColor
        btn.layer.borderWidth = 2
        btn.layer.cornerRadius = 8
        btn.image(.zfPaymax)
        btn.addTarget(self, action: #selector(tapPaymaxAction), for: .touchUpInside)
        btn.isHidden = true
        return btn
    }()
    
    private lazy var bottomBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("payDeposit".homeLocalizable(), for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFontSemibold(14)
        btn.backgroundColor = .appColor
        btn.gt.setCornerRadius(8)
        return btn
    }()
}

extension MakeupDepositViewController {
    
    private func mutateLoadDeposit() {
        
        var params: [String: Any] = [:]
        params["id"] = id
        params["settleDate"] = date
        
        NetAPI.HomeAPI.makeupDeposit.reqToModelHandler(parameters: params, model: MakeupDepositModel.self, success: { [weak self] model, _ in
            self?.model = model
            self?.updateUI(model: model)
        }, failed: { error in
            print("error: \(error)")
        })
    }
    
    private func mutatePaymax(id: Int, date: String, url: String) {
        
        var params: [String: Any] = [:]
        params["price"] = model.exceedJiner
        params["platform"] = 5
        params["payType"] = 2
        params["assocId"] = id
        params["settleDate"] = date
        
        NetAPI.IAPAPI.createAPI.reqToJsonHandler(false, parameters: params) { info in
            if let orderId = info.data["orderNo"] as? String, !orderId.isEmpty {
                IAPTracker.log("Paymax支付日志 ======== 准备调用跳转Paymax", assocId: "\(id)", orderId: orderId)
                // TODO: - 待完成
                let paymaxUrl = String(format: "%@?orderId=%@&type=3&event=pay_deposit_result&source=2", url, orderId)
                RoutinStore.push(.webScene(.url(paymaxUrl)))
            } else {
                // single(.failure(NSError(domain: kNetworkFailureError, code: -1)))
                IAPTracker.log("Paymax支付日志 ======== 创建订单失败", assocId: "\(id)")
            }
        } failed: { error in
            IAPTracker.log("Paymax支付日志 ======== 创建订单失败 \(error.localizedDescription)", assocId: "\(id)")
        }
    }
    
    private func mutatePayDeposit(id: Int, date: String, payType: TaskPublishZFType) {
        
        var params: [String: Any] = [:]
        params["price"] = model.exceedJiner
        params["platform"] = payType.rawValue
        params["payType"] = 2
        params["assocId"] = id
        params["settleDate"] = date
        
        NetAPI.IAPAPI.createAPI.reqToJsonHandler(parameters: params, success: { _ in
            FlyerLibHelper.log(.payDepositResult, values: ["type": payType == .coin ? 2 : 1, "result": 1])
            RoutinStore.dismissRoot(animated: false)
            RoutinStore.push(.publishComple)
        }, failed: { error in
            FlyerLibHelper.log(.payDepositResult, values: ["type": payType == .coin ? 2 : 1, "result": 2])
            print("error: \(error)")
            if error.status == "less_coin" {
                // 表示 金币余额不足
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    RechargeCoinSheet(source: .makeup).show()
                }
            }
        })
        
    }
    
}

extension MakeupDepositViewController {
    
    func bind() {
        bottomBtn.gt.handleClick { [weak self] _ in
            guard let self = self else { return }
            if self.selectPayType == .paymax {
                guard let url = self.model.zfPlatforms.first(where: { $0.type == .paymax })?.url else {
                    return
                }
                self.mutatePaymax(id: self.id, date: self.date, url: url)
            } else {
                self.mutatePayDeposit(id: self.id, date: self.date, payType: self.selectPayType)
            }
            FlyerLibHelper.log(.payDepositClick)
        }
    }
    
}
