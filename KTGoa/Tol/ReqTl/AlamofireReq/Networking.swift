//
//  Networking.swift
//  Golaa
//
//  Created by chenkaisong on 2024/5/5.
//

import UIKit

let reqMagger = Networking.shared

class Networking {
    
    static let shared = Networking()
    
    private(set) var taskQueue = [NetworkRequest]()
    var sessionManager: Alamofire.Session!
    var reachability: NetworkReachabilityManager?
    var networkStatus: ReqReachabilityStatus = .unknown
    // 网络监听回调
    // let networeStatusRelay = PublishSubject<ReqReachabilityStatus>()
    
    private func getHeaders() -> HTTPHeaders {
        var headers = HTTPHeaders()
        headers.add(HTTPHeader(name: "App-Id", value: HeaderAppId))
        headers.add(HTTPHeader(name: "accept", value: "application/json"))
        headers.add(HTTPHeader(name: "Accept-Language", value: Curlanguage))
        headers.add(.defaultAcceptEncoding)
        headers.add(.defaultUserAgent)
        return headers
    }
    
    private init() {
        let config = URLSessionConfiguration.af.default
        // Timeout interval
        config.timeoutIntervalForRequest = 60
        // Timeout interval
        config.timeoutIntervalForResource = 60
        sessionManager = Alamofire.Session(configuration: config)
    }
    
    func request(_ isLoading: Bool = true, url: String,
                 method: HTTPMethod = .get,
                 parameters: [String: Any]?,
                 encoding: ParameterEncoding = URLEncoding.default) -> NetworkRequest {
        
        let task = NetworkRequest()
        // 检查网络状态
        startMonitoring()
        
        let headers = getHeaders()
        
        //        debugPrint("请求地址：\(url)\n发送参数：\(parameters ?? [:])\n请求头：\(headers)\n请求方法：\(method)")
        debugPrint("请求地址：\(url)\n发送参数：\(parameters ?? [:]) \n当前语言: \(Curlanguage)")
        
        task.request = sessionManager.request(url,
                                              method: method,
                                              parameters: parameters,
                                              encoding: method == .post ? URLEncoding.httpBody:encoding,
                                              headers: headers).validate().responseJSON { [weak self] response in
            
            task.handleResponse(isLoading, response: response)
            
            if let index = self?.taskQueue.firstIndex(of: task) {
                self?.taskQueue.remove(at: index)
            }
        }
        taskQueue.append(task)
        return task
    }
    
    func cancelAllRequests(completingOnQueue queue: DispatchQueue = .main, completion: (() -> Void)? = nil) {
        sessionManager.cancelAllRequests(completingOnQueue: queue, completion: completion)
    }
    
}

extension Networking {
    
    @discardableResult
    func fetch(_ isLoading: Bool = true, api: ReqAPIProtocol,
               parameters: [String: Any]? = nil) -> NetworkRequest {
        let method = methodWith(api.method)
        let task = request(isLoading, url: api.url, method: method, parameters: parameters)
        task.description = api.description
        return task
    }
    
    ///  request method
    private func methodWith(_ m: ReqHTTPMethod) -> Alamofire.HTTPMethod {
        switch m {
        case .get: return .get
        case .post: return .post
        }
    }
    
}

extension Networking {
    
    @discardableResult
    func POST(url: String, parameters: [String: Any]? = nil, headers: [String: String]? = nil) -> NetworkRequest {
        request(url: url, method: .post, parameters: parameters)
    }
    
    @discardableResult
    func GET(url: String, parameters: [String: Any]? = nil) -> NetworkRequest {
        request(url: url, method: .get, parameters: parameters)
    }
}

/// Detect network status 监听网络状态
extension Networking {
    func startMonitoring() {
        
        if reachability == nil {
            reachability = NetworkReachabilityManager.default
        }
        
        reachability?.startListening(onQueue: .main, onUpdatePerforming: { [unowned self] (status) in
            switch status {
            case .notReachable:
                self.networkStatus = .notReachable
            case .unknown:
                self.networkStatus = .unknown
            case .reachable(.ethernetOrWiFi):
                self.networkStatus = .ethernetOrWiFi
            case .reachable(.cellular):
                self.networkStatus = .cellular
            }
            postNotiObserver("NetworkStatusChange", status)
        })
    }
    
    func stopMonitoring() {
        guard reachability != nil else { return }
        reachability?.stopListening()
    }
}
