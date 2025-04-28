//
//  IAPAPI.swift
//  Golaa
//
//  Created by duke on 2024/5/7.
//

import UIKit

extension NetAPI {
    struct IAPAPI {
        static let createAPI = APIItem("/trade/order/create", des: "充值订单创建接口", m: .post)
        static let log = APIItem("/trade/order/step", des: "支付日志上报", m: .post)
        static let fail = APIItem("/trade/order/fail", des: "支付失败的回传", m: .post)
        static let validate = APIItem("/trade/order/validate", des: "充值订单上报及验证接口", m: .post)
    }
}
