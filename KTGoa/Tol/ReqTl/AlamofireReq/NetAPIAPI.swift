//
//  NetAPI.swift
//  Golaa
//
//  Created by chenkaisong on 2024/5/5.
//

import UIKit

class NetAPI: NSObject {
    
//    static var curEnvironment: AppReqEnv {
//        let value = UserDefaults.standard.integer(forKey: AppReqEnv.envKey)
//        return AppReqEnv(rawValue: value) ?? .pro
//    }
    
    static var curEnvironment: AppReqEnv = .pro
    
    static var BasAPI: String {
        switch curEnvironment {
        case .dev:
            return "https://test.tttaboo.com"
        case .pro:
            return "https://tttaboo.com"
        case .uat:
            return "https://uat.tttaboo.com"
        }
    }
    
    static var OSSDomain: String {
        switch curEnvironment {
        case .dev:
            return "https://test-oss.tttaboo.com"
        case .pro:
            return "https://oss.tttaboo.com"
        case .uat:
            return "https://test-oss.tttaboo.com"
        }
    }
    
    static var API: String {
       return BasAPI + "/api"
    }
}
