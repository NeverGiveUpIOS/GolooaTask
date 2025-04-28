//
//  ChatMsgTipView.swift
//  Golaa
//
//  Created by chenkaisong on 2024/5/20.
//

import UIKit

class ChatMsgTipView: ChatBaseMsgView {
    
    var systemModel: ChatSystemModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        contentView.addSubview(textMsg)
        contentView.addSubview(coverButton)
        
        textMsg.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        coverButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(screW - 112)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupMsgModel(_ msg: ChatMsgModel) {
        contentView.backgroundColor = .clear
        textMsg.text = msg.msg?.text
        if let systemModel = msg.systemModel {
            self.systemModel = systemModel
            textMsg.gt.setSpecificTextColor(systemModel.highlight, color: .hexStrToColor(systemModel.color))
        }
        
    }
    
    private  func jumpTap() {
        
        guard let systemModel = systemModel else { return  }
        
        switch systemModel.type {
        case .jumpApp:
            RoutinStore.pushUrl(systemModel.url)
        case .jumpH5:
            RoutinStore.push(.webScene(.url(systemModel.url)))
            break
        default:
            break
        }
    }
    
    private lazy var textMsg: UILabel = {
        let label = UILabel()
        label.font = UIFontReg(12)
        label.textColor = .hexStrToColor("#999999")
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var coverButton: UIButton = {
        let button = UIButton(type: .custom)
        button.gt.handleClick { [weak self] _ in
            self?.jumpTap()
        }
        return button
    }()
}
