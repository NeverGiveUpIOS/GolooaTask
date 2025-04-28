//
//  UIScrollViewRefresh.swift
//  GTRefresh
//
//  Created by Lee on 2023/8/21.
//  Copyright © 2023年 KKK. All rights reserved.
//

import UIKit

private var headerKey: UInt8 = 0
private var footerKey: UInt8 = 0
public extension UIScrollView {
    var header: GTRefreshHeader? {
        set(newHeader) {
            if header != newHeader {
                header?.removeFromSuperview()
                self.insertSubview(newHeader!, at: 0)
                objc_setAssociatedObject(self, &headerKey, newHeader, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
        get {
            return objc_getAssociatedObject(self, &headerKey) as? GTRefreshHeader
        }
    }
    var footer: GTRefreshFooter? {
        set(newFooter) {
            if footer != newFooter {
                footer?.removeFromSuperview()
                self.insertSubview(newFooter!, at: 0)
                objc_setAssociatedObject(self, &footerKey, newFooter, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
        get {
            return objc_getAssociatedObject(self, &footerKey) as? GTRefreshFooter
        }
    }
}

extension NSObject {
    class func exchangeInstanceMethod1(_ method1: Selector, _ method2: Selector) {
        method_exchangeImplementations(class_getInstanceMethod(self, method1)!, class_getInstanceMethod(self, method2)!)
    }
    
    class func exchangeClassMehod(_ method1: Selector, _ method2: Selector) {
        method_exchangeImplementations(class_getClassMethod(self, method1)!, class_getClassMethod(self, method2)!)
    }
}

extension DispatchQueue {
    private static var onceTracker = [String]()
    
    public class func once(token: String, block:() -> Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        if onceTracker.contains(token) {
            return
        }
        
        onceTracker.append(token)
        block()
    }
}

