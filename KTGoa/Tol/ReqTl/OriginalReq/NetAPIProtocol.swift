//
//  NetAPIProtocol.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/7/24.
//

protocol NetAPIProtocol {
    var url: String { get }
    var description: String { get }
    var method: NetReqMethod { get }
}

struct ReqAPIItem: NetAPIProtocol {
    public var url: String { NetBasAPI.basUrl + urlPath }  // 域名 + path
    public let description: String // 接口名称描述
    public var method: NetReqMethod
    
    private let urlPath: String  // URL的path
    
    init(_ path: String, des: String, m: NetReqMethod = .get) {
        urlPath = path
        description = des
        method = m
    }
    
    init(_ path: String, m: NetReqMethod) {
        self.init(path, des: "", m: m)
    }
}

extension NetAPIProtocol {
    
    func getRequest<T: Codable>(_ isLoading: Bool =  true,
               parameters: [String: Any]? = nil,
               responseType: T.Type,
               completion: @escaping (Result<T, Error>) -> Void) {
        
        if isLoading {
            ToastHud.showToastAction()
        }
        
        reqManager.getRequest(api: self, parameters: parameters, responseType: responseType) { result in
            
            ToastHud.hiddenToastAction()
            
            switch result {
            case .success(let user):
                print("get请求成功，success: \(user)")
                completion(.success(user))
            case .failure(let error):
                print("get请求失败，Error: \(error)")
                
                ToastHud.showToastAction(message: error.localizedDescription)
                completion(.failure(error));
            }
        }
    }
    
    func postRequest<T: Codable, U: Codable>(_ isLoading: Bool =  true,
                                             parameters: [String: Any]? = nil,
                                             body: T,
                                             responseType: U.Type,
                                             completion: @escaping (Result<U, Error>) -> Void) {
        
        if isLoading {
            ToastHud.showToastAction()
        }

        reqManager.postRequest(api: self, parameters: parameters, body: body, responseType: responseType) { result in
            
            ToastHud.hiddenToastAction()
            
            switch result {
            case .success(let user):
                completion(.success(user))
            case .failure(let error):
                print("POST请求失败，Error: \(error)")
                ToastHud.showToastAction(message: error.localizedDescription)
                completion(.failure(error));
            }
        }
    }
    
}
