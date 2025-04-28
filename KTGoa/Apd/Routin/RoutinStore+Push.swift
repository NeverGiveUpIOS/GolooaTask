//
//  RoutinStore+Push.swift
//  Golaa
//
//  Created by Cb on 2024/5/29.
//

import Foundation

extension RoutinStore {
    
    // 联系客服
    static func switchConfiguration() {
        RoutinStore.push(.singleChat, param: YXSystemMsgnumber.onleCustomer.customerId)
        FlyerLibHelper.log(.enterSingleTalkScreen, source: "0")
        
    }
    
    /// 开关配置 判断
    static func pushOnlineService() {
        GlobalReq.switchConfiguration { result in
            if result {
                if GlobalHelper.shared.serviceUrl.count > 0 {
                    RoutinStore.push(.webScene(.url(GlobalHelper.shared.serviceUrl)))
                } else {
                    GlobalReq.comKufu { result in
                        if result {
                            RoutinStore.push(.webScene(.url(GlobalHelper.shared.serviceUrl)))
                        } else {
                            switchConfiguration()
                        }
                    }
                }
            } else {
                switchConfiguration()
            }
        }
    }
    
}
