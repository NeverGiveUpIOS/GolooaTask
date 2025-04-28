//
//  NetworkRequest.swift
//  Golaa
//
//  Created by chenkaisong on 2024/5/5.
//

class NetworkRequest: Equatable {
    
    var request: Alamofire.Request?
    var description: String?
    
    private var successHandler: ReqSuccJsonClosure?
    private var failedHandler: ReqFailedClosure?
    private var progressHandler: ReqProgressHandler?
    
    // MARK: - Handler
    func handleResponse(_ isLoading: Bool = true, response: AFDataResponse<Any>) {
        // 服务器的500 跟系统的 500一样，所以，先解析处理，是不是服务器的500先处理
        if let data = response.data {
            do {
                if let info = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    responsData(info, isLoading: isLoading)
                    return
                }
            } catch {
                debugPrint(error)
            }
        }
        
        switch response.result {
        case .failure(let error):
            if let closure = failedHandler {
                var failText = ""
                if reqMagger.networkStatus == .notReachable {
                     failText = "networkException".globalLocalizable()
                } else {
                    failText = error.localizedDescription
                }
                let hwe = NetworkError(code: error.responseCode ?? -1, status: "", desc: failText)
                closure(hwe)
                debugPrint("错误返回code=========:\(String(describing: error.responseCode))\n 错误描述=========:\(failText)")
            }
        case .success(let JSON):
            responsData(JSON, isLoading: isLoading)
        }
        clearReference()
    }
    
    private func responsData(_ json: Any, isLoading: Bool = true) {
        
        guard let dict = json as? [String: Any] else {
            if let closure = failedHandler { // 解析失败
                let hwe = NetworkError(code: -1, status: "", desc: "")
                closure(hwe)
            }
            return
        }
        
        debugPrint("请求成功结果url: \(request?.request?.url?.absoluteString ?? "")\n请求成功结果json: \(dict)")

        guard let status = dict["status"] as? String,
              let code = dict["code"] as? Int  else {
            if let closure = failedHandler { // 解析失败
                
                var extras: Any?
                var callbacks: String? = ""
                var msg = ""
                
                if let extra = dict["extra"] {
                    extras = extra
                }
                
                if let callback = dict["callback"] as? String {
                    callbacks = callback
                }
                
                if let m = dict["msg"] as? String {
                    msg = m
                }
                
                let hwe = NetworkError(code: -1, status: "", desc: msg, extra: extras, callback: callbacks)
                closure(hwe)
            }
            return
        }
        if  status == "OK" { // 表示请求成功
            if isLoading {
                ToastHud.hiddenIndicatorToastAction()
                ToastHud.hiddenToastAction()
            }
            if let closure = successHandler {
                closure(json)
            }
        } else { // 请求失败
            if let closure = failedHandler {
                
                var extras: Any?
                var callbacks: String? = ""
                var msg = ""

                if let extra = dict["extra"] {
                    extras = extra
                }
                
                if let callback = dict["callback"] as? String {
                    callbacks = callback
                }
                
                if let m = dict["msg"] as? String {
                    msg = m
                }
                
                let hwe = NetworkError(code: code, status: status, desc: msg, extra: extras, callback: callbacks)
                closure(hwe)
            }
        }
    }
    
    /// Processing request progress (Only when uploading files)
    func handleProgress(progress: Foundation.Progress) {
        if let closure = progressHandler {
            closure(progress)
        }
    }
    
    // MARK: - Callback
    
    @discardableResult
    func success(_ closure: @escaping ReqSuccJsonClosure) -> Self {
        successHandler = closure
        return self
    }
    
    @discardableResult
    func failed(_ closure: @escaping ReqFailedClosure) -> Self {
        failedHandler = closure
        return self
    }
    
    @discardableResult
    func progress(closure: @escaping ReqProgressHandler) -> Self {
        progressHandler = closure
        return self
    }
    
    func cancel() {
        request?.cancel()
    }
    
    /// Free memory
    func clearReference() {
        successHandler = nil
        failedHandler = nil
        progressHandler = nil
    }
}

extension NetworkRequest {
    public static func == (lhs: NetworkRequest, rhs: NetworkRequest) -> Bool {
        return lhs.request?.id == rhs.request?.id
    }
}
