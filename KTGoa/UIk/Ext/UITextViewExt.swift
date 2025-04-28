//
//  UITextViewExt.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/8/6.
//

import UIKit


import UIKit

extension UITextView {
    
    private static let kPlaceholderTag = 202406011
    
    var gt_placeholderColor: UIColor? {
        set {
            if let lb = viewWithTag(UITextView.kPlaceholderTag) as? UILabel {
                lb.textColor = newValue
            }
        }
        get {
            if let lb = viewWithTag(UITextView.kPlaceholderTag) as? UILabel {
                return lb.textColor
            }
            return nil
        }
    }
    
    var gt_placeholder: String {
        set {
            if let lb = viewWithTag(UITextView.kPlaceholderTag) as? UILabel {
                lb.text = newValue
            } else {
                let lb = UILabel()
                lb.tag = UITextView.kPlaceholderTag
                lb.font = font
                lb.numberOfLines = 0
                lb.textColor = .lightGray
                lb.text = newValue
                addSubview(lb)
                setValue(lb, forKey: "_placeholderLabel")
            }
        }
        get {
            let lb = value(forKey: "_placeholderLabel") as? UILabel
            return lb?.text ?? ""
        }
    }
    
    var jk_placeholderLabel: UILabel? {
        if let lb = value(forKey: "_placeholderLabel") as? UILabel {
            return lb
        }
        return nil
    }
}
