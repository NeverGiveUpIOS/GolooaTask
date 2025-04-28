//
//  UserDefaultsExt.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/7/23.
//

import UIKit

extension UserDefaults: GTCompble {}

public extension GTBas where Base: UserDefaults {
  
    // MARK: - 存储数据
    @discardableResult
    static func saveValueForKey(value: Any?, key: String?) -> Bool {
        guard value != nil, key != nil else {
            return false
        }
        Base.standard.set(value, forKey: key!)
        Base.standard.synchronize()
        return true
    }
    
    // MARK: - 取值
    static func getValueForKey(key: String?) -> Any? {
        guard key != nil, let result = Base.standard.value(forKey: key!) else {
            return nil
        }
        return result
    }
    
    // MARK: - 删除
    static func remove(_ key: String) {
        guard let _ = Base.standard.value(forKey: key) else {
            return
        }
        Base.standard.removeObject(forKey: key)
    }
    
    // MARK: - 删除所有
    static func removeAllKeyValue() {
        if let bundleID = Bundle.main.bundleIdentifier {
            Base.standard.removePersistentDomain(forName: bundleID)
            Base.standard.synchronize()
        }
    }
}

public extension GTBas where Base: UserDefaults {
    
    // MARK: - 存储模型
    static func saveModelForKey<T: Decodable & Encodable>(_ object: T, forKey key: String) {
        let encoder = JSONEncoder()
        guard let encoded = try? encoder.encode(object) else {
            return
        }
        Base.standard.set(encoded, forKey: key)
        Base.standard.synchronize()
    }
    
    // MARK: - 取出模型
    static func getModelForKey<T: Decodable & Encodable>(_ type: T.Type, forKey key: String) -> T? {
        
        guard let data = Base.standard.data(forKey: key) else {
            return nil
        }
        let decoder = JSONDecoder()
        guard let object = try? decoder.decode(type, from: data) else {
            return nil
        }
        return object
    }
    
    //MARK: - 保存模型数组
    @discardableResult
    static func setModelArrayForKey<T: Decodable & Encodable>(modelArrry object: [T], key: String) -> Bool {
        do {
            let data = try JSONEncoder().encode(object)
            Base.standard.set(data, forKey: key)
            Base.standard.synchronize()
            return true
        } catch {
           print(error)
        }
        return false
    }
    
    //MARK: 获取模型数组
    static func getModelArrayForKey<T: Decodable & Encodable>(forKey key : String) -> [T] {
        guard let data = Base.standard.data(forKey: key) else { return [] }
        do {
            return try JSONDecoder().decode([T].self, from: data)
        } catch {
            print(error)
        }
        return []
    }
}
