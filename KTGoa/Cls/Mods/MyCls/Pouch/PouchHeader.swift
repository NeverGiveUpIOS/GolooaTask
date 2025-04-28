//
//  PouchHeader.swift
//  Golaa
//
//  Created by Cb on 2024/5/20.
//

import Foundation

class PouchHeader: UICollectionReusableView {
    
    static let contentHeight = MineLayout.benefitHeight + 15 
    static let ensureContentHeight = MineLayout.benefitHeight + 15 + 37 + 12
    static let choreContentHeight = MineLayout.benefitHeight + 15 + 37 + 12
    static let coinContentHeight = MineLayout.benefitHeight + 15 + 37 + 12

    override init(frame: CGRect) {
        super.init(frame: frame)
        configViews()
        configActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configViews() {
        clipsToBounds = true

        addSubview(benefitView)
        benefitView.snp.makeConstraints { make in
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.top.equalToSuperview()
            make.height.equalTo(MineLayout.benefitHeight)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(15)
            make.top.equalTo(benefitView.snp.bottom).offset(30)
        }
    }
    
    private func configActions() {}
    
    func configModel(_ model: HomeBalanceModel) {
        benefitView.configureItem(model)
    }
    
    func configureSubItem(_ item: HomeBalanceAccount) {
        benefitView.configureSubItem(item)
        titleLabel.text = scene.bottomTitle
    }
    
    // MARK: - 属性
    
    var scene: MineBenefitScene { .pouch }
    lazy var benefitView = MineBenefitView(scene: scene)
    private let titleLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.black
        lab.font = .boldSystemFont(ofSize: 16)
        return lab
    }()
}
