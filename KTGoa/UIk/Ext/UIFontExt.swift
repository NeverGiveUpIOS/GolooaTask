//
//  UIFontExt.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/7/23.
//

import UIKit

public func UIFontReg(_ ofSize: CGFloat) -> UIFont{
    return UIFont.gt.pfReg(ofSize)
}

public func UIFontMedium(_ ofSize: CGFloat) -> UIFont{
    return UIFont.gt.pfMum(ofSize)
}

public func UIFontSemibold(_ ofSize: CGFloat) -> UIFont{
    return UIFont.gt.pfSmb(ofSize)
}

public func UIFontCusFont(_ ofSize: CGFloat,_ fontName: String) -> UIFont{
    return UIFont.gt.customFont(ofSize, fontName)
}

/// PingFangSC-字体
fileprivate enum UIFontWeight: String {
    case regular = "Regular"
    case medium = "Medium"
    case semibold = "Semibold"
}

extension UIFont: GTCompble {}

public extension GTBas where Base: UIFont {
    
    /// regular
    static func pfReg(_ ofSize: CGFloat) -> UIFont {
        return pfont(ofSize, W: .regular)
    }
    
    /// medium
    static func pfMum(_ ofSize: CGFloat) -> UIFont {
        return pfont(ofSize, W: .medium)
    }
    
    /// semibold
    static func pfSmb(_ ofSize: CGFloat) -> UIFont {
        return pfont(ofSize, W: .semibold)
    }
    
    /*
     使用自定义自提注意事项
     1、添加自定义字体到项目，保证TARGETS->Build Phases里面有对应的字体资源
     2、在info.plist添加字体资源 Fonts provided by application(数组类型，存放自定义字体名字)
     3、调用下面方法使用：UIFont.gt.customFont
     */
    /// customFont
    static func customFont(_ ofSize: CGFloat, _ fontName: String) -> UIFont {
        return sysCustomFont(fontName: fontName, ofSize: ofSize)
    }
}

// MARK: - private
public extension GTBas where Base: UIFont {
    
    private static func pfont(_ ofSize: CGFloat, W Weight: UIFontWeight) -> UIFont {
        let fontName = "PingFangSC-" + Weight.rawValue
        return sysCustomFont(fontName: fontName, ofSize: ofSize)
    }
    
    private static func sysCustomFont(fontName: String, ofSize: CGFloat) -> UIFont {
        if let font = UIFont(name: fontName, size: ofSize) {
            return font
        } else {
            return UIFont.systemFont(ofSize: ofSize)
        }
    }
}

extension UIFont {
    static func oswaldDemiBold(_ ofSize: CGFloat) -> UIFont {
       return UIFont(name: "Oswald", size: ofSize) ?? UIFont.systemFont(ofSize: ofSize, weight: .bold)
    }
    
    static func gilroyHeavy(_ ofSize: CGFloat) -> UIFont {
        return UIFont(name: "Gilroy", size: ofSize) ?? UIFont.systemFont(ofSize: ofSize, weight: .bold)
    }
}
