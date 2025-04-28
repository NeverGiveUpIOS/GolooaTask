//
//  ChatGiftMsgView.swift
//  Golaa
//
//  Created by chenkaisong on 2024/5/23.
//

import UIKit

class ChatGiftMsgView: ChatBaseMsgView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        contentView.addSubview(icon)
        contentView.addSubview(name)
        contentView.addSubview(price)
        contentView.gt.setCornerRadius(20)
        contentView.backgroundColor = .hexStrToColor("#FFFFFF")

        setupRect()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupMsgModel(_ msg: ChatMsgModel) {
        
        // print("礼物信息:=====:\(msg.giftAttachMent?.toJSON() ?? [:])")
        guard let giftInfo = msg.giftAttachMent?.msg?.gift else { return  }
        
        name.text = msg.msgDirection == .sender ? "sendGift".msgLocalizable() : "reciveGift".msgLocalizable()
        price.text = "\(giftInfo.name) x\(msg.giftAttachMent?.msg?.amount ?? "0")"
        icon.normalImageUrl(giftInfo.icon)

        statusView.isHidden = true

    }

    private lazy var name: UILabel = {
        let label = UILabel()
        label.font = UIFontMedium(14)
        label.textColor = .hexStrToColor("#000000")
        return label
    }()
    
    private lazy var price: UILabel = {
        let label = UILabel()
        label.font = UIFontReg(12)
        label.textColor = .hexStrToColor("#999999")
        return label
    }()
    
    private lazy var icon: UIImageView = {
        let view = UIImageView()
        view.gt.setCornerRadius(8)
        view.contentMode = .scaleAspectFill
        return view
    }()
    
}

extension ChatGiftMsgView {
    
     func setupRect() {
        
         contentView.snp.makeConstraints { make in
             make.trailing.leading.top.bottom.equalToSuperview()
             make.width.equalTo(screW - 166)
             make.height.equalTo(70)
         }
         
        icon.snp.makeConstraints { make in
            make.width.height.equalTo(44)
            make.bottom.equalTo(-13)
            make.leading.top.equalTo(13)
        }
        
        name.snp.makeConstraints { make in
            make.top.equalTo(14)
            make.leading.equalTo(icon.snp.trailing).offset(10)
            make.trailing.equalTo(-10)
        }
        
        price.snp.makeConstraints { make in
            make.bottom.equalTo(-14)
            make.leading.trailing.equalTo(name)
        }
    }
    
}
