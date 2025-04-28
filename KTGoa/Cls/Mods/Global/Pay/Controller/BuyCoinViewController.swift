//
//  BuyCoinViewController.swift
//  Golaa
//
//  Created by duke on 2024/5/24.
//

import UIKit

enum BuyCoinSource: Int {
    case my = 1
    case qb = 2
}

class BuyCoinViewController: BasClasVC {
    
    private var selectPayType: TaskPublishZFType = .yuer
    private var source: BuyCoinSource = .my
    lazy var model = PayProductModel()
    
    override func routerParam(param: Any?, router: RoutinRouter?) {
        if let value = param as? Int, let source = BuyCoinSource(rawValue: value) {
            self.source = source
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        mutateLoadProductList()
        FlyerLibHelper.log(.enterRechargeCoinScreen, source: source.rawValue)
    }
    
    private func buildUI() {
        
        navTitle("rechargeCoins".globalLocalizable())
        navBagColor(.hexStrToColor("#F2F2F2"))
        if !GlobalHelper.shared.inEndGid {
            rightItem(.payTixianJl)
        }
        
        view.addSubview(scrollView)
        scrollView.addSubview(makeBgView)
        makeBgView.addSubview(headerView)
        headerView.addSubview(coinTitle)
        headerView.addSubview(coinLabel)
        headerView.addSubview(icon)
        scrollView.addSubview(arcView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(collectionView)
        if !GlobalHelper.shared.inEndGid {
            scrollView.addSubview(zfTitleLab)
            scrollView.addSubview(zfContent)
            zfContent.addSubview(applePayBtn)
            zfContent.addSubview(paymaxBtn)
        }
        view.addSubview(bottomBtn)
        view.addSubview(protolcolBtn)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(naviH)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(-52 - 45 - safeAreaBt)
        }
        
        makeBgView.snp.makeConstraints { make in
            make.top.equalTo(-naviH)
            make.leading.trailing.equalToSuperview()
            make.width.equalTo(screW)
            make.height.equalTo(250)
        }
        
        headerView.snp.makeConstraints { make in
            make.top.equalTo(10 + naviH)
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.height.equalTo(94)
        }
        
        coinTitle.snp.makeConstraints { make in
            make.top.equalTo(20)
            make.leading.equalTo(20)
        }
        
        coinLabel.snp.makeConstraints { make in
            make.top.equalTo(coinTitle.snp.bottom).offset(6)
            make.leading.equalTo(20)
        }
        
        icon.snp.makeConstraints { make in
            make.trailing.equalTo(-20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(80)
        }
        
        arcView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(25)
            make.leading.trailing.equalToSuperview()
            make.width.equalTo(screW)
            make.height.equalTo(33 + 35)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(53)
            make.leading.equalTo(15)
        }
        
        collectionView.snp.makeConstraints { make in
            make
                .top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
            make.width.equalTo(screW)
            make.height.equalTo(0)
            if GlobalHelper.shared.inEndGid {
                make.bottom.equalTo(-40)
            }
        }
        
        if !GlobalHelper.shared.inEndGid {
            zfTitleLab.snp.makeConstraints { make in
                make.top.equalTo(collectionView.snp.bottom).offset(40)
                make.leading.equalTo(15)
            }
            
            zfContent.snp.makeConstraints { make in
                make.top.equalTo(zfTitleLab.snp.bottom).offset(12)
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(65)
                make.bottom.equalTo(-40)
            }
            
            let zfItemWidth = (screW - 4*15)/3.0
            let zfItemHeight = 65.0
            applePayBtn.frame = .init(x: 15, y: 0, width: zfItemWidth, height: zfItemHeight)
            paymaxBtn.frame = .init(x: 15 + (zfItemWidth + 15) * 1, y: 0, width: zfItemWidth, height: zfItemHeight)
        }
        
        bottomBtn.snp.makeConstraints { make in
            make.bottom.equalTo(-45 - safeAreaBt)
            make.leading.equalTo(30)
            make.trailing.equalTo(-30)
            make.height.equalTo(52)
        }
        
        protolcolBtn.snp.makeConstraints { make in
            make.top.equalTo(bottomBtn.snp.bottom).offset(15)
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
        }
    }
    
    private func updateUI() {
        coinLabel.text = String(format: "%d", model.extra.info.activeJinbi)
        
        let zfItemWidth = (screW - 4*15)/3.0
        let zfItemHeight = 65.0
        for item in model.extra.info.zfPlatforms {
            switch item.type {
            case .apple:
                applePayBtn.isHidden = false
                selectPayType = .apple
                applePayBtn.layer.borderColor = UIColor.appColor.cgColor
            case .paymax:
                paymaxBtn.isHidden = false
                if !model.extra.info.zfPlatforms.contains(where: { $0.type == .apple }) {
                    paymaxBtn.frame = .init(x: 15, y: 0, width: zfItemWidth, height: zfItemHeight)
                }
            default:
                break
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.snp.updateConstraints { make in
            let height = collectionView.collectionViewLayout.collectionViewContentSize.height
            make.height.equalTo(height)
        }
    }
    
    override func rightItemClick() {
        super.rightItemClick()
        RoutinStore.push(.coinRecord)
    }
    
    @objc private func tapAppleAction(sender: UIButton) {
        selectPayType = .apple
        applePayBtn.layer.borderColor = UIColor.appColor.cgColor
        paymaxBtn.layer.borderColor = UIColor.xf2.cgColor
    }
    
    @objc private func tapPaymaxAction(sender: UIButton) {
        selectPayType = .paymax
        applePayBtn.layer.borderColor = UIColor.xf2.cgColor
        paymaxBtn.layer.borderColor = UIColor.appColor.cgColor
    }
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    private lazy var makeBgView: UIView = {
        let view = UIView()
        view.backgroundColor = .xf2
        return view
    }()
    
    private lazy var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .appColor
        view.gt.setCornerRadius(12)
        return view
    }()
    
    private lazy var coinTitle: UILabel = {
        let lab = UILabel()
        lab.font = UIFontSemibold(12)
        lab.textColor = .black
        lab.text = "myCoins".globalLocalizable()
        return lab
    }()
    
    private lazy var coinLabel: UILabel = {
        let lab = UILabel()
        lab.font = .oswaldDemiBold(26)
        lab.textColor = .black
        return lab
    }()
    
    private lazy var icon: UIImageView = {
        let img = UIImageView()
        img.image = .payCoinIcon
        return img
    }()
    
    private lazy var arcView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.gt.setCustomCoRadius([.layerMinXMinYCorner, .layerMaxXMinYCorner], cornerRadius: 16)
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let lab = UILabel()
        lab.font = UIFontSemibold(16)
        lab.textColor = .black
        lab.text = "rechargeCoins".globalLocalizable()
        return lab
    }()
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let lay = UICollectionViewFlowLayout()
        lay.itemSize = .init(width: screW - 30, height: 68)
        lay.minimumLineSpacing = 10
        return lay
    }()
    
    private lazy var collectionView: UICollectionView = {
        let col = UICollectionView(frame: .zero, collectionViewLayout: layout)
        col.showsVerticalScrollIndicator = false
        col.showsHorizontalScrollIndicator = false
        col.backgroundColor = .white
        col.delegate = self
        col.dataSource = self
        col.register(BuyCoinCell.self, forCellWithReuseIdentifier: NSStringFromClass(BuyCoinCell.self))
        return col
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
    
    private lazy var applePayBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.layer.borderColor = UIColor.xf2.cgColor
        btn.layer.borderWidth = 2
        btn.layer.cornerRadius = 8
        btn.image(.zfApple)
        btn.addTarget(self, action: #selector(tapAppleAction), for: .touchUpInside)
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
        btn.setTitle("rechargeCoins".globalLocalizable(), for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFontSemibold(14)
        btn.backgroundColor = .appColor
        btn.gt.setCornerRadius(8)
        btn.gt.preventDoubleHit(5)
        btn.gt.handleClick { [weak self] _ in
            self?.bottomCLickReq()
        }
        return btn
    }()
    
    private lazy var protolcolBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("rechargingAgreement".globalLocalizable(), for: .normal)
        btn.setTitleColor(.hexStrToColor("#2697FF"), for: .normal)
        btn.titleLabel?.font = UIFontReg(12)
        btn.titleLabel?.numberOfLines = 0
        btn.titleLabel?.textAlignment = .center
        // 隐藏充值协议
        btn.isHidden = true
        btn.gt.handleClick { button in
            RoutinStore.push(.webScene(.refill))
        }
        return btn
    }()
}

extension BuyCoinViewController {
    
    private func mutateLoadProductList() {
        NetAPI.GlobalAPI.productList.reqToJsonHandler(parameters: nil) { [weak self] originalData in
            
            if let list = [PayProductListModel].deserialize(from: originalData.json.toJSON(), designatedPath: "data") as? [PayProductListModel] {
                list.first?.isSelected = true
                self?.model.list = list
            }
            if let extra = PayProductListExtra.deserialize(from: originalData.json, designatedPath: "extra") {
                self?.model.extra = extra
            }
            self?.updateUI()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                guard let self = self else { return }
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
            }
            self?.collectionView.reloadData()
        } failed: { error in
            
        }
    }
    
    private func mutatePaymax(model: PayProductListModel, url: String) {
        
        var params: [String: Any] = [:]
        params["productId"] = "\(model.id)"
        params["platform"] = 5
        params["price"] = "\(model.jiage)"
        params["payType"] = 3
        params["adType"] = "INTER_AD"
        params["idfv"] = ""
        params["idfa"] = ""
        params["adid"] = ""
        
        NetAPI.IAPAPI.createAPI.reqToJsonHandler(false, parameters: params) { info in
            if let orderId = info.data["orderNo"] as? String, !orderId.isEmpty {
                IAPTracker.log("Paymax支付日志 ======== 准备调用跳转Paymax", productId: "\(model.id)", orderId: orderId)
                // TODO: - 待完成
                let paymaxUrl = String(format: "%@?orderId=%@&price=%@&type=3&event=recharge_coin_result", url, orderId, model.jiage)
                RoutinStore.push(.webScene(.url(paymaxUrl)))
            } else {
                IAPTracker.log("Paymax支付日志 ======== 创建订单失败", productId: "\(model.id)")
            }
        } failed: { error in
            IAPTracker.log("Paymax支付日志 ======== 创建订单失败 \(error.localizedDescription)", productId: "\(model.id)")
        }
        
    }
    
    private func mutatePay(model: PayProductListModel) {
        IAPHelper.shared.pay(productId: "\(model.id)", productCode: model.code, price: "\(model.jiage)", source: .coin) {
            FlyerLibHelper.log(.rechargeCoinResult, values: ["type": 1, "result": 1, "price": model.jiage])
            self.mutateLoadProductList()
        } failureBlock: {
            FlyerLibHelper.log(.rechargeCoinResult, values: ["type": 1, "result": 2, "price": model.jiage])
        }
    }
    
    func  bottomCLickReq() {
        guard let model = model.list.first(where: { $0.isSelected }) else { return }
        if self.selectPayType == .paymax {
            guard let url = self.model.extra.info.zfPlatforms.first(where: { $0.type == .paymax })?.url else {
                return
            }
            mutatePaymax(model: model, url: url)
        } else {
            mutatePay(model: model)
        }
        FlyerLibHelper.log(.rechargeCoinClick)
    }
    
}

extension BuyCoinViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(BuyCoinCell.self), for: indexPath) as? BuyCoinCell ?? BuyCoinCell()
        cell.bind(model: model.list[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.collectionView.deselectItem(at: indexPath, animated: false)
        self.model.list.forEach({ $0.isSelected = false })
        let model = model.list[indexPath.row]
        model.isSelected = true
        self.model.list[indexPath.row] = model
        self.collectionView.reloadData()
    }
    
}
