//
//  SingleChatViewController.swift
//  Golaa
//
//  Created by chenkaisong on 2024/5/21.
//

import UIKit

class SingleChatViewController: MainChatViewController {
    
    var userInfo: GUsrInfo?
    
    override func routerParam(param: Any?, router: RoutinRouter?) {
        guard let sessionId = param as? String else { return  }
        self.sessionId = sessionId
        session = NIMSession.init(sessionId, type: .P2P)
        NImManager.shared.curSession = session
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUserInfo()
        mm.markAllMessagesRead(sessionId, .P2P)
    }
    
    /// 获取用户信息/
    private func getUserInfo() {
        UserReq.userInfo(sessionId) { [weak self] usr in
            if let usr = usr {
                self?.userInfo = usr
                mm.updateLocaUserInfo(usr)
                self?.setupNav(user: usr)
            } else {
                if let loccu = mm.getLocauserInfo(self?.sessionId ?? "") {
                    self?.setupNav(user: loccu)
                }
            }
        }
    }
    
    private func setupNav(user: GUsrInfo) {
        if user.id == YXSystemMsgnumber.onleCustomer.customerId {
            rightItem(nil)
            navTitle("customerService".msgLocalizable())
        } else {
            rightItem(.messageMore)
            navTitle(user.showName)
        }
    }
    
    override func rightItemClick() {
        super.rightItemClick()
        
        if userInfo?.id == YXSystemMsgnumber.onleCustomer.customerId {
            return
        }
        
        tableView?.reloadData()
        self.view.gt.keyboardEnd()
        
        guard let user = userInfo else { return  }
        
        let list = [
            AlertSheetConfig(title: user.isBlock == true ? "unblock".msgLocalizable() : "addToBlacklist".msgLocalizable(), sectionH: 58),
            AlertSheetConfig(title: "report".msgLocalizable(), sectionH: 54)
        ]
        
        AlertSheetView.show(dataSoruce: list) { [weak self] index in
            if index == 0 {
                
                if user.isBlock == true {
                    self?.userFriendBlock()
                    return
                }
                
                // 拉黑
                AlertPopView.show(titles: "areYouSureYouWantTo".msgLocalizable()) {
                    self?.userFriendBlock()
                } cancelCompletion: {
                }
            } else { // 举报
                RoutinStore.push(.accuse, param: ["type": 0, "toUserId": user.id])
            }
        }
    }
    
    /// 添加/取消 拉黑
    private func userFriendBlock() {
        let isBlack = userInfo?.isBlock ?? false
        MessageReq.userFriendBlock(sessionId, isBlack ? 0 : 1) { [weak self] in
            self?.userInfo?.isBlock = !isBlack
        }
    }
    
    /// 用户信息变化 
    override func updateUserInfo(_ userId: String) {
        super.updateUserInfo(userId)
        if userId == sessionId {
            getUserInfo()
        }
    }
    
}
