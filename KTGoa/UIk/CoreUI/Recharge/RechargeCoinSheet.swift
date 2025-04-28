//
//  RechargeCoinSheet.swift
//  Golaa
//
//  Created by duke on 2024/5/23.
//

import UIKit

enum RechargeCoinSheetSource: Int {
    case publish = 1
    case makeup = 2
    case gift = 3
}

class RechargeCoinSheet: AlertBaseView {
    private lazy var model = PayProductModel()
    private var dataArray = [PayProductListModel]()
    
    private var source: RechargeCoinSheetSource
    init(source: RechargeCoinSheetSource) {
        self.source = source
        super.init(frame: .zero)
        buildUI()
        loadData()
        FlyerLibHelper.log(.enterHalfRechargeScreen, source: source.rawValue)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show() {
        show(position: .bottom)
    }
    
    private func buildUI() {
        layout.itemSize = .init(width: (screW - 20 - 20*2 - 8*2)/3.0, height: 86)
        addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(colseBtn)
        contentView.addSubview(coinLabel)
        contentView.addSubview(collectionView)
        contentView.addSubview(bottomBtn)
        
        contentView.snp.makeConstraints { make in
            make.bottom.equalTo(-34)
            make.leading.equalTo(10)
            make.trailing.equalTo(-10)
            make.width.equalTo(screW - 20)
            make.height.equalTo(384)
            make.top.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(25)
            make.centerX.equalToSuperview()
        }
        
        colseBtn.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.trailing.equalTo(-16)
            make.width.height.equalTo(20)
        }
        
        coinLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.leading.equalTo(20)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(coinLabel.snp.bottom).offset(10)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(185)
        }
        
        bottomBtn.snp.makeConstraints { make in
            make.bottom.equalTo(-25)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(52)
        }
    }
        
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.gt.setCornerRadius(20)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var colseBtn: UIButton = {
        let btn =  UIButton(type: .custom)
        btn.image(.payClose)
        btn.gt.handleClick { [weak self] _ in
            self?.dismissView()
        }
        return btn
    }()
    
    private lazy var titleLabel: UILabel = {
        let lab = UILabel()
        lab.font = UIFontSemibold(20)
        lab.textColor = .black
        lab.text = "rechargeCoins".globalLocalizable()
        return lab
    }()
    
    private lazy var coinLabel: UILabel = {
        let lab = UILabel()
        lab.font = UIFontSemibold(12)
        lab.textColor = .hexStrToColor("#999999")
        lab.text = String(format: "%@: 0", "myCoins".globalLocalizable())
        return lab
    }()
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let col = UICollectionViewFlowLayout()
        col.minimumLineSpacing = 10
        col.minimumInteritemSpacing = 8
        col.itemSize = .init(width: (screW - 60 - 8*2)/3.0, height: 86)
        col.scrollDirection = .vertical
        return col
    }()
    
    private lazy var collectionView: UICollectionView = {
        let col = UICollectionView(frame: .zero, collectionViewLayout: layout)
        col.showsVerticalScrollIndicator = false
        col.showsHorizontalScrollIndicator = false
        col.alwaysBounceVertical = false
        col.alwaysBounceHorizontal = false
        col.delegate = self
        col.dataSource = self
        col.gt.register(cellClass: RechargeCoinSheetCell.self)
        return col
    }()
    
    private lazy var bottomBtn: UIButton = {
        let btn =  UIButton(type: .custom)
        btn.title("rechargeNow".globalLocalizable())
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFontSemibold(14)
        btn.backgroundColor = .appColor
        btn.gt.setCornerRadius(8)
        btn.gt.preventDoubleHit(3)
        btn.gt.handleClick { [weak self] button in
            self?.ljRecReq()
        }
        return btn
    }()
}

// MARK: - Data
extension RechargeCoinSheet {
    
    private func loadData() {
        NetAPI.GlobalAPI.productList.reqToJsonHandler(parameters: nil) { [weak self] originalData in
            if let list = [PayProductListModel].deserialize(from: originalData.json.toJSON(), designatedPath: "data") as? [PayProductListModel] {
                list.first?.isSelected = true
                self?.model.list = list
                self?.dataArray = list
            }
            if let extra = PayProductListExtra.deserialize(from: originalData.json, designatedPath: "extra") {
                self?.model.extra = extra
                self?.coinLabel.text = String(format: "%@: %d", "myCoins".globalLocalizable(), extra.info.activeJinbi)
            }
            self?.collectionView.reloadData()
        } failed: { error in
            debugPrint(error.localizedDescription)
        }
    }
    
    /// 立即充值
    private func ljRecReq() {
        guard let model = dataArray.first(where: { $0.isSelected }) else { return }
        FlyerLibHelper.log(.halfRechargeCoinClick)
        IAPHelper.shared.pay(productId: "\(model.id)", productCode: model.code, price: "\(model.jiage)", source: .halfCoin) { [weak self] in
            FlyerLibHelper.log(.halfRechargeCoinResult, values: ["type": 1, "result": 1, "price": model.jiage])
            self?.dismissView()
        } failureBlock: {
            FlyerLibHelper.log(.halfRechargeCoinResult, values: ["type": 1, "result": 2, "price": model.jiage])
        }
    }
    
}

extension RechargeCoinSheet: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.gt.dequeueReusableCell(cellType: RechargeCoinSheetCell.self, cellForRowAt: indexPath)
        if dataArray.count > 0 {
            cell.bind(model: dataArray[indexPath.row])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.dataArray.forEach({ $0.isSelected = false })
        let model = self.dataArray[indexPath.row]
        model.isSelected = true
        self.collectionView.reloadData()
    }
    
}
