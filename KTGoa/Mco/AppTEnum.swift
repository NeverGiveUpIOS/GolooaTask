//
//  AppTEnum.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/8/1.
//

/// app环境
enum AppReqEnv: Int, CaseIterable {
    case dev    = 0
    case uat
    case pro
    
    static let envKey = "GolaaApplicationEnv"
    
    var desc: String {
        switch self {
        case .dev:
            return "测试环境"
        case .uat:
            return "uat环境"
        case .pro:
            return "正式环境"
        }
    }
}

/// 获取验证码(bizType)
enum SendCodeType {
    case login // 登陆
    case bind // 绑定
    case register // 注册
    case findPwd // 找回密码
    case auth // 认证身份
    case teen // 青少年模式验证码
    
    var api: String {
        switch self {
        case .login:
            return "tryLogin"
        case .bind:
            return "bind"
        case .register:
            return "register"
        case .findPwd:
            return "findPwd"
        case .auth:
            return "auth"
        case .teen:
            return "findTeenPwd"
        }
    }
}
/// 网络类型
enum ReqReachabilityStatus {
    case unknown
    case notReachable
    case ethernetOrWiFi
    case cellular
}

/// app环境
enum LoginEnum: Int {
    case none = 0
    case faceb = 2
    case apple = 3
    case phone = 4
    case email = 5

    var source: Int {
        switch self {
        case .none:
            return 0
        case .faceb:
            return 2
        case .apple:
            return 3
        case .phone:
            return 4
        case .email:
            return 5
        }
    }
}
