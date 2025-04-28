//
//  ChatGiftView.swift
//  Golaa
//
//  Created by chenkaisong on 2024/5/23.
//

import UIKit

class ChatGiftView: AlertBaseView {
    
    var selModel: GiftItemModel?
    
    static func showView() {
        let view = ChatGiftView()
        view.show(position: .bottom, isFadeIn: false)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviews()
        getGiftList()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contView.gt.addCorner(conrners: [.topLeft, .topRight], radius: 20)
    }
    
    /// 礼物列表
    private func getGiftList() {
        
        MessageReq.giftList([:]) { [weak self] list in
            
            var tList = list
            
            if let fModel = tList.first {
                fModel.isSelected = true
                tList[0] = fModel
                self?.selModel = fModel
            }
            
            self?.giftPanelView.data = tList
        }
    }
    
    private func sendGift() {
        guard let model = self.selModel else { return  }
        
        dismissView()

        MessageReq.sendGift([
            "giftId": model.id,
            "giftNum": 1,
            "toUserId": mm.curSession?.sessionId ?? ""
        ]) { 
            FlyerLibHelper.log(.sendMessageClick)
            // 加载及保存用户信息
            LoginTl.shared.getCurUserInfo { usr in
                
            }
        }
    }
    
    /// 内容
    private lazy var contView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(.msgGiftClose, for: .normal)
        button.gt.handleClick { [weak self] _ in
            self?.dismissView()
        }
        return button
    }()
    
    private lazy var title: UILabel = {
        let label = UILabel()
        label.font = UIFontSemibold(18)
        label.textColor = .hexStrToColor("#000000")
        label.textAlignment = .left
        label.text = "gift".msgLocalizable()
        return label
    }()
    
    private lazy var giftPanelView: GiftPanelView = {
        let view = GiftPanelView()
        view.backgroundColor = .white
        view.callSendGiftBlock = { [weak self] model in
            guard let model = model as? GiftItemModel else { return }
            self?.selModel = model
        }
        return view
    }()
    
    lazy var goldButton: UIButton = {
        debugPrint("用户信息:\(LoginTl.shared.userInfo?.toJSON() ?? [:])")
        let button = UIButton(type: .custom)
        button.contentHorizontalAlignment = .center
        button.setTitleColor(.hexStrToColor("#000000"), for: .normal)
        button.titleLabel?.font = UIFontSemibold(14)
        button.setTitle(" \(LoginTl.shared.userInfo?.jinbi.totalAmt ?? 0)", for: .normal)
        button.setImage(.msgGiftCoin, for: .normal)
        return button
    }()
    
    lazy var recButton: UIButton = {
        let button = UIButton(type: .custom)
        button.contentHorizontalAlignment = .center
        button.setTitleColor(.hexStrToColor("#2697FF"), for: .normal)
        button.titleLabel?.font = UIFontMedium(12)
        button.setTitle("recharge".msgLocalizable(), for: .normal)
        button.gt.handleClick { [weak self] _ in
            RechargeCoinSheet(source: .gift).show()
            self?.dismissView()
        }
        return button
    }()
    
    lazy var giveButton: UIButton = {
        let button = UIButton(type: .custom)
        button.contentHorizontalAlignment = .center
        button.setTitleColor(.hexStrToColor("#000000"), for: .normal)
        button.titleLabel?.font = UIFontMedium(14)
        button.backgroundColor = .appColor
        button.gt.setCornerRadius(35/2)
        button.gt.preventDoubleHit()
        button.setTitle("giveSend".msgLocalizable(), for: .normal)
        button.gt.handleClick { [weak self] _ in
            self?.sendGift()
        }
        return button
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ChatGiftView {
    
    private func setupSubviews() {
        
        addSubview(contView)
        contView.gt.addSubviews([title,
                              giftPanelView,
                              closeButton,
                              giveButton,
                              goldButton,
                              recButton])
        
        contView.snp.makeConstraints { make in
            make.edges.equalTo(0)
            make.width.equalTo(screW)
        }
        
        title.snp.makeConstraints { make in
            make.leading.equalTo(15)
            make.top.equalTo(15)
        }
        
        closeButton.snp.makeConstraints { make in
            make.centerY.equalTo(title)
            make.trailing.equalTo(-15)
            make.width.height.equalTo(35)
        }
        
        giftPanelView.snp.makeConstraints { make in
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.bottom.equalTo(giveButton.snp.top).offset(-10)
            make.top.equalTo(title.snp.bottom).offset(15)
            make.height.equalTo(315)
        }
        
        giveButton.snp.makeConstraints { make in
            make.width.equalTo(70)
            make.height.equalTo(35)
            make.trailing.equalTo(-15)
            make.bottom.equalTo(-41)
        }
        
        goldButton.snp.makeConstraints { make in
            make.leading.equalTo(15)
            make.centerY.equalTo(giveButton)
        }
        
        recButton.snp.makeConstraints { make in
            make.leading.equalTo(goldButton.snp.trailing).offset(10)
            make.centerY.equalTo(giveButton)
        }
    }
    
}
