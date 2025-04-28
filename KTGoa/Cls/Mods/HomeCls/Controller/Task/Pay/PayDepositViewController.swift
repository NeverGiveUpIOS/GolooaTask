//
//  PayDepositViewController.swift
//  Golaa
//
//  Created by duke on 2024/5/17.
//

import UIKit

class PayDepositViewController: BasClasVC {
    
    var model: TaskPublishModel?
    var selectPayType: TaskPublishZFType = .yuer
    var zfList: [PayDepositModel] = []
    var config: TaskPublishConfig?
    
    override func routerParam(param: Any?, router: RoutinRouter?) {
        if let model = param as? TaskPublishModel {
            self.model = model
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildUI()
        mutateLoadConfigReuslt()
        FlyerLibHelper.log(.enterPayDepositScreen, source: 1)
        addNotiObserver(self, #selector(mutateLoadConfigReuslt), "paySuccessful")
    }
    
    deinit {
        removeNotiObserver(self)
    }
    
    override func backPop() {
        super.backPop()
        FlyerLibHelper.log(.payDepositBackClick)
        RoutinStore.dismiss()
    }
        
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        collectionView.snp.updateConstraints { make in
            let height = collectionView.collectionViewLayout.collectionViewContentSize.height
            make.height.equalTo(height)
        }
    }
    
    @objc  func tapYuerAction(sender: UITapGestureRecognizer) {
        selectPayType = .yuer
        coinPayBtn.layer.borderColor = UIColor.xf2.cgColor
        paymaxBtn.layer.borderColor = UIColor.xf2.cgColor
        yuerPayBtn.layer.borderColor = UIColor.appColor.cgColor
    }
    
    @objc  func tapCoinAction(sender: UIButton) {
        selectPayType = .coin
        coinPayBtn.layer.borderColor = UIColor.appColor.cgColor
        paymaxBtn.layer.borderColor = UIColor.xf2.cgColor
        yuerPayBtn.layer.borderColor = UIColor.xf2.cgColor
    }
    
    @objc  func tapPaymaxAction(sender: UIButton) {
        selectPayType = .paymax
        coinPayBtn.layer.borderColor = UIColor.xf2.cgColor
        paymaxBtn.layer.borderColor = UIColor.appColor.cgColor
        yuerPayBtn.layer.borderColor = UIColor.xf2.cgColor
    }
        
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.isScrollEnabled = true
        view.backgroundColor = .clear
        if #available(iOS 13.0, *) {
            view.automaticallyAdjustsScrollIndicatorInsets = false
        } else {
            view.contentInsetAdjustmentBehavior = .never
        }
        return view
    }()
    
    lazy var logoView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.gt.setCornerRadius(6)
        return img
    }()
    
    lazy var nameLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = .black
        lab.font = UIFontSemibold(14)
        lab.numberOfLines = 2
        return lab
    }()
    
    lazy var priceLabel: UILabel = {
        let lab = UILabel()
        lab.font = .oswaldDemiBold(16)
        lab.textColor = .black
        return lab
    }()
    
    lazy var arcView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.gt.setCustomCoRadius([.layerMinXMinYCorner, .layerMaxXMinYCorner], cornerRadius: 16)
        return view
    }()
    
    lazy var nameTitle: UILabel = {
        let lab = UILabel()
        lab.font = UIFontReg(14)
        lab.textColor = .hexStrToColor("#666666")
        lab.text = "totalTasks".homeLocalizable()
        return lab
    }()
    
    lazy var layout: UICollectionViewFlowLayout = {
        let lay = UICollectionViewFlowLayout()
        lay.minimumInteritemSpacing = 13
        lay.minimumLineSpacing = 18
        lay.itemSize = .init(width: (screW - 30 - 18*2)/3.0, height: 55)
        return lay
    }()
    
    lazy var collectionView: UICollectionView = {
        let col = UICollectionView(frame: .zero, collectionViewLayout: layout)
        col.showsVerticalScrollIndicator = false
        col.showsHorizontalScrollIndicator = false
        col.delegate = self
        col.dataSource = self
        col.gt.register(cellClass: PayDepositCell.self)
        return col
    }()
    
    lazy var earnestTitleLab: UILabel = {
        let lab = UILabel()
        lab.font = UIFontReg(14)
        lab.textColor = .hexStrToColor("#666666")
        lab.text = "payDeposit".homeLocalizable()
        return lab
    }()
    
    lazy var earnestContent: UIView = {
        let view = UIView()
        view.backgroundColor = .xf2
        view.gt.setCornerRadius(8)
        return view
    }()
    
    lazy var earnestLabel: UILabel = {
        let lab = UILabel()
        lab.font = UIFontSemibold(24)
        lab.textColor = .hexStrToColor("#FF5722")
        return lab
    }()
    
    lazy var coinLabel: UILabel = {
        let lab = UILabel()
        lab.font = UIFontMedium(14)
        lab.textColor = .hexStrToColor("#666666")
        return lab
    }()
    
    lazy var zfTitleLab: UILabel = {
        let lab = UILabel()
        lab.font = UIFontReg(14)
        lab.textColor = .hexStrToColor("#666666")
        lab.text = "selectPaymentMethod".homeLocalizable()
        return lab
    }()
    
    lazy var zfContent: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var yuerPayBtn: UIButton = {
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
    
    lazy var coinPayBtn: UIButton = {
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
    
    lazy var paymaxBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.layer.borderColor = UIColor.xf2.cgColor
        btn.layer.borderWidth = 2
        btn.layer.cornerRadius = 8
        btn.image(.zfPaymax)
        btn.addTarget(self, action: #selector(tapPaymaxAction), for: .touchUpInside)
        btn.isHidden = true
        return btn
    }()
    
    lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var bottomBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("payDeposit".homeLocalizable(), for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFontSemibold(14)
        btn.backgroundColor = .appColor
        btn.gt.setCornerRadius(8)
        btn.gt.handleClick { [weak self] _ in
            self?.mutatePublishResult()
        }
        return btn
    }()
}
