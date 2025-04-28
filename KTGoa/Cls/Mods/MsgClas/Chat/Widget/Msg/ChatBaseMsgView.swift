//
//  ChatBaseMsgView.swift
//  Golaa
//
//  Created by chenkaisong on 2024/5/11.
//

import UIKit

class ChatBaseMsgView: UIView {

    /// 消息长按
    var longPressActionBlock: CallBackVoidBlock?
    /// 消息点击
    var tapActionBlock: CallBackVoidBlock?
    /// 消息发送失败点击
    var failTapActionBlock: CallBackVoidBlock?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        addSubview(contentView)
        addSubview(statusView)
        addSubview(audioRecStatue)

        statusView.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.width.height.equalTo(16)
            make.trailing.equalTo(contentView.snp.leading).offset(-10)
        }
        
        audioRecStatue.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(contentView.snp.trailing).offset(10)
            make.width.height.equalTo(8)
        }
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(customCellLongPressAction(_:)))
        contentView.isUserInteractionEnabled = true
        contentView.addGestureRecognizer(longPress)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// 设置数据
    func setupMsgModel(_ msg: ChatMsgModel) {
    }
    
    /// 消息长按
    @objc private func customCellLongPressAction(_ guesture: UILongPressGestureRecognizer) {
        if guesture.state == .began {
            longPressActionBlock?()
        }
    }
    
    /// 消息容器
     lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    /// 发送方消息状态
     lazy var statusView: ChatMsgStatusView = {
        let view = ChatMsgStatusView()
         view.isHidden = true
         view.statueImageView.gt.handleClick { [weak self] _ in
            // 失败状态的点击
             self?.failTapActionBlock?()
         }
        return view
    }()
    
    /// 接收方语音播放状态
    lazy var audioRecStatue: UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = .hexStrToColor("#F96464")
        view.gt.setCornerRadius(4)
        return view
    }()
}
