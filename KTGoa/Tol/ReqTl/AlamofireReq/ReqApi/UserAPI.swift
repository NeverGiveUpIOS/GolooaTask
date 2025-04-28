//
//  UserAPI.swift
//  Golaa
//
//  Created by xiaoxuhui on 2024/5/16.
//

extension NetAPI {
    struct UserAPI {
        static let userInfo = APIItem("/user/user/info", des: "用户信息", m: .get)
        static let userEdit = APIItem("/user/user/edit", des: "用户信息修改", m: .post)
        
        static let rsaSave = APIItem("/user/user/saveRsaPub", des: "保存RSA公钥", m: .post)
        static let rsaInfo = APIItem("/user/user/getPublisherInfo", des: "返回发布者信息", m: .get)
    }
}

struct UserReq {
    
    static func edit(_ pars: [String: Any], _ completion: ((_ usr: GUsrInfo?) -> Void)?) {
        NetAPI.UserAPI.userEdit.reqToModelHandler(parameters: pars, model: GUsrInfo.self) { model, json  in
            completion?(model)
        } failed: { error in
            completion?(nil)
            ToastHud.showToastAction(message: error.localizedDescription)
        }
    }
    
    static func userInfo(_ userId: String, _ completion: ((_ usr: GUsrInfo?) -> Void)?) {
        let pars = ["userId": userId]
        NetAPI.UserAPI.userInfo.reqToModelHandler(parameters: pars, model: GUsrInfo.self) { model, json  in
            completion?(model)
        } failed: { error in
            completion?(nil)
            ToastHud.showToastAction(message: error.localizedDescription)
        }
    }

    static func search(_ name: String, _ completion: ((_ models: [GUsrInfo]?, _ error: NetworkError?) -> Void)?) {
        let pars = ["nickname": name]
        NetAPI.MessageAPI.userSearch.reqToListHandler(false, parameters: pars, model: GUsrInfo.self) { list, _ in
            completion?(list, nil)
        } failed: { error in
            completion?(nil, error)
            ToastHud.showToastAction(message: error.localizedDescription)
        }
    }
    
    static func rsaSave(_ rsa: String, _ completion: ((_ error: NetworkError?) -> Void)?) {
        let pars = ["rsaPub": rsa]
        NetAPI.UserAPI.rsaSave.reqToJsonHandler(parameters: pars) { originalData in
            completion?(nil)
        } failed: { error in
            completion?(error)
            ToastHud.showToastAction(message: error.localizedDescription)
        }
    }

    static func rsaPublic(_ completion: ((_ model: UserRsaPublic?, _ error: NetworkError?) -> Void)?) {
        NetAPI.UserAPI.rsaInfo.reqToModelHandler(false, parameters: nil, model: UserRsaPublic.self) { model, _ in
            completion?(model, nil)
        } failed: { error in
            completion?(nil, error)
            ToastHud.showToastAction(message: error.localizedDescription)
        }
    }
}
