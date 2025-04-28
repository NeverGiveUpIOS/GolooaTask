//
//  GlobalMethod.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/8/1.
//

import Foundation

// 自定义 debugPrint 函数
func debugPrint(_ message: Any, file: String = #file, line: Int = #line) {
    #if DEBUG
    let fileName = (file as NSString).lastPathComponent
    Swift.print("\(fileName):\(line) - \(message)")
    #endif
}

/// 发送通知
public func postNotiObserver(_ name: String, _ obiect: Any? = nil, _ userInfo: [String: Any]? = [:]) {
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: name), object: obiect, userInfo: userInfo)
}

/// 注册通知
public func addNotiObserver(_ observer: Any, _ selector: Selector, _ name: String, _ obiect: Any? = nil) {
    NotificationCenter.default.addObserver(observer, selector: selector, name: NSNotification.Name(rawValue: name), object: obiect)
}

/// 删除通知
public func removeNotiObserver(_ observer: Any) {
    NotificationCenter.default.removeObserver(observer)
}

/// 删除通知
public func removeNotiObserverWithName(_ observer: Any, _ name: String, _ obiect: Any? = nil ) {
    NotificationCenter.default.removeObserver(observer, name: NSNotification.Name(rawValue: name), object: obiect)
}

/// 获取当前控制器
public func getTopController() -> UIViewController {
    return UIViewController.gt.topCurController() ?? UIViewController()
}

/// 获取当前控制器
public func getKeyWindow() -> UIWindow {
    return UIViewController.gt.keyWindow ?? UIWindow()
}
