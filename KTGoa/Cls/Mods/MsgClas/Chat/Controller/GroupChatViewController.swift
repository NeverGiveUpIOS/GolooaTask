//
//  GroupChatViewController.swift
//  Golaa
//
//  Created by chenkaisong on 2024/5/21.
//

import UIKit

class GroupChatViewController: MainChatViewController {
    
    lazy var groupInfoModel = MsgGroupInfoModel()
    
    override func routerParam(param: Any?, router: RoutinRouter?) {
        guard let sessionId = param as? String else { return  }
        self.sessionId = sessionId
        session = NIMSession.init(sessionId, type: .team)
        NImManager.shared.curSession = session
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateGroupInfo(sessionId)
        mm.markAllMessagesRead(sessionId, .team)
    }
    
    override func sendMsgStatus() {
        super.sendMsgStatus()
        let _ = groupIsUser()
    }
    
    /// 发送任务消息
    override func sendTaskMsg() {
        super.sendTaskMsg()
        
        if groupInfoModel.isDissolve == true {
            ToastHud.showToastAction(message: "youIsInNOgroup".msgLocalizable())
            return
        }
        if groupInfoModel.isDisable == true {
            ToastHud.showToastAction(message: "groupDisabled".msgLocalizable())
            return
        }
        ChatMsgHandle.sendTaskMsg(session: session)
    }
    
    /// 失败消息点击
    override func messageFailTap(msg: ChatMsgModel, view: UIView) {
        super.messageFailTap(msg: msg, view: view)
        
        if reqMagger.networkStatus == .notReachable {
            ToastHud.showToastAction(message: "noNetwork".globalLocalizable())
            return
        }
        
        if let _ = msg.msg {
            if !groupIsUser() {
                return
            }
            mm.deleteMsg(msg)
            ChatMsgHandle.resendMessage(msg: msg)
        }
    }
    
    /// 获取服务器群信息
    private func getSeverGroupInfo(_ groupId: String) {
        NetAPI.GroupAPI.info.reqToModelHandler(parameters: ["groupId": groupId], model: NIMGroupModel.self) { [weak self] model, _ in
            let group = MsgGroupInfoModel()
            group.groupName = model.name
            group.groupAvatar =  model.avatar
            group.groupId =  model.teamId
            group.memberNumber = model.memberCount
            group.severId = model.id
            group.status = model.status
            mm.updateLocaGroupInfo(group)
            
            self?.groupInfoModel = group
            self?.navTitle("\(group.groupName) (\(model.memberCount))")
            self?.rightItem(.messageMore)
            self?.inputBarView.updateStatusMute()
            
        } failed: { [weak self] error in
            
            if error.status == "group_dissolve" {
                // 群以解散
                self?.groupInfoModel.isDissolve = true
            }
            if error.status == "group_disable" {
                // 群已被禁用
                self?.groupInfoModel.isDisable = true
            }
            
            self?.rightItem(nil)
            
            if let group = mm.getLocaGroupInfo(self?.sessionId ?? "") {
                self?.navTitle("\(group.groupName) (\(group.memberNumber))")
            }
        }
    }
    
    override func rightItemClick() {
        super.rightItemClick()
        self.view.gt.keyboardEnd()
        let severId = groupInfoModel.severId
        RoutinStore.push(.groupInfo, param: ["groupId": severId])
    }
    
    ///   群组解散
    override func dissolveGroup() {
        super.dissolveGroup()
        groupInfoModel.isDissolve = true
    }
    
    /// 群组信息变更
    override func updateGroupInfo(_ groupId: String) {
        super.updateGroupInfo(groupId)
        
        // 获取群组信息
        if let group = mm.getLocaGroupInfo(sessionId) {
            getSeverGroupInfo(group.severId)
        } else {
            mm.getSeverGroupInfo(sessionId) { [weak self] groupInfo in
                self?.getSeverGroupInfo(groupInfo.severId)
            }
        }
    }
    
    /// 群是否可用
    private func groupIsUser() -> Bool {
        if groupInfoModel.status == .kicked || groupInfoModel.status == .visitor || groupInfoModel.isDissolve == true {
            ToastHud.showToastAction(message: "youIsInNOgroup".msgLocalizable())
            return false
        }
        
        if groupInfoModel.isDisable {
            ToastHud.showToastAction(message: "groupDisabled".msgLocalizable())
            return false
        }
        return true
    }
}
