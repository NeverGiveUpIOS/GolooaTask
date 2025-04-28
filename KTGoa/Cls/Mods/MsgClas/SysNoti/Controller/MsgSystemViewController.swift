//
//  MsgSystemViewController.swift
//  Golaa
//
//  Created by chenkaisong on 2024/5/17.
//

import UIKit

class MsgSystemViewController: BasTableViewVC {
    
    /// 会话Id
    var sessionId = ""
    /// 当前会话
    private var session: NIMSession?
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
        
        view.backgroundColor = .xf2
        navTitle("notifications".msgLocalizable())
        navBagColor(.xf2)

        NImManager.shared.chatSessionDelegate = self
        setupTabView()
        getMsgInSession()
        FlyerLibHelper.log(.systemNoteClick)
        
        if let session = session {
            NIMSDK.shared().conversationManager.markAllMessagesRead(in: session) { _ in
            }
        }
        
        NImManager.shared.markAllMessagesRead(sessionId, session?.sessionType ?? .P2P)
        
        NetAPI.UserAPI.userInfo.reqToModelHandler(parameters: nil, model: GUsrInfo.self) { model, _  in
            LoginTl.shared.savrUserInfo(model)
        } failed: { _ in
        }
        
        setupEmptyView(0)
    }
    
    /// 获取消息列表
    private func getMsgInSession(_ message: ChatMsgModel? = nil) {
        if let session = session {
            mm.messagesInSession(session, message?.msg, false)
        }
    }
    
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
    
    private func setupTabView() {
        tableView?.tableHeaderView = UIView(frame: .init(x: 0, y: 0, width: 10, height: 10))
        setupHeadRefresh()
        tableView?.gt.register(cellClass: MsgSystemViewCell.self)
        tableView?.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.top.equalTo(naviH)
        }
    }
    
    deinit {
        NImManager.shared.curSession = nil
        NImManager.shared.allMsgs.removeAll()
        session = nil
    }
}

extension MsgSystemViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let systemModel = allMsgs[indexPath.row].systemModel else { return }
        let jumpUrl = systemModel.url
        
        debugPrint("路由链接: \(jumpUrl)")
        
        switch allMsgs[indexPath.row].systemModel?.type {
        case .jumpApp:
            RoutinStore.pushUrl(jumpUrl)
            FlyerLibHelper.log(.systemNoteLinkClick)
        case .jumpH5:
            RoutinStore.push(.webScene(.url(jumpUrl)))
            FlyerLibHelper.log(.systemNoteLinkClick)
        default:
            break
        }
        
    }
}


// MARK: -
extension MsgSystemViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allMsgs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.gt.dequeueReusableCell(cellType: MsgSystemViewCell.self, cellForRowAt: indexPath)
        if allMsgs.count > 0 {
            cell.setupSysData(allMsgs[indexPath.row])
        }
        return cell
    }
    
}

extension MsgSystemViewController: NimChatSessionDelegate {
    
    func refreshChatMsg(_ isScrollBt: Bool) {
        self.allMsgs = NImManager.shared.allMsgs
        tableView?.reloadData()
        
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
