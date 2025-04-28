//
//  ChatMsgCell.swift
//  Golaa
//
//  Created by chenkaisong on 2024/5/11.
//

protocol MessageInteractionDelegate: NSObjectProtocol {
    /// 消息点击
    func messageTap(msg: ChatMsgModel, view: UIView)
    /// 消息长按
    func messagelongPress(msg: ChatMsgModel, baseView: UIView, timeView: UIView)
    /// 消息失败点击
    func messageFailTap(msg: ChatMsgModel, view: UIView)
    /// 用户头像点击
    func userHeadTap(msg: ChatMsgModel, view: UIView)
}

import UIKit

class ChatMsgCell: UITableViewCell {
    
    /// 用户头像尺寸
    let userImgW = 41
    
    /// 消息方向
    var direction: IMMsgDirection = .sender
    
    /// 消息模型
    var message = ChatMsgModel()
    
    weak var delegate: MessageInteractionDelegate?
    
    init(style: UITableViewCell.CellStyle, msg: ChatMsgModel, upperMsg: ChatMsgModel?) {
        super.init(style: style, reuseIdentifier: ChatMsgCell.cellIdentifier(msg))
        
        selectionStyle = .none
        contentView.backgroundColor = .xf2
        
        direction = msg.msgDirection
        message = msg
        msgView = getMsgView(msg)
        setupSubviews()
        setupTimeState(msg: msg, upperMsg: upperMsg)
        setUserAvatar()
        setupMsgModel(msg: msg)
        msgInteraction()
    }
    
    func setupMsgModel(msg: ChatMsgModel) {
        msgView?.setupMsgModel(msg)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 用户头像
    private lazy var userHead: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFill
        imageView.gt.setCornerRadius(CGFloat(userImgW/2))
        let tap = UITapGestureRecognizer(target: self, action: #selector(checkUserInfo))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    /// 消息时间
    private lazy var msgTime: UILabel = {
        let label = UILabel()
        label.font = UIFontReg(12)
        label.textColor = .hexStrToColor("#999999")
        label.textAlignment = .center
        return label
    }()
    
    /// 消息内容
    private var msgView: ChatBaseMsgView?
    
    /// 气泡
    private lazy var bubbleImg: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = true
        return imageView
    }()
    
}

extension ChatMsgCell {
    
    /// 用户头像点击
    @objc private func checkUserInfo() {
        guard let msgView = msgView else { return  }
        delegate?.userHeadTap(msg: message, view: msgView)
    }
    
    /// 消息交互
    private func msgInteraction() {
        
        msgView?.longPressActionBlock = { [weak self] in
            self?.messagelongPress()
        }
        
        msgView?.tapActionBlock = { [weak self] in
            self?.messageTap()
        }
        
        msgView?.failTapActionBlock = { [weak self] in
            self?.messageFailTap()
        }
    }
    
    /// 消息点击
    private func messageTap() {
        guard let msgView = msgView else { return  }
        delegate?.messageTap(msg: message, view: msgView)
    }
    
    /// 消息长按
    private func messagelongPress() {
        if message.isLongPress == false {
            return
        }
        guard let msgView = msgView else { return  }
        delegate?.messagelongPress(msg: message, baseView: msgView.contentView, timeView: msgTime)
    }
    
    /// 消息失败点击
    private func messageFailTap() {
        guard let msgView = msgView else { return  }
        delegate?.messageFailTap(msg: message, view: msgView)
    }
    
}

// MARK: - UI
extension ChatMsgCell {
    
    private func getMsgView(_ msg: ChatMsgModel) -> ChatBaseMsgView {
        
        switch msg.msgType {
        case .text:
            return ChatTextMsgView()
        case .picture:
            return ChatImgMsgView()
        case .voice:
            return ChatVoiceMsgView()
        case .video:
            return ChatBaseMsgView()
        case .task:
            return ChatTaskMsgView()
        case .gift:
            return ChatGiftMsgView()
        case .tip:
            return ChatMsgTipView()
        case .teamInviteNoti, .teamMuteNoti, .teamDisbandment, .teamKick:
            return ChatTeamNotiMsgView()
        default:
            return ChatBaseMsgView()
        }
    }
    
    private func setupSubviews() {
        
        contentView.gt.addSubviews([
            msgTime,
            userHead,
            msgView!,
            bubbleImg
        ])
        
        direction == .sender ? setupSendRect() : setupReciveRect()
        
        userHead.isHidden = !message.isShowUserHead
        
        let buImg = direction == .sender ? message.sendbubbleImg : message.recivebubbleImg
        bubbleImg.image = UIImage(named: buImg)
    }
    
    /// 发送方布局
    private func setupSendRect() {
        
        msgTime.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(0)
            make.height.equalTo(0)
        }
        userHead.snp.makeConstraints { make in
            make.trailing.equalTo(-15)
            make.top.equalTo(msgTime.snp.bottom).offset(15)
            make.height.width.equalTo(userImgW)
        }
        
        msgView?.snp.makeConstraints({ make in
            make.trailing.equalTo(userHead.snp.leading).offset(message.isShowUserHead ? -10 : 0)
            make.top.equalTo(userHead)
            make.bottom.equalToSuperview()
        })
        
        bubbleImg.snp.makeConstraints { make in
            make.bottom.equalTo(msgView!.snp.bottom)
            make.trailing.equalTo(msgView!.snp.trailing).offset(-5)
        }
    }
    
    /// 接收方布局
    private func setupReciveRect() {
        
        msgTime.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(0)
            make.height.equalTo(0)
        }
        userHead.snp.makeConstraints { make in
            make.leading.equalTo(15)
            make.top.equalTo(msgTime.snp.bottom).offset(15)
            make.height.width.equalTo(userImgW)
        }
        msgView?.snp.makeConstraints({ make in
            make.leading.equalTo(userHead.snp.trailing).offset(message.isShowUserHead ? 10 : 0)
            make.top.equalTo(userHead)
            make.bottom.equalToSuperview()
        })
        
        bubbleImg.snp.makeConstraints { make in
            make.bottom.equalTo(msgView!.snp.bottom)
            make.leading.equalTo(msgView!.snp.leading).offset(5)
        }
    }
    
}

// MARK: - SetData
extension ChatMsgCell {
    
    /// 设置用户头像
    private func setUserAvatar() {
        if let avatar = message.userInfo?.avatar {
            if avatar.count > 0 {
                userHead.headerImageUrl(message.userInfo?.avatar ?? "", placeholder: .publicDefault)
            } else {
                userHead.image = .publicDefault
            }
        } else {
            userHead.image = .publicDefault
        }
    }
    
    /// 时间状态
    private func setupTimeState( msg: ChatMsgModel?, upperMsg: ChatMsgModel?) {
        
        if message.isShowTime == false {
            hiddenMsgTime()
            return
        }
        
        let mTime = Date(timeIntervalSince1970: msg?.msgTime ?? 0)
        
        if upperMsg != nil { // 判断是否需要显示时间
            guard let lastTime = upperMsg?.msgTime else { return }
            let lTime = Date(timeIntervalSince1970: lastTime)
            let interval = mTime.gt.componentCompare(from: lTime, unit: [.minute]).minute ?? 0
            if interval >= 1 {
                setMsgTime(mTime)
            } else {
                upperMsg?.isShowTime == false ? setMsgTime(mTime) : hiddenMsgTime()
            }
        } else {
            setMsgTime(mTime)
        }
    }
    
    /// setupTime
    private func  setMsgTime(_ mDate: Date) {
        msgTime.text = mDate.chatMsgShowTime()
        msgTime.snp.updateConstraints { make in
            make.top.equalTo(15)
            make.height.equalTo(12)
        }
    }
    
    /// setupTime
    private func  hiddenMsgTime() {
        msgTime.text = ""
        msgTime.snp.updateConstraints { make in
            make.top.equalTo(0)
            make.height.equalTo(0)
        }
    }
}

// MARK: - cellIdentifier
extension ChatMsgCell {
    
    class func cellIdentifier(_ msg: ChatMsgModel) -> String {
        /// 消息发送方
        let identifier = msg.msgFrome == LoginTl.shared.usrId ? "MsgDirectionSend" : "MsgDirectionRecive"
        switch msg.msgType {
        case .text:
            return "\(identifier)text" // 文本消息
        case .picture:
            return "\(identifier)image" // 图片消息
        case .voice:
            return "\(identifier)audio" // 语音消息
        case .video:
            return "\(identifier)custom" // 视频消息
        case .task:
            return "\(identifier)task" // 任务消息
        case .gift:
            return "\(identifier)gift" // 礼物消息
        case .tip:
            return "\(identifier)tip" // tip消息
        case .teamInviteNoti:
            return "\(identifier)teamInviteNoti" // 通知消息,群邀请人进群消息
        case .teamMuteNoti:
            return "\(identifier)teamMuteNoti" // 通知消息,群禁言消息
        case .teamDisbandment:
            return "\(identifier)teamDisbandment" // 通知消息,群解散消息
        case .teamKick:
            return "\(identifier)teamDisbandment" // 通知消息,删除群成员
        default:
            return "\(identifier)other" // 其他未知
        }
    }
    
}
