//
//  NetReqTl.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/7/23.
//


import Foundation

// 定义一个网络请求管理类
class NetReqTl {
    
    private let session = URLSession(configuration: ReqHeaders.configuration)
    private let queue = DispatchQueue(label: "ktGoa.com.netReq", qos: .userInitiated, attributes: .concurrent)
    
    // MARK: - GET请求
    func getRequest<T: Codable>(api: NetAPIProtocol, parameters: [String: Any]? = nil, responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        // 构建请求URL
        var urlComponents = URLComponents(string: api.url)!
        
        print("请求返回的Url:\(api.url)")
        print("请求返回的参数:\(parameters ?? [:])")
        print("请求返回的请求头:\(ReqHeaders.headers )")
        
        if let parameters = parameters {
            urlComponents.queryItems = parameters.map { key, value in
                URLQueryItem(name: key, value: "\(value)")
            }
        }
        
        guard let url = urlComponents.url else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // 设置请求头
        for (key, value) in ReqHeaders.headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        session.dataTask(with: request) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                completion(.failure(NSError(domain: "Server Error", code: 0, userInfo: nil)))
                return
            }
            if let headder = httpResponse.allHeaderFields as? [String : Any] {
                var cookie = ""
                if headder.keys.contains("Set-Cookie") {
                    let SESSIONs = String(describing: headder["Set-Cookie"]).components(separatedBy: ";")
                    SESSIONs.forEach { tStr in
                        if tStr.contains("cid=") {
                            cookie = "\(tStr);"
                        }
                        if tStr.contains("rm_ads=") {
                            cookie = "\(tStr);"
                        }
                        if tStr.contains("SESSION=") {
                            cookie = cookie + "\(tStr)"
                        }
                    }
                } // ZjgxNDY4ZWQtMzhhNi00NjA5LTk3NWQtMWYxZDI3OTEwM2Rh
  
                // print("获取cookie:\(cookie)")
                 request.setValue(cookie, forHTTPHeaderField: "Cookie")
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: 0, userInfo: nil)))
                return
            }
            
            
            print("请求返回的数据:\(String(describing: dataToJson(data: data)))")

            do {
                ToastHud.hiddenToastAction()
                let decoder = JSONDecoder()
                // 解码JSON数据为指定的模型对象
                let responseObject = try decoder.decode(T.self, from: data)
                
                // 在主队列中异步调用完成闭包
                DispatchQueue.main.async {
                    completion(.success(responseObject))
                }
            } catch {
                ToastHud.hiddenToastAction()
                completion(.failure(error))
            }
        }.resume()
    }
    
    // MARK: - POST请求
    func postRequest<T: Codable, U: Codable>(api: NetAPIProtocol, parameters: [String: Any]? = nil, body: T, responseType: U.Type, completion: @escaping (Result<U, Error>) -> Void) {
        
        
        print("请求返回的Url:\(api.url)")
        print("请求返回的参数:\(parameters ?? [:])")
        print("请求返回的请求头:\(ReqHeaders.headers )")
        // 构建请求URL
        var urlComponents = URLComponents(string: api.url)!
        
        if let parameters = parameters {
            urlComponents.queryItems = parameters.map { key, value in
                URLQueryItem(name: key, value: "\(value)")
            }
        }
        
        guard let url = urlComponents.url else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // 设置请求头
        for (key, value) in ReqHeaders.headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        do {
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(body)
        } catch {
            completion(.failure(error))
            return
        }
        
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                completion(.failure(NSError(domain: "Server Error", code: 0, userInfo: nil)))
                return
            }
            
            if let headder = httpResponse.allHeaderFields as? [String : Any] {
                print("获取headder:\(headder)")
                var cookie = ""
                if headder.keys.contains("Set-Cookie") {
                    let SESSIONs = String(describing: headder["Set-Cookie"]).components(separatedBy: ";")
                    SESSIONs.forEach { tStr in
                        if tStr.contains("cid=") {
                            cookie = "\(tStr);"
                        }
                        if tStr.contains("rm_ads=") {
                            cookie = "\(tStr);"
                        }
                        if tStr.contains("SESSION=") {
                            cookie = cookie + "\(tStr)"
                        }
                    }
                } // ZjgxNDY4ZWQtMzhhNi00NjA5LTk3NWQtMWYxZDI3OTEwM2Rh
  
                // print("获取cookie:\(cookie)")
                 request.setValue(cookie, forHTTPHeaderField: "Cookie")
            }
                        
            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: 0, userInfo: nil)))
                return
            }
            
            print("请求返回的数据:\(String(describing: dataToJson(data: data)))")
            
            do {
                let decoder = JSONDecoder()
                // 解码JSON数据为指定的模型对象
                let responseObject = try decoder.decode(U.self, from: data)
                
                // 在主队列中异步调用完成闭包
                DispatchQueue.main.async {
                    completion(.success(responseObject))
                }
                ToastHud.hiddenToastAction()
            } catch {
                ToastHud.hiddenToastAction()
                completion(.failure(error))
            }
        }.resume()
    }

}

func dataToJson(data: Data) -> [String: Any]? {
    do {
        let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
        guard let dictionary = jsonObject as? [String: Any] else {
            return nil
        }
        
        return dictionary
    } catch {
        print("Error serializing data to JSON: \(error)")
        return nil
    }
}
