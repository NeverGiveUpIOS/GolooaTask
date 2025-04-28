//
//  ChatInputToolBarView.swift
//  Golaa
//
//  Created by chenkaisong on 2024/5/11.
//

import UIKit
import AVFoundation

class ChatInputToolBarView: UIView {
    
    var callSendTextBlock: CallBackStringBlock?
    var callTextViewHeightBlock: CallBackIntBlock?
    var callImsgBlock: CallBackArrayBlock?
    var callRecordResultBlock: RecordResultCompletion?
    var callTaskBlock: CallBackVoidBlock?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .hexStrToColor("#FAFAFA")
        setupSubviews()
        updateStatusMute()
        addNotification()

        /// 获取录音资源
        RecorderTool.shared.blockResultCom = { [weak self] (duration, path) in
            self?.callRecordResultBlock?(duration, path)
        }
    }
    
    /// 更新群禁言类型
    func updateStatusMute() {
        if mm.curSession?.sessionType == .team {
            NIMSDK.shared().teamManager.fetchTeamMutedMembers(mm.curSession?.sessionId ?? "") { [weak self] _, userList in
                // 判断是否被禁言
                let isMute = userList?.filter({
                    $0.userId == LoginTl.shared.usrId
                }).count ?? 0 > 0
                
                self?.muteView.isHidden = !isMute
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        removeNotiObserver(self)
        removeNotification()
    }
    
    lazy var voiceButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(.chatKeyboard, for: .selected)
        button.setImage(.chatVoice, for: .normal)
        button.addTarget(self, action: #selector((voiceChange(sender:))), for: .touchDown)
        return button
    }()
    
    private lazy var inputTextView: ChatTextView = {
        let view = ChatTextView()
        view.delegate = self
        view.isHidden = false
        view.textContainer.lineFragmentPadding = 0
        view.textViewHeightChangeCallback = { [weak self] height in // 高度变化
            self?.textViewHeightChange(height)
        }
        view.textDidChangeCallback = { [weak self] text in // 输入的文字变化
            self?.sendButton.isUserInteractionEnabled = text.count > 0
            self?.sendButton.setImage(text.count > 0 ? .msgSendCan : .msgSendNor, for: .normal)
            self?.sendButton.setImage(text.count > 0 ? .msgSendCan : .msgSendNor, for: .highlighted)
        }
        return view
    }()
    
    lazy var recordButton: ChatRecordButton = {
        let button = ChatRecordButton(type: .custom)
        button.isHidden = true
        return button
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(.chatOpenMore, for: .normal)
        button.setImage(.chatOpenMore, for: .highlighted)
        button.addTarget(self, action: #selector(addChange), for: .touchDown)
        return button
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(.msgSendNor, for: .normal)
        button.setImage(.msgSendNor, for: .highlighted)
        button.addTarget(self, action: #selector(senderMsg), for: .touchDown)
        return button
    }()
    
    private lazy var funcBarView: ChatFuncBarView = {
        let view = ChatFuncBarView()
        view.isHidden = true
        view.albumButton.tapButton.gt.handleClick { [weak self] _ in
            self?.albumChosePic()
        }
        view.taskButton.tapButton.gt.handleClick { [weak self] _ in
            self?.choseTask()
        }
        view.giftButton.tapButton.gt.handleClick { [weak self] _ in
            ChatGiftView.showView()
        }
        return view
    }()
    
    private lazy var muteView: ChatMuteView = {
        let view = ChatMuteView()
        view.isHidden = true
        view.addButton.addTarget(self, action: #selector(addChange), for: .touchDown)
        return view
    }()
}

// MARK: -
extension ChatInputToolBarView {
    
    /// 文本消息发送
    @objc private func senderMsg() {
        let msgText = inputTextView.text ?? ""
        if msgText.count <= 0 {
            return
        }
        
        inputTextView.text = ""

        let sapceText = msgText.removeAllSapce
        if sapceText.count <= 0 {
            ToastHud.showToastAction(message: "enterMsg".msgLocalizable())
            return
        }
        
        callSendTextBlock?(sapceText)
    }
    
    /// 语音按钮切换
    @objc  private func voiceChange(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        let isSelected =  sender.isSelected

        if isSelected == false {
            inputTextView.becomeFirstResponder()
        } else {
            inputTextView.gt.keyboardEnd()
            updateinputTextViewBottom(isIphoneX ? 12 : 30)
        }

        funcBarView.isHidden = true
        recordButton.isHidden = !isSelected
        inputTextView.isHidden = isSelected
    }
    
    /// + 号按钮点击
    @objc private func addChange() {
        inputTextView.gt.keyboardEnd()
        
        if funcBarView.isHidden == true {
            updateinputTextViewBottom(130)
            funcBarView.isHidden = false
        } else {
            updateinputTextViewBottom(isIphoneX ? 12 : 30)
            funcBarView.isHidden = true
        }
    }
    
    /// 打开相册
    @objc private func albumChosePic() {
        PictureTl.shared.showAlertPic()
        PictureTl.shared.callImgBlock = { [weak self] img in
            self?.callImsgBlock?([img])
        }

    }
    
    /// 选择任务
    private func choseTask() {
        callTaskBlock?()
        FlyerLibHelper.log(.talkShareMyTaskClick)
    }
    
}

// MARK: - UITextViewDelegate
extension ChatInputToolBarView: UITextViewDelegate {
    
    func textViewHeightChange(_ height: CGFloat) {
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.inputTextView.snp.updateConstraints { make in
                make.height.equalTo(height)
            }
            self?.layoutIfNeeded()
            self?.callTextViewHeightBlock?(Int(40))
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == hhf { // 用户按下了"return"
            senderMsg()
            return false
        }
        return true
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        funcBarView.isHidden = true
        updateinputTextViewBottom(2)
        return true
    }
}

// MARK: - keyboard
extension ChatInputToolBarView {
    
    private func addNotification() {
        // 注册键盘即将出现通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        // 注册键盘即将隐藏通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardShow(_ noti: Notification) {
        guard let userInfo = noti.userInfo, let keyboardRect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let height = keyboardRect.height
        updateinputTextViewBottom(isIphoneX ? height : height + 25)
    }
    
    @objc func keyboardHide(_ noti: Notification) {
        if  funcBarView.isHidden == false {
            return
        }
        updateinputTextViewBottom(isIphoneX ? 12 : 30)
    }
    
    func hiddenFunView() {
        updateinputTextViewBottom(isIphoneX ? 12 : 30)
        funcBarView.isHidden = true
    }
    
}

// MARK: - UI
extension ChatInputToolBarView {
    
    private func setupSubviews() {
        gt.addSubviews([
            voiceButton,
            inputTextView,
            recordButton,
            muteView,
            addButton,
            sendButton,
            funcBarView
        ])
        
        voiceButton.snp.makeConstraints { make in
            make.leading.equalTo(15)
            make.width.height.equalTo(24)
            make.top.equalTo(19)
        }
        
        sendButton.snp.makeConstraints { make in
            make.centerY.equalTo(voiceButton)
            make.trailing.equalTo(-15)
            make.width.equalTo(52)
            make.height.equalTo(38)
        }
        
        addButton.snp.makeConstraints { make in
            make.centerY.equalTo(voiceButton)
            make.trailing.equalTo(sendButton.snp.leading).offset(-15)
            make.width.height.equalTo(24)
        }
        
        inputTextView.snp.makeConstraints { make in
            make.height.equalTo(38)
            make.bottom.equalTo(isIphoneX ? -12 : -30)
            make.top.equalTo(12)
            make.leading.equalTo(voiceButton.snp.trailing).offset(15)
            make.trailing.equalTo(addButton.snp.leading).offset(-15)
        }
        
        recordButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(inputTextView)
            make.height.equalTo(38)
            make.centerY.equalTo(inputTextView)
        }
        
        muteView.snp.makeConstraints { make in
            make.height.equalTo(38)
            make.centerY.equalTo(inputTextView)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
        }
        
        funcBarView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(inputTextView.snp.bottom)
        }
    }
    
    func updateinputTextViewBottom(_ bottom: CGFloat) {
        UIView.animate(withDuration: 0.05) { [weak self] in
            self?.inputTextView.snp.updateConstraints { make in
                make.bottom.equalTo(-bottom)
            }
            self?.layoutIfNeeded()
            self?.callTextViewHeightBlock?(Int(40))
        }
    }
}
