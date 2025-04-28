//
//  IAPTracker.swift
//  Golaa
//
//  Created by duke on 2024/5/7.
//

import UIKit

class IAPTracker: NSObject {
    
    /// 上传支付埋点
    static func log(_ content: String,
                    productId: String? = nil,
                    assocId: String? = nil,
                    orderId: String? = nil,
                    productCode: String? = nil,
                    transactionId: String? = nil,
                    receipt: String? = nil,
                    ext: [String: Any]? = nil) {
        var params: [String: Any] = [:]
        params["userId"] = LoginTl.shared.usrId
        params["content"] = content
        if let productId = productId {
            params["productId"] = productId
        }
        if let assocId = assocId {
            params["assocId"] = assocId
        }
        if let orderId = orderId {
            params["orderId"] = orderId
        }
        if let productCode = productCode {
            params["productCode"] = productCode
        }
        if let transactionId = transactionId {
            params["transactionId"] = transactionId
        }
        if let receipt = receipt {
            params["receipt"] = receipt
        }
        if let ext = ext {
            ext.forEach { (key, value) in
                params[key] = value
            }
        }
        
        NetAPI.IAPAPI.log.reqToJsonHandler(false, parameters: params) { _ in
            print("上传支付埋点成功")
        } failed: { error in
            print("上传支付埋点失败：\(error.localizedDescription)")
        }
    }
    
    /// 支付失败回传
    static func fail(productCode: String,
                     orderId: String? = nil,
                     errorCode: String? = nil) {
        var params: [String: Any] = [:]
        params["platform"] = 2
        params["productCode"] = productCode
        if let orderId = orderId {
            params["orderNo"] = orderId
        }
        if let errorCode = errorCode {
            params["errorCode"] = errorCode
        }
        
        NetAPI.IAPAPI.fail.reqToJsonHandler(false, parameters: params) { _ in
            print("调用支付失败回传接口成功")
        } failed: { error in
            print("调用支付失败回传接口失败：\(error.localizedDescription)")
        }
    }
    
}
