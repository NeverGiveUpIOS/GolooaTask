//
//  IAPCache.swift
//  Golaa
//
//  Created by duke on 2024/5/7.
//

import UIKit
import KeychainSwift

class IAPCacheModel: Decodable, Encodable, HandyJSON {
    required init() {}

    var orderId: String = ""
    var productId: String = ""
    var productCode: String = ""
    var transactionId: String = ""
    var receipt: String = ""
    
    func encode(with coder: NSCoder) {
        coder.encode(orderId, forKey: "orderId")
        coder.encode(productId, forKey: "productId")
        coder.encode(productId, forKey: "productCode")
        coder.encode(transactionId, forKey: "transactionId")
        coder.encode(receipt, forKey: "receipt")
    }
    
    required init?(coder: NSCoder) {
        self.orderId = coder.decodeObject(forKey: "orderId") as? String ?? ""
        self.productId = coder.decodeObject(forKey: "productId") as? String ?? ""
        self.productCode = coder.decodeObject(forKey: "productCode") as? String ?? ""
        self.transactionId = coder.decodeObject(forKey: "transactionId") as? String ?? ""
        self.receipt = coder.decodeObject(forKey: "receipt") as? String ?? ""
    }
}

class IAPCache: NSObject {
    static let shared = IAPCache()
    
    private lazy var keyChain = KeychainSwift(keyPrefix: "golaa-iap")
    
    var key: String {
        return LoginTl.shared.usrId + "_pay"
    }
    
    func saveCache(productId: String,
                   productCode: String,
                   orderId: String,
                   transactionId: String? = nil,
                   receipt: String? = nil) {
        var list = [IAPCacheModel].deserialize(from: keyChain.get(key), designatedPath: nil) as? [IAPCacheModel] ?? []
        if !list.isEmpty {
            if let transactionId = transactionId { // 有 transactionId
                if let index = list.lastIndex(where: { $0.orderId == orderId }) {
                    list[index].productId = productId
                    list[index].productCode = productCode
                    list[index].transactionId = transactionId
                    if let receipt = receipt {
                        list[index].receipt = receipt
                    }
                    let data = list.toJSONString() ?? ""
                    keyChain.set(data, forKey: key)
                } else { // 没找到，添加
                    let model = IAPCacheModel()
                    model.productId = productId
                    model.productCode = productCode
                    model.orderId = orderId
                    model.transactionId = transactionId
                    if let receipt = receipt {
                        model.receipt = receipt
                    }
                    list.append(model)
                    let data = list.toJSONString() ?? ""
                    keyChain.set(data, forKey: key)
                }
            } else {
                // 刚生成订单信息, 还没有 transactionId
                if let index = list.lastIndex(where: { $0.orderId == orderId }) {
                    list[index].productId = productId
                    list[index].productCode = productCode
                    if let receipt = receipt {
                        list[index].receipt = receipt
                    }
                    let data = list.toJSONString() ?? ""
                    keyChain.set(data, forKey: key)
                } else {
                    let model = IAPCacheModel()
                    model.productId = productId
                    model.productCode = productCode
                    model.orderId = orderId
                    if let receipt = receipt {
                        model.receipt = receipt
                    }
                    list.append(model)
                    let data = list.toJSONString() ?? ""
                    keyChain.set(data, forKey: key)
                }
            }
        } else {
            // 直接保存
            var list: [IAPCacheModel] = []
            let model = IAPCacheModel()
            model.productId = productId
            model.productCode = productCode
            model.orderId = orderId
            if let transactionId = transactionId {
                model.transactionId = transactionId
            }
            if let receipt = receipt {
                model.receipt = receipt
            }
            list.append(model)
            let data = list.toJSONString() ?? ""
            keyChain.set(data, forKey: key)
        }
    }
    
    func getCache(orderId: String?, transactionId: String?) -> IAPCacheModel? {
        let list = [IAPCacheModel].deserialize(from: keyChain.get(key), designatedPath: nil) as? [IAPCacheModel] ?? []

        guard !list.isEmpty else {
            return nil
        }
        
        if let orderId = orderId {
            if let model = list.last(where: { $0.orderId == orderId }) {
                if model.transactionId.isEmpty, let transactionId = transactionId {
                    // 这个是订单的时候缓存了，但是支付过程中退出了，所以 transactionId 为空, 更新下 transactionId
                    model.transactionId = transactionId
                    let data = list.toJSONString() ?? ""
                    keyChain.set(data, forKey: key)
                }
                return model
            }
        }
        
        if let transactionId = transactionId {
            if let model = list.last(where: { $0.transactionId == transactionId }) {
                if model.orderId.isEmpty, let orderId = orderId {
                    // 这个是订单的时候缓存了，但是没有保存上 orderId, 更新 orderId
                    model.orderId = orderId
                    let data = list.toJSONString() ?? ""
                    keyChain.set(data, forKey: key)
                }
                return model
            }
        }
        
        // 都没有(没有订单号且没有transactionId, 场景：APP支付成功后，闪退此时还没来得及缓存transactionId)
        // - 取数组最后一个
        return list.last
    }
    
    func clearCache(orderId: String?, transactionId: String?) {
        var list = [IAPCacheModel].deserialize(from: keyChain.get(key), designatedPath: nil) as? [IAPCacheModel] ?? []

        guard !list.isEmpty else {
            return
        }
        
        if let orderId = orderId, let index = list.lastIndex(where: { $0.orderId == orderId }) {
            list.remove(at: index)
            let data = list.toJSONString() ?? ""
            keyChain.set(data, forKey: key)
        }
        
        if let transactionId = transactionId, let index = list.lastIndex(where: { $0.transactionId == transactionId }) {
            list.remove(at: index)
            let data = list.toJSONString() ?? ""
            keyChain.set(data, forKey: key)
        }
    }
}
