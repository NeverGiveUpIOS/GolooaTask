//
//  MessageViewController.swift
//  Golaa
//
//  Created by chenkaisong on 2024/5/5.
//

import UIKit

class MessageViewController: BasTableViewVC {
    
    lazy var allSessions = [MsgSessionModel]()
    
    private lazy var notiLabel: UILabel = {
        let lab = UILabel()
        lab.font = UIFontSemibold(24)
        lab.textColor = UIColorHex("#000000")
        lab.textAlignment = .left
        lab.text = "messages".msgLocalizable()
        return lab
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mm.conSessionDelegate = self
        setupTabView()
        setupRightItems()
        onLanguageChange()
        mm.getAllRecentSessions()
        setupHeadRefresh()
    }
    
    override func onLanguageChange() {
        super.onLanguageChange()
        
        notiLabel.text = "messages".msgLocalizable()
        loadListData()
    }
    
    override func loadListData() {
        super.loadListData()
        mm.getAllRecentSessions()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [weak self] in
            self?.endRefresh()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allSessions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.gt.dequeueReusableCell(cellType: MsgSessionCell.self, cellForRowAt: indexPath)
        if allSessions.count > 0 {
            cell.setupMsgData(allSessions[indexPath.row])
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = allSessions[indexPath.row]
        let sessionId = model.sessionId
        
        switch model.sysMsgnumber {
        case .sysNoti:
            RoutinStore.push(.msgSystem, param: sessionId)
        case .newFeiend:
            RoutinStore.push(.newfriendList)
            mm.markAllMessagesRead(model.sessionId, .P2P)
        case .onleCustomer:
            RoutinStore.push(.singleChat, param: sessionId)
        default:
            if model.sessionType == .groupChat {
                RoutinStore.push(.groupChat, param: sessionId)
                FlyerLibHelper.log(.enterGroupTalkScreen, values: ["user_id": LoginTl.shared.usrId])
            } else {
                RoutinStore.push(.singleChat, param: sessionId)
                FlyerLibHelper.log(.enterSingleTalkScreen, source: "1")
            }
            break
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let model = allSessions[indexPath.row]
        if model.sysMsgnumber == .sysNoti || model.sysMsgnumber == .newFeiend || model.sysMsgnumber == .onleCustomer {
            return nil
        }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "") { [weak self] (action, view, completionHandler) in
            self?.showDeteteAlert(indexPath.row)
            completionHandler(true)
        }
        deleteAction.image = .nsgDeleteSess
        deleteAction.backgroundColor = UIColorHex("#FF5353")
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        
        return configuration
    }
    
}

extension MessageViewController {
    
    /// 删除会话弹窗
    private func showDeteteAlert(_ row: Int) {
        AlertPopView.show(titles: "deleteCurSession".msgLocalizable(), isTouchToDismiss: false) { [weak self] in
            self?.muateDeleteSession(row)
        } cancelCompletion: {
        }
    }
    
    private func setupTabView() {
        tableView?.tableHeaderView = UIView(frame: .init(x: 0, y: 0, width: screW, height: 20))
        tableView?.gt.register(cellClass: MsgSessionCell.self)
        tableView?.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(0)
            make.top.equalTo(naviH)
        }
    }
    private func setupRightItems() {
        
        basNavbView?.addSubview(notiLabel)
        notiLabel.snp.makeConstraints { make in
            make.leading.equalTo(16)
            make.bottom.equalTo(-5)
        }
        
        let search = UIButton(type: .custom)
        search.gt.preventDoubleHit()
        search.setImage(.messageSearch, for: .normal)
        search.setTitle("   ", for: .normal)
        search.gt.handleClick { _ in
            RoutinStore.push(.searchUg)
        }
        
        let more = UIButton(type: .custom)
        more.gt.preventDoubleHit()
        more.setImage(.messageMore, for: .normal)
        more.gt.handleClick { button in
            MsgPopupMenu.show(["createNewGroup".msgLocalizable(), "addFriends".msgLocalizable(), "clearUnread".msgLocalizable()], topRight: .init(x: 15, y: naviH - 8)) { [weak self] index in
                switch index {
                case 0:
                    // 创建群聊
                    self?.groupValidate()
                case 1:
                    // 添加好友
                    RoutinStore.push(.msgAddfriend)
                    FlyerLibHelper.log(.addFriendClick)
                default:
                    // 全部已读
                    NIMSDK.shared().conversationManager.markAllMessagesRead()
                }
            }
        }
        
        basNavbView?.gt.addSubviews([search, more])
        
        more.snp.makeConstraints { make in
            make.width.equalTo(30)
            make.height.equalTo(50)
            make.centerY.equalTo(notiLabel)
            make.trailing.equalTo(-15)
        }
        
        search.snp.makeConstraints { make in
            make.centerY.width.height.equalTo(more)
            make.trailing.equalTo(more.snp.leading).offset(-15)
        }
    }
}

// MARK: - Data
extension MessageViewController {
    
    /// 群校验
    private func groupValidate() {
        MessageReq.groupValidate {
            RoutinStore.push(.createGroup)
            FlyerLibHelper.log(.createGroupClick)
        }
    }
    
    /// 删除会话
    private func muateDeleteSession(_ row: Int){
        
        if  let sesstion = self.allSessions[row].curSession {
            let option = NIMDeleteRecentSessionOption()
            option.shouldMarkAllMessagesReadInSessions = true
            NIMSDK.shared().conversationManager.delete(sesstion, option: option) { error in
                if let error = error {
                    ToastHud.showToastAction(message: error.localizedDescription)
                } else {
                    if let sess = sesstion.session {
                        let deOp = NIMDeleteMessagesOption()
                        NIMSDK.shared().conversationManager.deleteAllmessages(in: sess, option: deOp)
                    }
                }
            }
        }
        
    }
}

// MARK: - 刷新会话
extension MessageViewController: NimConSessionDelegate {
    
    func refreshConSessions() {
        allSessions.removeAll()
        allSessions = mm.allSessions
        tableView?.reloadData()
    }
    
}
