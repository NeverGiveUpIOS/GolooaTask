//
//  NImManager+Login.swift
//  Golaa
//
//  Created by chenkaisong on 2024/5/8.
//  登录处理

extension NImManager {
    
    /// 云信登录
    func imLogin() {
        NIMSDK.shared().loginManager.login(LoginTl.shared.usrId, token: LoginTl.shared.imToken) { [weak self] error in
            if let err = error {
                 debugPrint("login error in app : ", err.localizedDescription)
                ToastHud.showToastAction(message: err.localizedDescription)
            } else {
                self?.getAllUnreadCount()
                self?.updateMyUserInfo()
                self?.getAllRecentSessions()
            }
        }
    }
    
    /// 云信退出登录
    func imLogOut() {
        NIMSDK.shared().loginManager.logout { error in
            if let err = error {
                 debugPrint("logout error in app : ", err.localizedDescription)
            } else {
                 debugPrint("logout success in app : ")
            }
        }
    }
}

extension NImManager: NIMLoginManagerDelegate {
    
    /// 登录状态
    func onLogin(_ step: NIMLoginStep) {
        //debugPrint("onLogin : \(step)")
    }
    
    /// 被踢下线
    func onKickout(_ result: NIMLoginKickoutResult) {
        LoginTl.shared.logout()
    }
    
    /// 登录失败
    func onAutoLoginFailed(_ error: any Error) {
        //debugPrint("onAutoLoginFailed : \(error.localizedDescription)")
    }
}
