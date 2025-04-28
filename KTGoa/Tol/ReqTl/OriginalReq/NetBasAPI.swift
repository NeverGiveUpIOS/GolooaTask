//
//  NetBasApi.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/7/24.
//

import UIKit

struct NetBasAPI {
    
    static var curEnv: AppReqEnv = .pro
    
    static var basUrl: String {
        switch curEnv {
        case .dev:
            return "https://test.tttaboo.com/api"
        case .pro:
            return "https://tttaboo.com/api"
        case .uat:
            return "https://tttaboo.com/api"
        }
    }
}

extension NetBasAPI {
    
    struct ReqAPI {
        static let userLogin = ReqAPIItem("/user/user/login", des: "登录请求", m: .post)
        static let logoutReq = ReqAPIItem("/user/user/logout", des: "登出请求", m: .post)
        static let zxUserAccountReq = ReqAPIItem("/user/user/invalid", des: "注销请求", m: .post)
        static let getMyTaskList = ReqAPIItem("/user/task/list", des: "注销请求", m: .get)
        static let getPeizComReq = ReqAPIItem("/user/common/data", des: "公共数据获取求", m: .get)
        static let getComKufu = ReqAPIItem("/user/common/kefu", des: "客服数据获取求", m: .get)
        static let getMyUserInfo = ReqAPIItem("/user/user/info", des: "用户信息数据获取求", m: .get)
        static let getLoginEmCode = ReqAPIItem("/user/user/sendMailCaptcha", des: "登录获取邮箱数据获取求", m: .get)

    }
    
}

