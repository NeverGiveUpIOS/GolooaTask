//
//  IAPHelper.swift
//  Golaa
//
//  Created by duke on 2024/5/7.
//

import UIKit
import StoreKit

enum IAPPayType: Int {
    case create = 1 // 创建任务支付保证金(暂时用不上)
    case makeup = 2 // 补交保证金
    case coin = 3 // 金币充值
}

enum IAPaySource: String {
    case none = ""
    case deposit = "pay_deposit_back_click"
    case coin = "recharge_coin_back_click"
    case halfCoin = "half_recharge_coin_back_click"
}


class IAPHelper: NSObject {
    static let shared = IAPHelper()
    private var source: IAPaySource = .none
    
    func setup() {
        SKPaymentQueue.default().add(self)
    }
    
    func pay(productId: String,
             productCode: String,
             price: String? = nil,
             type: IAPPayType = .coin,
             source: IAPaySource,
             ext: [String: Any]? = nil,
             successBlock: (() -> Void)?,
             failureBlock: (() -> Void)?) {
        self.source = source
        var params: [String: Any] = [:]
        params["productId"] = productId
        params["platform"] = 4
        params["price"] = price
        params["payType"] = type.rawValue
        params["adType"] = "INTER_AD"
        params["idfv"] = ""
        params["idfa"] = ""
        params["adid"] = ""
        if let price = price {
            params["price"] = price
        }
        if let ext = ext {
            ext.forEach { (key, value) in
                params[key] = value
            }
        }
        
        IAPTracker.log("苹果支付日志 ======== 创建订单", productId: productId, productCode: productCode)
        
        ToastHud.showIndicatorToastAction(message: "paymenting".globalLocalizable())
        
        NetAPI.IAPAPI.createAPI.reqToJsonHandler(false, parameters: params) { [weak self] info in
            guard let self = self else { return }
            if let orderId = info.data["orderNo"] as? String, !orderId.isEmpty {
                IAPTracker.log("苹果支付日志 ======== 准备调用内购", productId: current?.productId, orderId: current?.orderId)
                self._pay(productId: productId, productCode: productCode, orderId: orderId, successBlock: successBlock, failureBlock: failureBlock)
            } else {
                ToastHud.hiddenToastAction()
                ToastHud.hiddenIndicatorToastAction()
                ToastHud.showToastAction(message: "paymentFailed".globalLocalizable())
                IAPTracker.fail(productCode: productCode, errorCode: "创建订单失败")
                IAPTracker.log("苹果支付日志 ======== 创建订单失败", productId: productId, productCode: productCode)
                failureBlock?()
                self.source = .none
            }
        } failed: { error in
            ToastHud.hiddenToastAction()
            ToastHud.hiddenIndicatorToastAction()
            ToastHud.showToastAction(message: "paymentFailed".globalLocalizable())
            IAPTracker.log("苹果支付日志 ======== 创建订单请求失败 \(error.localizedDescription)", productId: productId, productCode: productCode)
            failureBlock?()
            self.source = .none
        }
    }
    
    private var current: IAPCacheModel?
    private var successBlock: (() -> Void)?
    private var failureBlock: (() -> Void)?
    func _pay(productId: String,
              productCode: String,
              orderId: String,
              successBlock: (() -> Void)?,
              failureBlock: (() -> Void)?) {
        if SKPaymentQueue.canMakePayments() {
            let current = IAPCacheModel()
            current.productId = productId
            current.productCode = productCode
            current.orderId = orderId
            self.current = current
            self.successBlock = successBlock
            self.failureBlock = failureBlock
            // 保存订单
            IAPCache.shared.saveCache(productId: productId, productCode: productCode, orderId: orderId)
            // 请求内购商品
            let request = SKProductsRequest(productIdentifiers: [productCode])
            request.delegate = self
            request.start()
            IAPTracker.log("苹果支付日志 ======== 请求内购商品", productId: current.productId, orderId: current.orderId)
        } else {
            ToastHud.hiddenToastAction()
            ToastHud.hiddenIndicatorToastAction()
            ToastHud.showToastAction(message: "paymentFailed".globalLocalizable())
            IAPTracker.log("苹果支付日志 ======== 不允许内购", productId: productId, orderId: orderId)
            failureBlock?()
            source = .none
        }
    }
    
    /// 刷新凭证
    private func refreshReceipt() {
        let request = SKReceiptRefreshRequest()
        request.delegate = self
        request.start()
        IAPTracker.log("苹果支付日志 ======== 苹果回调-购买成功 重新获取凭证", productId: current?.productId, orderId: current?.orderId, transactionId: current?.transactionId)
        debugPrint("苹果回调-购买成功 重新获取凭证-刷新凭证, transactionId = %@, orderId = %@", current?.transactionId ?? "", current?.orderId ?? "")
    }
    
    /// 获取凭证
    private func getReceipt() -> String? {
        if let receiptURL = Bundle.main.appStoreReceiptURL {
            let receiptData = NSData(contentsOf: receiptURL)
            let receipt = receiptData?.base64EncodedString()
            return receipt
        }
        return nil
    }
}

extension IAPHelper: SKProductsRequestDelegate, SKPaymentTransactionObserver, SKRequestDelegate {
    
    func requestDidFinish(_ request: SKRequest) {
        if request.isKind(of: SKReceiptRefreshRequest.self) {
            current?.receipt = getReceipt() ?? ""
        }
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async {
            let products = response.products
            guard products.count > 0 else {
                ToastHud.hiddenToastAction()
                ToastHud.hiddenIndicatorToastAction()
                ToastHud.showToastAction(message: "productNotExist".globalLocalizable())
                IAPTracker.log("苹果支付日志 ======== 内购列表为空", productId: self.current?.productId, orderId: self.current?.orderId)
                self.failureBlock?()
                self.source = .none
                return
            }
            
            if let product = products.first(where: { $0.productIdentifier == self.current?.productCode }) {
                IAPTracker.log("苹果支付日志 ======== 加载待售商品成功", productId: self.current?.productId, orderId: self.current?.orderId)
                let payment = SKMutablePayment(product: product)
                // 透传参数
                payment.applicationUsername = self.current?.orderId
                payment.quantity = 1
                SKPaymentQueue.default().add(payment)
            } else {
                ToastHud.hiddenToastAction()
                ToastHud.hiddenIndicatorToastAction()
                ToastHud.showToastAction(message: "productNotExist".globalLocalizable())
                IAPTracker.log("苹果支付日志 ======== 商品不存在", productId: self.current?.productId, orderId: self.current?.orderId)
                self.failureBlock?()
                self.source = .none
            }
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            IAPTracker.log("苹果支付日志 ======== 苹果回调-恢复", orderId: "orderId", transactionId: "\(transaction.transactionState)")

            switch transaction.transactionState {
            case .purchased:
                purchasedToTransaction(transaction)
            case .purchasing:
                print("正在购买。。。。。")
            case .restored:
                // 透传参数
                let orderId = transaction.payment.applicationUsername
                let transactionId = transaction.transactionIdentifier
                IAPTracker.log("苹果支付日志 ======== 苹果回调-恢复", orderId: orderId, transactionId: transactionId)
                IAPCache.shared.clearCache(orderId: orderId, transactionId: transactionId)
                SKPaymentQueue.default().finishTransaction(transaction)
            case .failed:
                var isCancel = false
                if let error = transaction.error as NSError?, error.code == SKError.Code.paymentCancelled.rawValue {
                    isCancel = true
                    if source != .none {
                        FlyerLibHelper.log(source.rawValue)
                    }
                }
                failedToTransaction(transaction, isCancel: isCancel)
                SKPaymentQueue.default().finishTransaction(transaction)
            default:
                break
            }
        }
    }
}

extension IAPHelper {
    
    private func purchasedToTransaction(_ transaction: SKPaymentTransaction) {
        
        let transactionId = transaction.transactionIdentifier
        let receipt = getReceipt()
        current?.transactionId = transactionId ?? ""
        current?.receipt = receipt ?? ""
        
        IAPTracker.log("苹果支付日志 ======== 苹果回调-购买成功 准备等待服务器验证", productId: current?.productId, orderId: current?.orderId, transactionId: transactionId, receipt: current?.receipt)
        
        if let current = current, current.receipt.isEmpty {
            refreshReceipt()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                // 更新 transactionId, receipt
                IAPCache.shared.saveCache(productId: current.productId, productCode: current.productCode, orderId: current.orderId, transactionId: transactionId, receipt: current.receipt)
                // 校验订单
                self.validateToTransaction(transaction)
            }
        } else {
            if let current = current {
                // 更新 transactionId, receipt
                IAPCache.shared.saveCache(productId: current.productId, productCode: current.productCode, orderId: current.orderId, transactionId: transactionId, receipt: current.receipt)
            }
            // 校验订单
            self.validateToTransaction(transaction)
        }
    }
    
    private func validateToTransaction(_ transaction: SKPaymentTransaction) {
        if let current = current, !current.orderId.isEmpty {
            // 正常购买交易订单
            print("正常逻辑购买的产品，正常去验证订单, orderId = \(current.orderId)")
            
            IAPTracker.log("苹果支付日志 ======== 正常逻辑购买的产品，准备验证订单", productId: current.productId, orderId: current.productId, transactionId: current.transactionId, receipt: current.receipt)
            
            validate(productId: current.productId, productCode: current.productCode, orderId: current.orderId, transactionId: current.transactionId, receipt: current.receipt, transaction: transaction)
        } else {
            // 透传参数
            let orderId = transaction.payment.applicationUsername
            let transactionId = transaction.transactionIdentifier
            let receipt = getReceipt()

            // 历史订单交易订单
            print("进入历史订单校验逻辑， 透传参数 orderId = \(orderId ?? "") transactionId = \(transactionId ?? "")")
            
            IAPTracker.log("苹果支付日志 ======== 准备进入历史订单，准备验证订单", orderId: orderId, transactionId: transactionId)
            
            if let cache = IAPCache.shared.getCache(orderId: orderId, transactionId: transactionId) {
                IAPTracker.log("苹果支付日志 ======== 拿到历史订单缓存，准备验证订单",
                               productId: cache.productId, orderId: orderId, productCode: cache.productCode, transactionId: transactionId, receipt: receipt)
                validate(productId: cache.productId, productCode: cache.productCode, orderId: cache.orderId, transactionId: transactionId ?? cache.transactionId, receipt: receipt ?? cache.receipt, transaction: transaction)
            } else {
                ToastHud.hiddenToastAction()
                ToastHud.hiddenIndicatorToastAction()
//                ToastHud.showToastAction(message: "paymentFailed".globalLocalizable())
                IAPTracker.log("苹果支付日志 ======== 未拿到历史订单缓存，验证订单失败", orderId: orderId, transactionId: transactionId)
                failureBlock?()
                source = .none
            }
        }
    }
    
    private func validate(
        productId: String,
        productCode: String,
        orderId: String,
        transactionId: String,
        receipt: String,
        transaction: SKPaymentTransaction) {
            var params: [String: Any] = [:]
            params["productCode"] = productCode
            params["platform"] = 4
            params["orderNo"] = orderId
            params["tradeNo"] = transactionId
            params["data"] = receipt
            params["adType"] = "INTER_AD"
            params["idfv"] = ""
            params["idfa"] = ""
            params["adid"] = ""
            NetAPI.IAPAPI.validate.reqToJsonHandler(false, parameters: params) { [weak self] _ in
                guard let self = self else { return }
                
                SKPaymentQueue.default().finishTransaction(transaction)
                
                debugPrint("订单验证成功... 支付成功")
                
                ToastHud.hiddenToastAction()
                ToastHud.hiddenIndicatorToastAction()
                ToastHud.showToastAction(message: "paymentSuccessful".globalLocalizable())
                
                IAPTracker.log("苹果支付日志 ======== 订单验证成功, 支付成功", productId: productId, orderId: orderId, transactionId: transactionId, receipt: receipt)
                IAPCache.shared.clearCache(orderId: orderId, transactionId: transactionId)
                
                LoginTl.shared.getCurUserInfo { [weak self] _ in
                    self?.successBlock?()
                    NotificationCenter.default.post(name: .paySuccessful, object: nil)
                }
                
                self.current = nil
                self.source = .none
            } failed: { [weak self] error in
                guard let self else { return }
                
                print("订单验证失败... error: \(error.localizedDescription)")
                
                ToastHud.hiddenToastAction()
                ToastHud.hiddenIndicatorToastAction()
                ToastHud.showToastAction(message: "paymentFailed".globalLocalizable())
                
                if error.status == "statusChanged" { // 该订单状态已变更，请刷新后确认！
                    IAPTracker.log("苹果支付日志 ======== 订单验证失败: 该订单状态已变更，请刷新后确认！，不缓存并移除队列", productId: productId, orderId: orderId, transactionId: transactionId, receipt: receipt)
                    // 结束交易
                    SKPaymentQueue.default().finishTransaction(transaction)
                    IAPCache.shared.clearCache(orderId: orderId, transactionId: transactionId)
                } else if error.status == "duplicate" { // 重复订单
                    IAPTracker.log("苹果支付日志 ======== 订单验证失败: duplicate 重复订单，不缓存并移除队列", productId: productId, orderId: orderId, transactionId: transactionId, receipt: receipt)
                    // 结束交易
                    SKPaymentQueue.default().finishTransaction(transaction)
                    IAPCache.shared.clearCache(orderId: orderId, transactionId: transactionId)
                } else {
                    IAPTracker.log("苹果支付日志 ======== 订单验证失败: \(error.localizedDescription)", productId: productId, orderId: orderId, transactionId: transactionId, receipt: receipt)
                }
                
                self.failureBlock?()
                self.source = .none
                self.current = nil
            }
        }
    
    private func failedToTransaction(_ transaction: SKPaymentTransaction, isCancel: Bool) {
        // 透传参数
        let orderId = transaction.payment.applicationUsername
        let transactionId = transaction.transactionIdentifier
        let productCode = transaction.payment.productIdentifier
        let errorCode = transaction.error?.localizedDescription
        
        print("支付错误 \(errorCode ?? "")")
        ToastHud.hiddenToastAction()
        ToastHud.hiddenIndicatorToastAction()
        ToastHud.showToastAction(message: isCancel ? "cancelPay".globalLocalizable() : "paymentFailed".globalLocalizable())
        
        IAPTracker.fail(productCode: productCode, orderId: orderId, errorCode: errorCode)
        IAPTracker.log("苹果支付日志 ======== 苹果回调-支付失败 error: \(errorCode ?? "")", orderId: orderId, productCode: productCode, transactionId: transactionId)
        IAPCache.shared.clearCache(orderId: orderId, transactionId: transactionId)
        
        failureBlock?()
        source = .none
        current = nil
    }
}
