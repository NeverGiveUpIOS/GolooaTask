//
//  PayDeposit_UI.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/8/7.
//

import Foundation

extension PayDepositViewController {
    
    func buildUI() {
        
        view.backgroundColor = .xf2
        navBagColor(.xf2)

        navTitle("payDeposit".homeLocalizable())
        
        guard let model = self.model else { return }
        
        if let logo = model.logo {
            logoView.image = logo
        } else if !model.cover.isEmpty {
            logoView.normalImageUrl(model.cover)
        }
        nameLabel.text = model.name
        priceLabel.text = String(format: "$%@", model.price)
        view.addSubview(scrollView)
        scrollView.addSubview(logoView)
        scrollView.addSubview(nameLabel)
        scrollView.addSubview(priceLabel)
        scrollView.addSubview(arcView)
        scrollView.addSubview(nameTitle)
        scrollView.addSubview(collectionView)
        scrollView.addSubview(earnestTitleLab)
        scrollView.addSubview(earnestContent)
        earnestContent.addSubview(earnestLabel)
        earnestContent.addSubview(coinLabel)
        scrollView.addSubview(zfTitleLab)
        scrollView.addSubview(zfContent)
        zfContent.addSubview(yuerPayBtn)
        zfContent.addSubview(paymaxBtn)
        zfContent.addSubview(coinPayBtn)
        
        let zfItemWidth = (screW - 4*15)/3.0
        let zfItemHeight = 65.0
        
        coinPayBtn.frame = CGRect(x: 15, y: 0, width: zfItemWidth, height: zfItemHeight)
        yuerPayBtn.frame = CGRect(x: 15 + (zfItemWidth + 15) * 1, y: 0, width: zfItemWidth, height: zfItemHeight)
        paymaxBtn.frame = CGRect(x: 15 + (zfItemWidth + 15) * 2, y: 0, width: zfItemWidth, height: zfItemHeight)
        
        view.addSubview(bottomView)
        bottomView.addSubview(bottomBtn)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(naviH)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(-48 - 52 - safeAreaTp)
        }
        
        logoView.snp.makeConstraints { make in
            make.top.equalTo(24)
            make.leading.equalTo(15)
            make.width.height.equalTo(80)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(28)
            make.leading.equalTo(logoView.snp.trailing).offset(15)
            make.width.equalTo(screW - 110 - 15)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.leading.equalTo(logoView.snp.trailing).offset(15)
            make.width.equalTo(screW - 125)
        }
        
        arcView.snp.makeConstraints { make in
            make.top.equalTo(logoView.snp.bottom).offset(25)
            make.leading.trailing.equalToSuperview()
            make.width.equalTo(screW)
            make.bottom.equalTo(500)
        }
        
        nameTitle.snp.makeConstraints { make in
            make.top.equalTo(logoView.snp.bottom).offset(61)
            make.leading.equalTo(15)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(nameTitle.snp.bottom).offset(11)
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.width.equalTo(screW - 30)
            make.height.equalTo(0)
        }
        
        earnestTitleLab.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(30)
            make.leading.equalTo(15)
        }
        
        earnestContent.snp.makeConstraints { make in
            make.top.equalTo(earnestTitleLab.snp.bottom).offset(11)
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.width.equalTo(screW - 30)
            make.height.equalTo(74)
        }
        
        earnestLabel.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.centerX.equalToSuperview()
        }
        
        coinLabel.snp.makeConstraints { make in
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
            make.width.equalTo(screW)
            make.height.equalTo(65)
            make.bottom.equalTo(-65)
        }
        
        bottomView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(52 + 48 + safeAreaTp)
        }
        
        bottomBtn.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.height.equalTo(52)
        }
    }
    
    func updateUI(config: TaskPublishConfig) {
        
        guard let model = model else { return }
        
        if let select = zfList.first(where: { $0.isSelected }) {
            earnestLabel.text = String(format: "$ %.02f", (Double(model.price) ?? 0) * (Double(select.value) ?? 0))
            model.count = Int(select.value) ?? 0
            if let item = self.config?.zfPlatforms.first(where: { $0.type == .coin }) {
                coinLabel.text = String(format: "%d%@", Int(Double(item.jinbiToUSD) * (Double(model.price) ?? 0) * (Double(select.value) ?? 0)), "coins".globalLocalizable())
            }
        }
        
        let zfItemWidth = (screW - 4*15)/3.0
        let zfItemHeight = 65.0
        for item in config.zfPlatforms {
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
                if !config.zfPlatforms.contains(where: { $0.type == .coin }) {
                    yuerPayBtn.frame = .init(x: 15, y: 0, width: zfItemWidth, height: zfItemHeight)
                }
            case .paymax:
                paymaxBtn.isHidden = false
                if !config.zfPlatforms.contains(where: { $0.type == .coin }),
                   !config.zfPlatforms.contains(where: { $0.type == .yuer }) {
                    paymaxBtn.frame = .init(x: 15, y: 0, width: zfItemWidth, height: zfItemHeight)
                } else if !config.zfPlatforms.contains(where: { $0.type == .yuer }) ||
                            !config.zfPlatforms.contains(where: { $0.type == .coin }) {
                    paymaxBtn.frame = .init(x: 15 + (zfItemWidth + 15) * 1, y: 0, width: zfItemWidth, height: zfItemHeight)
                }
            default:
                break
            }
        }
    }
}
