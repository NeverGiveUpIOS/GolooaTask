//
//  PouchMixHeader.swift
//  Golaa
//
//  Created by Cb on 2024/5/25.
//

import Foundation

class PouchMixHeader: PouchHeader {
    
    static let contentMixHeight = MineLayout.benefitHeight + 15 + MineLayout.benefitHeight + 20
    
    // MARK: - 属性
    override var scene: MineBenefitScene { .coinPouch }
    
    override func configViews() {
        super.configViews()
        
        addSubview(pouchBenefitView)
        pouchBenefitView.snp.makeConstraints { make in
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.top.equalTo(benefitView.snp.bottom).offset(15)
            make.height.equalTo(MineLayout.benefitHeight)
        }
    }
    
    override func configModel(_ model: HomeBalanceModel) {
        super.configModel(model)
        pouchBenefitView.configureItem(model)
        benefitView.configureSubItem(model.coinAcc)
    }
    
    private lazy var pouchBenefitView = MineBenefitView(scene: .pouch)
}
