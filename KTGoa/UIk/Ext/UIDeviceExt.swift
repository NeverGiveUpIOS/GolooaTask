//
//  UIDeviceExt.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/7/23.
//

import UIKit
import Foundation

extension UIDevice: GTCompble {}

public extension GTBas where Base: UIDevice {
    
    // MARK: - 状态栏高度
    static var statusBarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            let window: UIWindow? = UIApplication.shared.windows.first
            let statusBarH = (window?.windowScene?.statusBarManager?.statusBarFrame.height) ?? 0
            return statusBarH
        } else {
            return UIApplication.shared.statusBarFrame.height > 0 ? UIApplication.shared.statusBarFrame.height : 44
        }
    }
    
    // MARK: - top安全高度
    static var safeAreaTop: CGFloat {
        var tp: CGFloat = 0
        var wid: UIWindow? = UIApplication.shared.windows.first
        if false == wid?.isKeyWindow {
            let kwid: UIWindow? = UIApplication.shared.delegate?.window ?? nil
            if nil != kwid && kwid!.bounds.equalTo(UIScreen.main.bounds) {
                wid = kwid
            }
        }
        tp = wid?.safeAreaInsets.top ?? 0
        
        return tp
    }
    
    // MARK: - bottom安全高度
    static var safeAreaBottom: CGFloat {
        var bt: CGFloat = 0
        var wid: UIWindow? = UIApplication.shared.windows.first
        if false == wid?.isKeyWindow {
            let kwid: UIWindow? = UIApplication.shared.delegate?.window ?? nil
            if nil != kwid && kwid!.bounds.equalTo(UIScreen.main.bounds) {
                wid = kwid
            }
        }
        bt = wid?.safeAreaInsets.bottom ?? 0
        return bt
    }
    
    // MARK: - tabBar高度
    static  var tabBarHeight: CGFloat {
        return safeAreaBottom + 49
    }
    
    // MARK: - 导航栏高度
    static var naviBarHeight: CGFloat {
        return 44 + statusBarHeight
    }
    
    // MARK: - 是否刘海屏手机
    static var iPhoneX: Bool {
        guard let w = UIApplication.shared.delegate?.window else {
            return false
        }
        guard #available(iOS 11.0, *) else {
            return false
        }
        return w?.safeAreaInsets.bottom ?? 0 > 0.0
    }
}
