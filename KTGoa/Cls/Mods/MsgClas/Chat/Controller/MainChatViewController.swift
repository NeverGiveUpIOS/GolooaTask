//
//  MainChatViewController.swift
//  Golaa
//
//  Created by chenkaisong on 2024/5/7.
//

import UIKit
import IQKeyboardManagerSwift

class MainChatViewController: BasTableViewVC {
    
    /// 输入栏
    lazy var inputBarView = ChatInputBarView()
    /// 会话Id
    var sessionId = ""
    /// 当前会话
    var session: NIMSession?
    /// 是否需要滚动到底部
    private var isScrollBottom = true
    /// 消息数据
    lazy var allMsgs = [ChatMsgModel]()
    
    override func routerParam(param: Any?, router: RoutinRouter?) {
        super.routerParam(param: param, router: router)
        guard let sessionId = param as? String else { return  }
        self.sessionId = sessionId
        session = NIMSession.init(sessionId, type: .P2P)
        NImManager.shared.curSession = session
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupsubViews()
        getMsgInSession()
        setupEmptyView(allMsgs.count)
        navBagColor(.xf2)

        NImManager.shared.chatSessionDelegate = self
        NIMSDK.shared().mediaManager.add(self)
        addNotiObserver(self, #selector(keyboardWillShow), UIResponder.keyboardWillShowNotification.rawValue)
        IQKeyboardManager.shared.enable = true
        
    }
    
    override func rightItemClick() {
        super.rightItemClick()
        self.view.gt.keyboardEnd()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        IQKeyboardManager.shared.enable = true
        NIMSDK.shared().mediaManager.stopPlay()
    }
    
    private func setupsubViews() {
        view.addSubview(inputBarView)
        inputBarView.delegate = self
        inputBarView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        tableView?.backgroundColor = .xf2
        setupHeadRefresh()
        tableView?.gt.register(cellClass: UITableViewCell.self)
        tableView?.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(inputBarView.snp.top)
            make.top.equalTo(naviH)
        }
        textViewHeight(30)
        
        inputBarView.bringSubviewToFront(tableView!)
    }
    
    /// 刷新数据
    override func loadListData() {
        super.loadListData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [weak self] in
            self?.tableView?.header?.endRefreshing()
        }
        
        if let msg = allMsgs.first {
            if let session = session {
                mm.messagesInSession(session, msg.msg, true)
            }
        }
    }
    
    /// 获取消息列表
    private func getMsgInSession(_ message: ChatMsgModel? = nil) {
        if let session = session {
            NImManager.shared.messagesInSession(session, message?.msg, false)
        }
    }
    
    
    deinit {
        removeNotiObserver(self)
        NIMSDK.shared().mediaManager.remove(self)
        session = nil
        NImManager.shared.allMsgs.removeAll()
    }
    
    @objc private func keyboardWillShow() {
        scrollToBottom(animated: false)
    }
}

// MARK: - UITableView
extension MainChatViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allMsgs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let msgRow = indexPath.row
        if msgRow >= 0 && msgRow < allMsgs.count {
            let upperMsg = msgRow-1 >= 0 ? allMsgs[msgRow-1] : nil
            let cell = ChatMsgCell.init(style: .default, msg: allMsgs[indexPath.row], upperMsg: upperMsg)
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.gt.keyboardEnd()
    }
    
    /// scrollToBottom
    func scrollToBottom(animated: Bool, isDeadline: Bool = true, _ deadline: CGFloat = 0.08) {
        if isDeadline == false {
            let rows = tableView?.numberOfRows(inSection: 0) ?? 0
            if rows  > 0 {
                tableView?.scrollToRow(
                    at: IndexPath(row: rows - 1, section: 0),
                    at: .bottom,
                    animated: animated)
            }
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + deadline) { [weak self] in
            if let rows = self?.tableView?.numberOfRows(inSection: 0) {
                if rows  > 0 {
                    self?.tableView?.scrollToRow(
                        at: IndexPath(row: rows - 1, section: 0),
                        at: .bottom,
                        animated: animated)
                }
            }
        }
    }
}

// MARK: - MessageInteractionDelegate
extension MainChatViewController: MessageInteractionDelegate {
    
    /// 消息点击
    func messageTap(msg: ChatMsgModel, view: UIView) {
        switch msg.msgType {
        case .picture:
            ChatMsgHandle.openPhotoBrowserDown(msgs: self.allMsgs, curmsg: msg)
        case .voice:
            ChatMsgHandle.playAudio(msg: msg, dataList: self.allMsgs)
        case .task:
            if  let taskId = msg.taskAttachMent?.msg?.id.toInt() {
                let source = msg.sessionType == .groupChat ? TaskDescFromSource.groupShare.rawValue : TaskDescFromSource.friendShare.rawValue
                RoutinStore.push(.taskDesc, param: ["id": taskId, "source": source])
            }
        default:
            break
        }
    }
    
    /// 消息长按
    func messagelongPress(msg: ChatMsgModel, baseView: UIView, timeView: UIView) {
        ChatMsgHandle.messagelongPress(msg: msg, baseView: baseView, timeView: timeView) { msg in
            NImManager.shared.onRecvRevokeMsg(msg) // 撤回
        }
    }
    
    /// 失败消息点击
    @objc func messageFailTap(msg: ChatMsgModel, view: UIView) {
        if reqMagger.networkStatus == .notReachable {
            ToastHud.showToastAction(message: "noNetwork".globalLocalizable())
            return
        }
        if let _ = msg.msg {
            NImManager.shared.deleteMsg(msg)
            ChatMsgHandle.resendMessage(msg: msg)
            sendMsgStatus()
        }
    }
    
    /// 用户头像点击
    @objc func userHeadTap(msg: ChatMsgModel, view: UIView) {
        if msg.userInfo?.id == YXSystemMsgnumber.onleCustomer.customerId {
            return
        }
        
        guard let userId = msg.userInfo?.id else { return  }
        if msg.msgDirection == .sender {
            RoutinStore.push(.ordinaryUserInfo, param: userId)
            return
        }
        
        UserReq.userInfo(userId) { userInfo in
            if userInfo?.isPublish  ?? false { // 发布者
                RoutinStore.push(.publisherDesc, param: userInfo?.id ?? "")
            } else { // 普通用户
                RoutinStore.push(.ordinaryUserInfo, param: userInfo?.id ?? "")
            }
        }
    }
    
}

// MARK: - ChatInputBarViewDelegate
extension MainChatViewController: ChatInputBarViewDelegate {
    
    /// 发送任务消息
    @objc func sendTaskMsg() {
        ChatMsgHandle.sendTaskMsg(session: session)
        sendMsgStatus()
    }
    
    /// 发送语音消息
    func recordDPath(_ duration: Int, path: String) {
        ChatMsgHandle.sendAudioMsg(duration: duration, path: path, session: session)
        sendMsgStatus()
    }
    
    /// 发送图片消息
    func choseAlbumImgs(_ imgs: [UIImage]) {
        ChatMsgHandle.sendPictureMsg(imgs, session: session)
        sendMsgStatus()
    }
    
    /// 发送文本消息
    func sendTextMsg(_ text: String) {
        ChatMsgHandle.sendTextMsg(text: text, session: session)
        sendMsgStatus()
    }
    
    /// 输入文本高度变化
    func textViewHeight(_ height: Int) {
        var insets: UIEdgeInsets = .zero
        insets.top = 0
        insets.bottom = CGFloat(height)
        tableView?.contentInset = insets
        tableView?.scrollIndicatorInsets = insets
        scrollToBottom(animated: false)
    }
    
    @objc func sendMsgStatus() {
        
    }
}

// MARK: - 语音播放监听
var timer: TimerHelper?
extension MainChatViewController: NIMMediaManagerDelegate {
    
    func playAudio(_ filePath: String, didBeganWithError error: (any Error)?) {
        timer = TimerHelper(interval: 1) { [weak self] count in
            self?.audioPlayProgress(filePath, count)
        }
        timer?.start()
    }
    
    /// 播放完成回调
    func playAudio(_ filePath: String, didCompletedWithError error: (any Error)?) {
        // 获取语音消息
        timer?.cancel()
        let audios = allMsgs.filter({$0.msgType == .voice})
        if let index = audios.firstIndex(where: { $0.audioObject?.path == filePath }) {
            
            let currentAudio = audios[index]
            if currentAudio.msgFrome == LoginTl.shared.usrId {
                audioStatueNormal(filePath: filePath)
                return
            }
            
            let noPlayingMsg = audios[index...(audios.count - 1)].filter({
                $0.audioStatue == nil && $0.msgFrome != LoginTl.shared.usrId
            })
            
            if let playing = noPlayingMsg.first {
                ChatMsgHandle.playAudio(msg: playing, dataList: allMsgs)
            }
            audioStatueNormal(filePath: filePath)
        }
    }
    
    /// 停止播放音频的回调
    func stopPlayAudio(_ filePath: String, didCompletedWithError error: (any Error)?) {
        /// 更新语音消息状态
        audioStatueNormal(filePath: filePath)
        timer?.cancel()
    }
    
    /// 播放进度监听
    private func audioPlayProgress(_ filePath: String, _ count: Int) {
        if let index = allMsgs.firstIndex(where: { $0.audioObject?.path == filePath }) {
            let msgModel = allMsgs[index]
            let duration = (msgModel.audioObject?.duration ?? 0) / 1000
            if count <= duration {
                msgModel.audioDuration = count
                NImManager.shared.updateChatMsg(msgModel)
            } else {
                timer?.cancel()
            }
        }
    }
    
    /// 播放状态恢复正常
    private func  audioStatueNormal(filePath: String) {
        if let index = allMsgs.firstIndex(where: { $0.audioObject?.path == filePath }) {
            if  let message = allMsgs[index].msg, let session = self.session {
                message.localExt = ["statue": IMMsgAudioStatue.normal.rawValue,
                                    "isplayNext": false]
                NImManager.shared.updateMessage(msg: message, session: session)
            }
        }
    }
}

extension MainChatViewController: NimChatSessionDelegate {
    
    func refreshChatMsg(_ isScrollBt: Bool) {
        self.allMsgs = NImManager.shared.allMsgs
        tableView?.reloadData()
        scrollToBottom(animated: isScrollBt)
        setupEmptyView(allMsgs.count)
    }
    
    /// 群组消息变更
    @objc func updateGroupInfo(_ groupId: String) {
        
    }
    
    /// 群组解散
    @objc func dissolveGroup() {
        
    }
    
    /// 用户信息变化
    @objc func updateUserInfo(_ userId: String) {
        
    }
    
    
}
