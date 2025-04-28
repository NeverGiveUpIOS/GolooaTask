//
//  NetReqEnum.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/7/24.
//

import Foundation

let reqManager = NetReqTl()

///// app网络请求环境
//enum AppReqEnv {
//    case dev, pro
//}

/// 请求方法
enum NetReqMethod {
    case get, post
}

struct ReqHeaders {
    static var headers:[String : String]{
        return [
            "App-Id" : "Golaa/iOS/\(AppVersion)/golaa",
            "accept": "application/json",
            "Accept-Language": "zh-CN"
        ]
    }
    
    static var configuration: URLSessionConfiguration {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 60
        config.timeoutIntervalForResource = 60
        return config
    }
}


