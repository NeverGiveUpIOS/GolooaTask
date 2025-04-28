//
//  ArrayExt.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/8/1.
//

import Foundation


// MARK: - 一、数组 的基本扩展
public extension Array {

    /// 数组新增元素(可转入一个数组)
    /// - Parameter elements: 数组
    mutating func appends(_ elements: [Element]) {
        self.append(contentsOf: elements)
    }
    
    // 数据模型素组去重
    func filterDuplicates<E: Equatable>(_ filter: (Element) -> E) -> [Element] {
        var result = [Element]()
        for value in self {
            let key = filter(value)
            if !result.map({filter($0)}).contains(key) {
                result.append(value)
            }
        }
        return result
    }
    
    func toJSON() -> String? {
        let array = self
        guard JSONSerialization.isValidJSONObject(array) else {
            debugPrint("无法解析出JSONString")
            return ""
        }
        let data : NSData = try! JSONSerialization.data(withJSONObject: array, options: []) as NSData
        let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
        return JSONString! as String
    }
    
    /// 分隔数组
    /// - Parameter condition: condition description
    /// - Returns: description
    func split(where condition: (Element, Element) -> Bool) -> [[Element]] {
        var result: [[Element]] = self.isEmpty ? [] : [[self[0]]]
        for (previous, current) in zip(self, self.dropFirst()) {
            if condition(previous, current) {
                result.append([current])
            } else {
                result[result.endIndex - 1].append(current)
            }
        }
        return result
    }
    
}

public extension Array where Self.Element == String {
    
    /// 数组转字符转（数组的元素是 字符串），如：["1", "2", "3"] 连接器为 - ，那么转化后为 "1-2-3"
    /// - Parameter separator: 连接器
    /// - Returns: 转化后的字符串
    func toStrinig(separator: String = "") -> String {
        return self.joined(separator: separator)
    }
}
