//
//  LoginTmFile.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/7/23.
// 登录工具类

import UIKit
import AppsFlyerLib

class LoginTl {
    
    static let shared = LoginTl()
    
    private init() {
    }
    
    
    var window: UIWindow?
    
        /// 设置 rootViewController
    func makeRootModes(){
        if LoginTl.shared.isLogin {
            AppsFlyerLib.shared().customerUserID = LoginTl.shared.usrId
        }
        window?.backgroundColor = .white
        if self.isLogin, self.isSupply == true {
            window?.rootViewController = BasTabBarVC()
        } else if self.isLogin, self.isSupply == false {
            let vc = LoginDataxsVC()
            let nav = BasNavgVC(rootViewController: vc)
            window?.rootViewController = nav
        } else {
            let vc = LoginLaunchVC()
            let nav = BasNavgVC(rootViewController: vc)
            window?.rootViewController = nav
        }
        window?.makeKeyAndVisible()
    }

    /// 用户信息
    var userInfo: GUsrInfo? {
        guard let ssss = UserDefaults.gt.getModelForKey(GUsrInfo.self, forKey: "UserInfoCache") else {
            return nil
        }
        return ssss
    }
    
    var usrId: String {
        return self.userInfo?.id ?? ""
    }
    
    /// 获取登录 token
    var token: String {
        guard let ssss = UserDefaults.gt.getValueForKey(key: "UserTokenCache") as? String else {
            return ""
        }
        return ssss
    }
    
    /// 是否完善资料
    var isSupply: Bool {
        guard let ssss = UserDefaults.gt.getValueForKey(key: "UserIsSupplyCache") as? Bool else {
            return false
        }
        return ssss
    }
    /// 云信token
    var imToken: String {
        guard let ts = userInfo?.imToken else {
            return ""
        }
        return ts
    }
    
    /// 是否登录
    var isLogin: Bool {
        return token.count > 0
    }

    var loginSource: Int { UserDefaults.gt.getValueForKey(key: LoginHelperKeys.Login.source) as? Int ?? 0 }
    
}

// MARK: - User Login
extension LoginTl {
    
    /// 退出登录
    func logout() {
        mm.imLogOut()
        UserDefaults.gt.removeAllKeyValue()
        makeRootModes()
    }
    
    /// 缓存用户信息
    func savrUserInfo(_ user: GUsrInfo) {
        UserDefaults.gt.saveModelForKey(user.self, forKey: "UserInfoCache")
        if user.token.count > 0 {
            UserDefaults.gt.saveValueForKey(value: user.token, key: "UserTokenCache")
            UserDefaults.gt.saveValueForKey(value: user.isSupply, key: "UserIsSupplyCache")
        }
    }
    
    func save(source: LoginEnum) {
        UserDefaults.gt.saveValueForKey(value: source.source, key: LoginHelperKeys.Login.source)
    }
    
}

// MARK: - UserIfo Req
extension LoginTl {
    
    func getCurUserInfo(_ completion: ((_ usr: GUsrInfo?) -> Void)?) {
        UserReq.userInfo(usrId) { usr in
            if let usr = usr {
                self.savrUserInfo(usr)
            }
            completion?(usr)
        }
    }
    
    func editUsr(_ pars: [String: Any], _ completion: ((_ usr: GUsrInfo?) -> Void)?) {
        UserReq.edit(pars) { [weak self] model in
            if model != nil {
                self?.getCurUserInfo { user in
                    completion?(user)
                }
            } else {
                completion?(model)
            }
        }
    }
}


struct LoginHelperKeys {
    /// 用户存储
    struct User {
        static let token = "com.key.token"
        static let phone = "com.key.phone"
        static let datas = "com.key.datas"
        static let email = "com.key.email"
    }
    
    struct Login {
        static let source = "com.key.source"
    }
}
