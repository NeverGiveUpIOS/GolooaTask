//
//  UIControlExt.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/8/2.
//

import Foundation

public extension GTBas where Base: UIControl {
    
    // MARK: - 多少秒内不可重复点击
    func preventDoubleHit(_ hitTime: Double = 1) {
        bas.preventDoubleHit(hitTime)
    }
}


private var hitTimerKey: Void?
fileprivate extension UIControl  {
    
    private var hitTime: Double? {
        get { return gt_getAssObject(self, &hitTimerKey) }
        set { gt_setRetainedAssObject(self, &hitTimerKey, newValue, .OBJC_ASSOCIATION_ASSIGN) }
    }
    
    func preventDoubleHit(_ hitTime: Double) {
        self.hitTime = hitTime
        addTarget(self, action: #selector(c_preventDoubleHit), for: .touchUpInside)
    }
    
    @objc func c_preventDoubleHit(_ base: UIControl)  {
        base.isUserInteractionEnabled = false
        GTAsyncs.asyncDelay(hitTime ?? 1.0) {
        } _: {
            base.isUserInteractionEnabled = true
        }
    }
    
    /// 点击回调
    @objc func handleAction(_ sender: UIControl) {
        if let block = objc_getAssociatedObject(self, &AssociateKeys.closure) as? ControlClosure {
            block(sender)
        }
    }
}

private struct AssociateKeys {
    static var closure = UnsafeRawPointer("UIControlclosure".withCString { $0 })
}

