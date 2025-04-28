//
//  ChatVoiceMsgView.swift
//  Golaa
//
//  Created by chenkaisong on 2024/5/15.
//

import UIKit

class ChatVoiceMsgView: ChatBaseMsgView {
    
    let audioSendImgs = [
        UIImage(named: "chat_audio_send_o")!,
        UIImage(named: "chat_audio_send_t")!,
        UIImage(named: "chat_audio_send")!
    ]
    let audioReciveImgs = [
        UIImage(named: "chat_audio_recive_o")!,
        UIImage(named: "chat_audio_recive_t")!,
        UIImage(named: "chat_audio_recive")!
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        contentView.gt.addSubviews([durationlab, audioIcon, coverBtn])
        contentView.gt.setCornerRadius(20)
        coverBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupMsgModel(_ msg: ChatMsgModel) {
        
        guard let audioObj = msg.audioObject else { return  }
                
        let duration = "\(audioObj.duration / 1000)s"
        contentView.backgroundColor = .hexStrToColor(msg.msgDirection == .sender ? "#F8E679" : "#FFFFFF")
        
        statusView.isHidden = msg.msgDirection != .sender
        statusView.setupStatue(msgStatue: msg.msgStatus, readStatue: msg.msgReadStatue)
        
        contentView.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview()
            make.height.equalTo(40)
            make.leading.equalTo(msg.msgDirection == .sender  ? (50) : 0)
        }
        
        let tDuration = audioObj.duration / 1000
        let durationW = duration.widthAccording(width: screW - 200, font: UIFontReg(15)) + CGFloat(tDuration * 2)
        
        msg.msgDirection == .sender ? setupSendRect(durationW) : setupReciveRect(durationW)
        
        // 消息状态
        if msg.audioStatue != nil {
            audioRecStatue.isHidden = true
            switch msg.audioStatue?.statue {
            case .normal:
                // 正常状态
                durationlab.text = duration
                audioIcon.stopAnimating()
            default:
                // 播放状态
                durationlab.text = "\(msg.audioDuration)s"
                audioIcon.startAnimating()
            }
        } else {
            durationlab.text = duration
            audioRecStatue.isHidden = msg.msgDirection == .sender
            audioIcon.stopAnimating()
        }
    }
    
    private lazy var durationlab: UILabel = {
        let label = UILabel()
        label.font = UIFontReg(15)
        label.textColor = .hexStrToColor("#000000")
        return label
    }()
    
    lazy var audioIcon: UIImageView = {
        let view = UIImageView()
        view.animationDuration = 1
        view.animationRepeatCount = 0
        return view
    }()
    
    lazy var coverBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.gt.preventDoubleHit()
        button.gt.handleClick { [weak self] _ in
            self?.tapActionBlock?()
        }

        return button
    }()
    
}

extension ChatVoiceMsgView {
    
    /// 发送方布局
    private func setupSendRect(_ durationW: CGFloat) {
        
        audioIcon.imageWithString("chat_audio_send")
        audioIcon.animationImages = audioSendImgs
        durationlab.textAlignment = .left

        audioIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(-19)
            make.height.width.equalTo(24)
        }
        
        durationlab.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(audioIcon.snp.leading).offset(-20)
            make.leading.equalTo(19)
            make.width.greaterThanOrEqualTo(durationW)
        }
    }
    
    /// 接收方布局
    private func setupReciveRect(_ durationW: CGFloat) {
    
        audioIcon.imageWithString("chat_audio_recive")
        audioIcon.animationImages = audioReciveImgs
        durationlab.textAlignment = .right
        
        audioIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(19)
            make.height.width.equalTo(24)
        }
        
        durationlab.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(audioIcon.snp.trailing).offset(20)
            make.trailing.equalTo(-19)
            make.width.greaterThanOrEqualTo(durationW)
        }
    }
    
}
