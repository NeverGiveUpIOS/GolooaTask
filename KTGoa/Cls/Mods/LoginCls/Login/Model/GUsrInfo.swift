//
//  GUsrInfo.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/8/1.
//


/// 用户性别
enum Gender: Int, HandyJSONEnum, Codable {
    case girl = 0
    case body = 1
    
    var des: String {
        switch self {
        case .body:
            return "男"
        case .girl:
            return "女"
        }
    }
}

class UserPossession: JsonModelProtocol, Codable {
    required init() {}
    
    var totalAmt = 0
    var totalAmtDes = ""
    var activeAmount = 0
    func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &totalAmt, name: "totalAmount")
        mapper.specify(property: &totalAmtDes, name: "totalAmount_")
    }
}

class GUsrInfo: JsonModelProtocol, Codable {
    required init() {}
    var id: String = ""
    var token: String = ""
    var phone: String = ""
    var email: String = ""
    var session: String = ""
    var gender: Gender = .body
    var avatar: String = ""
    var imToken: String = ""
    var nickname: String = ""
    var username: String = ""
    var isPublish: Bool = false
    var isRegister: Bool = false
    var language: String = ""
    /// 发布者认证状态审核中
    var publishVerifying: Bool = false
    /// 是否待对方同意中
    var isFriendVerifying: Bool = false
    /// 是否为好友
    var isFriend: Bool = false
    /// 个人介绍
    var userInfo: UserIntroduce?
    /// 是否已拉黑
    var isBlock: Bool = false
    /// 是否被冻结
    var isFrozen = false
    /// 是否已注销
    var isInvalid = false
    var isAgent: Bool = false
    var qianbao = UserPossession()
    var jinbi = UserPossession()
    var hasRsa: Bool = false
    // 是否被禁用的发布者
    var isDisabled = false
    var isSupply: Bool = false
    
    var isSel: Bool = false

    var showName: String {
        if isFrozen {
              return "IllegalAccount".msgLocalizable()
        }
        
        if isInvalid {
              return "accountClosed".msgLocalizable()
        }

        if nickname.count > 0 {
            let limitN = nickname.sub(to: 24)
            return limitN
        } else if username.count > 0 {
            let limitN = username.sub(to: 24)
            return limitN
        }
        let limitN = id.sub(to: 24)
        
        return limitN
    }
    
    /// 是否完善资料
    var completed: Bool {
        if avatar.isEmpty { return false }
        if nickname.isEmpty { return false }
        return true
    }
    
    func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &qianbao, name: "account")
        mapper.specify(property: &jinbi, name: "userCoin")
        mapper.specify(property: &hasRsa, name: "rsaConfigured")
    }
}

class UserIntroduce: JsonModelProtocol, Codable {
    
    required init() {}

    /// 个人介绍
    var slogan: String = ""
}
