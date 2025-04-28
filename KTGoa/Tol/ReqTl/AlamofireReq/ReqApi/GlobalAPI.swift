//
//  GlobalAPI.swift
//  Golaa
//
//  Created by xiaoxuhui on 2024/5/16.
//

import UIKit

extension NetAPI {
    struct GlobalAPI {
        static let metas = APIItem("/user/common/metas", des: "获取元数据请求", m: .get)
        static let productList =  APIItem("/trade/order/productList", des: "商品列表请求", m: .get)
        static let coinRecordList =  APIItem("/trade/coin/log", des: "金币明细请求", m: .get)
        static let dataCommon = APIItem("/user/common/data", des: "全局公共数据获取请求", m: .get)
        static let dataVersion = APIItem("/user/common/versionCheck", des: "app检查更新请求", m: .get)
        static let switchConfiguration = APIItem("/user/common/switchConfig", des: "开关配置请求", m: .get)
        static let comKufu = APIItem("/user/common/kefu", des: "客服请求", m: .get)
    }
}

struct GlobalReq {
    
//    static func getMetas() {
//        NetAPI.GlobalAPI.metas.reqToModelHandler(false, parameters: pars, model: GlobalMetas.self) { [weak self] model, _ in
//            self?.metas = model
//            self?.resetRequestState(.success, for: .meta)
//        } failed: { [weak self] _ in
//            self?.resetRequestState(.errorRequest, for: .meta)
//        }
//    }
    
    
    /// "开关配置请求"
    static func switchConfiguration(completion: @escaping (_ result: Bool) -> Void) {
        NetAPI.GlobalAPI.switchConfiguration.reqToJsonHandler(parameters: nil) { originalData in
            guard let thirdKefuOpen = originalData.data["thirdKefuOpen"] as? Bool else {
                completion(false)
                return
            }
            completion(thirdKefuOpen)
            
        } failed: { _ in
            completion(false)
        }
    }
    
    /// "客服请求"
    static func comKufu(completion: @escaping (_ result: Bool) -> Void) {
        NetAPI.GlobalAPI.comKufu.reqToJsonHandler(false, parameters: nil) { originalData in
            guard let serviceUrl = originalData.data["url"] as? String else {
                completion(false)
                return
            }
            if serviceUrl.count > 0 {
                GlobalHelper.shared.serviceUrl = serviceUrl
            }
            completion(serviceUrl.count > 0)
        } failed: { _ in
            completion(false)}
    }
}
