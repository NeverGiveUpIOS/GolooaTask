//
//  BundleExt.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/7/23.
//

import UIKit

extension Bundle: GTCompble {}

public extension GTBas where Base: Bundle {
    
    // MARK: - 获取App命名空间
    static var nameSpace: String {
        guard let nameSp =  Bundle.main.infoDictionary?["CFBundleExecutable"] as? String else { return "" }
        return  nameSp
    }
    
    // MARK: - 获取app的版本号
    static var appVersion: String {
        return (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String) ?? ""
    }
    
    /// 获取app的 Build ID
    static var appBuild: String {
        return (Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String) ?? ""
    }
    
}
