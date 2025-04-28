//
//  ChatTextMsgView.swift
//  Golaa
//
//  Created by chenkaisong on 2024/5/11.
// 文本消息

import UIKit

class ChatTextMsgView: ChatBaseMsgView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        contentView.addSubview(textMsg)
        contentView.gt.setCornerRadius(20)
        
        textMsg.snp.makeConstraints { make in
            make.leading.equalTo(18)
            make.trailing.equalTo(-18)
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
            make.width.lessThanOrEqualTo(screW - 160)
            make.height.greaterThanOrEqualTo(20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupMsgModel(_ msg: ChatMsgModel) {
                
        textMsg.text = msg.msg?.text
        contentView.backgroundColor = .hexStrToColor(msg.msgDirection == .sender ? "#F8E679" : "#FFFFFF")

        statusView.isHidden = msg.msgDirection != .sender
        statusView.setupStatue(msgStatue: msg.msgStatus, readStatue: msg.msgReadStatue)
        
        contentView.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview()
            make.leading.equalTo(msg.msgDirection == .sender ? 50 : 0)
        }
    }

    private lazy var textMsg: UILabel = {
        let label = UILabel()
        label.font = UIFontReg(15)
        label.textColor = .hexStrToColor("#000000")
        label.numberOfLines = 0
        return label
    }()
}
