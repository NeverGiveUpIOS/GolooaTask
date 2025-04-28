//
//  DatePickerPreAnimate.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/7/25.
//

import UIKit

enum DatePickerAnimateType {
    case pres
    case dis
}

class DatePickerPreAnimate: NSObject,UIViewControllerAnimatedTransitioning {
    
    var animType: DatePickerAnimateType = .pres
    
    init(type: DatePickerAnimateType) {
        self.animType = type
    }
    /// 动画时间
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    /// 动画效果
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        switch animType {
        case .pres:
            guard let toVC = transitionContext.viewController(forKey: .to) as? CusDatePickView else {
                return
            }
            
            let toView = toVC.view
            
            let containerView = transitionContext.containerView
            containerView.addSubview(toView!)
            
            toVC.contentView.transform = CGAffineTransform(translationX: 0, y: (toVC.contentView.frame.height))
            
            UIView.animate(withDuration: 0.25, animations: {
                toVC.bagView.alpha = 1.0
                toVC.contentView.transform =  CGAffineTransform(translationX: 0, y: -10)
            }) { ( _ ) in
                UIView.animate(withDuration: 0.2, animations: {
                    toVC.contentView.transform = CGAffineTransform.identity
                }, completion: { (_) in
                    transitionContext.completeTransition(true)
                })
            }
            
        case .dis:
            
            guard let toVC = transitionContext.viewController(forKey: .from) as? CusDatePickView else {
                return
            }
            
            UIView.animate(withDuration: 0.25, animations: {
                toVC.bagView.alpha = 0.0
                toVC.contentView.transform =  CGAffineTransform(translationX: 0, y: (toVC.contentView.frame.height))
            }) { (_) in
                transitionContext.completeTransition(true)
            }
        }
    }
}
