//
//  NetworkHandle.swift
//  Golaa
//
//  Created by chenkaisong on 2024/5/5.
//

import UIKit

extension ReqAPIProtocol {
    
    /// 返回数据模型
    /// - Parameters:
    ///   - parameters:  parameters
    ///   - type: modelType
    ///   - success: success
    ///   - failed: failed
    func reqToModelHandler<T: JsonModelProtocol>(_ isLoading: Bool =  true,
                                                 parameters: [String: Any]?,
                                                 model type: T.Type,
                                                 success: ReqSuccessMClosure<T>?,
                                                 failed: ReqFailedClosure?) {
        self.fetch(isLoading, parameters: parameters) { JSON in
            guard let json = JSON as? [String: Any], let data = json["data"] as? [String: Any] else {
                success?(T(), JSON as? [String: Any] ?? [String: Any]())
                return
            }
            
            if let jsonModel: T = T.deserialize(from: data) {
                success?(jsonModel, json)
            }
            
        } failed: { error in
            failed?(error)
        }
    }
    
    /// 返回json字典数据
    /// - Parameters:
    ///   - parameters: parameters description
    ///   - success: success description
    ///   - failed: failed description
    func reqToJsonHandler(_ isLoading: Bool = true,
                          parameters: [String: Any]?,
                          success: ReqSuccessDJlosure?,
                          failed: ReqFailedClosure?) {
        self.fetch(isLoading, parameters: parameters) { JSON in
            let json = JSON as? [String: Any] ?? [:]
            let data = json["data"] as? [String: Any] ?? [:]
            success?(ReqOriginalData(data: data, json: json))
        } failed: { error in
            failed?(error)
        }
    }
    
    /// 返回空数据
    /// - Parameters:
    ///   - parameters: parameters description
    ///   - success: success description
    ///   - failed: failed description
    func reqToVoidHandler(_ isLoading: Bool = true,
                          parameters: [String: Any]?,
                          success: CallBackVoidBlock?,
                          failed: ReqFailedClosure?) {
        self.fetch(isLoading, parameters: parameters) { _ in
            success?()
        } failed: { error in
            failed?(error)
        }
    }
    
    /// 返回数组模型
    /// - Parameters:
    ///   - parameters: parameters description
    ///   - type: type description
    ///   - listKey: listKey description
    ///   - success: success description
    ///   - failed: failed description
    func reqToListHandler<T: JsonModelProtocol>(_ isLoading: Bool = true,
                                                parameters: [String: Any]?,
                                                model type: T.Type,
                                                listKey: String = "list",
                                                success: ReqSuccessLClosure<[T]>?,
                                                failed: ReqFailedClosure?) {
        self.fetch(isLoading, parameters: parameters) { JSON in

            if let json = JSON as? [String: Any], let data = json["data"] as? [String: Any] {
                if let dataList = JSONDeserializer<T>.deserializeModelArrayFrom(json: data.toJSON(), designatedPath: listKey) {
                    success?(dataList.compactMap { $0 }, json)
                }
            } else {
                if let json = JSON as? [String: Any], let data = json["data"] as? [Any] {
                    if let dataList = JSONDeserializer<T>.deserializeModelArrayFrom(array: data) {
                        success?(dataList.compactMap { $0 }, json)
                    }
                } else {
                    success?([], (JSON as? [String: Any]) ?? [:])
                }
            }
     
        } failed: { error in
            failed?(error)
        }
    }
}

/// Extension method
extension ReqAPIProtocol {
    
    /// 根据`HSAPIProtocol`进行一个网络请求
    private func fetch(_ isLoading: Bool = true,
                       parameters: [String: Any]? = nil,
                       success: ReqSuccJsonClosure?,
                       failed: ReqFailedClosure?) {
        if isLoading {
            ToastHud.showToastAction()
        }
        let task = reqMagger.fetch(isLoading, api: self, parameters: parameters)
        if let s = success {
            task.success(s)
        }
        if let f = failed {
            task.failed(f)
        }
    }

}
