//
//  UIScrollViewExtension.swift
//  GTRefresh
//
//  Created by Lee on 2023/8/20.
//  Copyright © 2023年 KKK. All rights reserved.
//

import UIKit


public extension UIScrollView {

    var inset: UIEdgeInsets {
        get {
            if #available(iOS 11.0, *) {
                return self.adjustedContentInset
            } else {
                return self.contentInset
            }
        }
    }
    
    var insetTop: CGFloat {
        set(newTop) {
            var inset = self.contentInset
            inset.top = newTop
            if #available(iOS 11.0, *) {
                inset.top -= (self.adjustedContentInset.top - self.contentInset.top)
            }
            self.contentInset = inset
        }
        get {
            return inset.top
        }
    }
    
    var insetRight: CGFloat {
        set(newRight) {
            var inset = self.contentInset
            inset.right = newRight
            if #available(iOS 11.0, *) {
                inset.right -= (self.adjustedContentInset.right - self.contentInset.right)
            }
            self.contentInset = inset
        }
        get {
            return inset.right
        }
    }
    
    var insetBottom: CGFloat {
        set(newBottom) {
            var inset = self.contentInset
            inset.bottom = newBottom
            if #available(iOS 11.0, *) {
                inset.bottom -= (self.adjustedContentInset.bottom - self.contentInset.bottom)
            }
            self.contentInset = inset
        }
        get {
            return inset.bottom
        }
    }
    
    var insetLeft: CGFloat {
        set(newLeft) {
            var inset = self.contentInset
            inset.left = newLeft
            if #available(iOS 11.0, *) {
                inset.left -= (self.adjustedContentInset.left - self.contentInset.left)
            }
            self.contentInset = inset
        }
        get {
            return inset.left
        }
    }
    
    var offsetX: CGFloat {
        set(newOffsetX) {
            var offset = self.contentOffset
            offset.x = newOffsetX
            self.contentOffset = offset
        }
        get {
            return self.contentOffset.x
        }
    }
    
    var offsetY: CGFloat {
        set(newOffsetY) {
            var offset = self.contentOffset
            offset.y = newOffsetY
            self.contentOffset = offset
        }
        get {
            return self.contentOffset.y
        }
    }
    
    var contentW: CGFloat {
        set(newContentW) {
            var size = self.contentSize
            size.width = newContentW
            self.contentSize = size
        }
        get {
            return self.contentSize.width
        }
    }
    var contentH: CGFloat {
        set(newContentH) {
            var size = self.contentSize
            size.height = newContentH
            self.contentSize = size
        }
        get {
            return self.contentSize.height
        }
    }
}







