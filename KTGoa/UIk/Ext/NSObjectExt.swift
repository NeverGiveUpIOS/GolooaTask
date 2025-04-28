//
//  NSObjectExt.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/7/24.
//

import UIKit

public extension NSObject {
    
    // MARK: （对象方法）
    var className: String {
        return type(of: self).className
    }
    
    // MARK: - 类名（类方法）
    static var className: String {
        return String(describing: self)
    }
}
