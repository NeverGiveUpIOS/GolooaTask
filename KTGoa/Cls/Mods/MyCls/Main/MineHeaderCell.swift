//
//  MineHeaderCell.swift
//  Golaa
//
//  Created by Cb on 2024/5/14.
//

import UIKit

class MineHeaderCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configViews()
        configActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configViews() {
        contentView.clipsToBounds = true
        contentView.addSubview(bgIcon)
        bgIcon.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaTp + 15)
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
        }
        
        let botView = UIView()
        contentView.addSubview(botView)
        botView.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.centerY.equalTo(snp.bottom)
        }

        botView.layer.cornerRadius = 20
        botView.backgroundColor = UIColor.xf2
    }
    
    private func configActions() {
        
    }
    
    private var model: HomeBalanceModel?
    
    func configureItem(_ item: HomeBalanceModel) {
        self.model = item
        benefitView.configureItem(item)
        poushView.configureItem(item)
        singleView.configureItem(item)
    }
    
    func configList(_ list: [MineCellLayoutable]) {
        guard let list = list as? [MineHeaderType] else { return }
        self.list = list

        if stackView.subviews.count > 0 {
            stackView.subviews.forEach({ $0.removeFromSuperview() })
        }
        
        for i in list {
            if i == .userInfo {
                if userView.superview == nil {
                    userView.updataUsr()
                    stackView.insertArrangedSubview(userView, at: 0)
                    userView.snp.makeConstraints { make in
                        make.width.equalToSuperview()
                        make.height.equalTo(i.itemHeight(row: i.rawValue))
                    }
                }
            } else if i == .pouch {
                if poushView.superview == nil {
                    stackView.addArrangedSubview(poushView)
                    poushView.snp.makeConstraints { make in
                        make.width.equalToSuperview()
                        make.height.equalTo(i.itemHeight(row: i.rawValue))
                    }
                }
                poushView.refreshContent()
            } else if i == .pouchCoin {
                if singleView.superview == nil {
                    stackView.addArrangedSubview(singleView)
                    singleView.snp.makeConstraints { make in
                        make.width.equalToSuperview()
                        make.height.equalTo(i.itemHeight(row: i.rawValue))
                    }
                }
                singleView.refreshContent()
            } else if i == .benefit {
                if benefitView.superview == nil {
                    stackView.addArrangedSubview(benefitView)
                    benefitView.snp.makeConstraints { make in
                        make.width.equalToSuperview()
                        make.height.equalTo(i.itemHeight(row: i.rawValue))
                    }
                }
                benefitView.refreshContent()
            }
        }
    }
        
    // MARK: - 属性
    private var list: [MineHeaderType] = []
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.spacing = 20
        return view
    }()
    
    private lazy var userView = MineUserView()
    fileprivate lazy var benefitView = MineBenefitView(scene: .mine)
    private lazy var poushView = MinePouchView()
    private lazy var singleView = MineSinglePouchView()

    private let bgIcon: UIImageView =  {
        let view = UIImageView()
        view.image = UIImage.gt.gradient(["#50504D", "#323230"], size: CGSize(width: screW, height: MineHeaderType.totalHeight()), locations: [0, 1], direction: .vertical)
        return view
    }()
}

//extension Reactive where Base: MineHeaderCell {
//    // 位数限制
//    var balanceModel: Binder<HomeBalanceModel> {
//        return Binder(base) { view, model in
//            view.benefitView.configureItem(model)
//        }
//    }
//}
