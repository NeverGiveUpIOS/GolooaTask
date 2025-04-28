//
//  LoginAPI.swift
//  Golaa
//
//  Created by chenkaisong on 2024/5/5.
//

extension NetAPI {
    
    struct LoginAPI {
        static let userLogin = APIItem("/user/user/login", des: "登录（自动注册）", m: .post)
        static let facebook  = APIItem("/user/oauth/auth", des: "登录（facebook）", m: .post)
        static let emailCode = APIItem("/user/user/sendMailCaptcha", des: "获取邮箱验证码", m: .get)
        static let phoneCode = APIItem("/user/user/sendCaptcha", des: "获取短信验证码", m: .get)
        static let logout    = APIItem("/user/user/logout", des: "退出登录", m: .post)
        static let disAccountReq = APIItem("/user/user/invalid", des: "注销请求", m: .post)
    }
}

struct LoginReq {
    
    /// 手机号登录
    static func loginPhone(area: String, phone: String, code: String) {
        var pars: [String: Any] = [:]
        pars["captcha"] = code
        pars["username"] = "\(area)-\(phone)"
        NetAPI.LoginAPI.userLogin.reqToModelHandler(parameters: pars, model: GUsrInfo.self) {  model, _  in
            LoginTl.shared.savrUserInfo(model)
            LoginTl.shared.save(source: .phone)
            FlyerLibHelper.log(.phoneCodeLogin, result: true)
            LoginTl.shared.makeRootModes()

        } failed: { error in
            ToastHud.showToastAction(message: error.localizedDescription)
            FlyerLibHelper.log(.phoneCodeLogin, result: false)
        }
    }
    
    /// 邮箱登录
    static func loginEmail(email: String, code: String) {
        var pars: [String: Any] = [:]
        pars["captcha"] = code
        pars["username"] = email
        NetAPI.LoginAPI.userLogin.reqToModelHandler(parameters: pars, model: GUsrInfo.self) { model, _  in
            LoginTl.shared.savrUserInfo(model)
            LoginTl.shared.save(source: .email)
            FlyerLibHelper.log(.emailCodeLogin, result: true)
            LoginTl.shared.makeRootModes()
        } failed: { error in
            ToastHud.showToastAction(message: error.localizedDescription)
            FlyerLibHelper.log(.emailCodeLogin, result: false)
        }
    }
    
    /// 发送邮箱验证码
    static func sendMailCode(_ email: String, type: SendCodeType, _ completion: ((_ isReally: Bool) -> Void)?) {
        var pars: [String: Any] = [:]
        pars["email"] = email
        pars["bizType"] = type.api
        
        NetAPI.LoginAPI.emailCode.reqToJsonHandler(parameters: pars) { _ in
            completion?(true)
        } failed: { error in
            completion?(false)
            ToastHud.showToastAction(message: error.localizedDescription)
        }
    }
    
    /// 发送手机验证码
    static func sendPhoneCode(_ phone: String, area: String, type: SendCodeType, _ completion: ((_ isReally: Bool) -> Void)?) {
        var pars: [String: Any] = [:]
        pars["phone"] = "\(area)-\(phone)"
        pars["bizType"] = type.api
        
        NetAPI.LoginAPI.phoneCode.reqToJsonHandler(parameters: pars) { _ in
            completion?(true)
        } failed: { error in
            completion?(false)
            ToastHud.showToastAction(message: error.localizedDescription)
        }
    }
    
    /// 退出登录
    static func toLogout(completion: ((_ isSuccess: Bool) -> Void)?) {
        NetAPI.LoginAPI.logout.reqToJsonHandler(parameters: nil, success: { _ in
            completion?(true)
            LoginTl.shared.logout()
            LoginTl.shared.makeRootModes()
        }, failed: { error in
            completion?(false)
            ToastHud.showToastAction(message: error.localizedDescription)
        })
    }
    
    /// 注销登录
    static func disAccountReq(completion: ((_ isSuccess: Bool) -> Void)?) {
        NetAPI.LoginAPI.disAccountReq.reqToJsonHandler(parameters: nil, success: { _ in
            completion?(true)
            LoginTl.shared.logout()
            LoginTl.shared.makeRootModes()
        }, failed: { error in
            completion?(false)
            ToastHud.showToastAction(message: error.localizedDescription)
        })
    }
}
