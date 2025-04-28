//
//  UIGestureRecognizerExt.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/7/23.
//

import UIKit

@objc public extension UIGestureRecognizer {
    
    private struct AssociateKeys {
        static var funcName = UnsafeRawPointer("UIGestureRecognizerFuncName".withCString { $0 })
        static var closure = UnsafeRawPointer("UIGestureRecognizerClosure".withCString { $0 })
    }
    
    var funcName: String {
        get {
            if let obj = objc_getAssociatedObject(self, &AssociateKeys.funcName) as? String {
                return obj
            }
            let string = String(describing: self.classForCoder)
            objc_setAssociatedObject(self, &AssociateKeys.funcName, string, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return string
        }
        set {
            objc_setAssociatedObject(self, &AssociateKeys.funcName, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func addAction(_ closure: @escaping (UIGestureRecognizer) -> Void) {
        objc_setAssociatedObject(self, &AssociateKeys.closure, closure, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        addTarget(self, action: #selector(gtinvoke))
    }
    
    private func gtinvoke() {
        if let closure = objc_getAssociatedObject(self, &AssociateKeys.closure) as? ((UIGestureRecognizer) -> Void) {
            closure(self)
        }
    }
}
