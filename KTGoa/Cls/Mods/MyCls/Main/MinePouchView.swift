//
//  MinePouchView.swift
//  Golaa
//
//  Created by Cb on 2024/5/25.
//

import Foundation

class MinePouchView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configViews()
        configActions()
        refreshContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configViews() {
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stackView.addArrangedSubview(leftView)
        leftView.snp.makeConstraints { make in
            make.height.equalToSuperview()
        }
        
        stackView.addArrangedSubview(rightView)
        rightView.snp.makeConstraints { make in
            make.height.equalToSuperview()
        }
    }
    
    private func configActions() {
        leftView.touchHandler = {
            RoutinStore.push(.pouch)
        }
        
        rightView.touchHandler = {
            RoutinStore.push(.buyCoin, param: BuyCoinSource.my.rawValue)
        }
    }
    
    func refreshContent() {
        leftView.titleBtn.setTitle("wallet".meLocalizable(), for: .normal)
        rightView.titleBtn.setTitle("coins".globalLocalizable(), for: .normal)
        leftView.titleBtn.gt.setImageTitlePos(.imgRight, spacing: 0)
        rightView.titleBtn.gt.setImageTitlePos(.imgRight, spacing: 0)
    }
    
    private var model: HomeBalanceModel?
    private var subModel: HomeBalanceAccount?

    func configureItem(_ item: HomeBalanceModel) {
        self.model = item
        leftView.bottomLabel.text =  "\(item.totalAmtDes)"
        rightView.bottomLabel.text =  "\(Int(item.coinAcc.totalAmt))"
    }
    
    // MARK: - 属性
    let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.spacing = 13
        view.distribution = .fillEqually
        return view
    }()
    
    private lazy var leftView: MinePouchContentView = {
        let view = MinePouchContentView()
        view.backgroundColor = UIColor.hexStrToColor("#5DE873")
        view.icon.image = UIImage(named: "mine_ensure_hl")
        return view
    }()
    
    lazy var rightView: MinePouchContentView = {
        let view = MinePouchContentView()
        view.backgroundColor = UIColor.appColor
        view.icon.image = UIImage(named: "mine_pouch_hr")
        return view
    }()
}

class MinePouchContentView: UIView {
    
    var touchHandler: (() -> Void)?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchHandler?()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configViews()
        configActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configViews() {
        gt.setCornerRadius(12)
        clipsToBounds = true
        
        addSubview(icon)
        icon.snp.makeConstraints { make in
            make.width.height.equalTo(70)
            make.trailing.equalToSuperview()
            make.bottom.equalTo(10)
        }
        
        addSubview(titleBtn)
        titleBtn.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.top.equalTo(20)
        }
        
        addSubview(bottomLabel)
        bottomLabel.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.bottom.equalTo(-18)
        }
    }
    
    private func configActions() {}
    
    // MARK: - 属性
    lazy var icon: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    let titleBtn: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 12)
        btn.setImage(UIImage(named: "mine_right_black"), for: .normal)
        return btn
    }()
    
    let bottomLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = .black
        lab.font = .oswaldDemiBold(24)
        return lab
    }()
}
