//
//  UIColorExt.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/7/23.
//

import UIKit

public func UIColorHex(_ hexStr: String) -> UIColor {
    return UIColor.hexStrToColor(hexStr)
}

public func UIColorHex(_ hexStr: String, alpha: CGFloat) -> UIColor {
    return UIColor.hexStrToColor(hexStr, alpha)
}

public extension UIColor {
    
    static var appColor: UIColor { return #colorLiteral(red: 1, green: 0.8549019608, blue: 0, alpha: 1) }
    
    static var x3: UIColor = UIColorHex("#333333")
    static var x6: UIColor = UIColorHex("#666666")
    static var x9: UIColor = UIColorHex("#999999")
    
    static var xf2: UIColor = UIColorHex("#F2F2F2")
    static var badgeColor: UIColor { return #colorLiteral(red: 0.9764705882, green: 0.3921568627, blue: 0.3921568627, alpha: 1) }

    func alpha(_ value: CGFloat) -> UIColor {
        return self.withAlphaComponent(value)
    }
    
    /// 设置颜色 如：#3CB371 或者 ##3CB371 -> 60,179,113
    static func hexStrToColor(_ hexStr: String) -> (r: CGFloat?, g: CGFloat?, b: CGFloat?) {

        guard hexStr.count >= 6 else {
            return (nil, nil, nil)
        }
        var tempHex = hexStr.uppercased()

        if tempHex.hasPrefix("0x") || tempHex.hasPrefix("0X") || tempHex.hasPrefix("##") {
            tempHex = String(tempHex[tempHex.index(tempHex.startIndex, offsetBy: 2)..<tempHex.endIndex])
        }
        if tempHex.hasPrefix("#") {
            tempHex = String(tempHex[tempHex.index(tempHex.startIndex, offsetBy: 1)..<tempHex.endIndex])
        }

        
        var range = NSRange(location: 0, length: 2)
        let rHex = (tempHex as NSString).substring(with: range)
        range.location = 2
        let gHex = (tempHex as NSString).substring(with: range)
        range.location = 4
        let bHex = (tempHex as NSString).substring(with: range)

        var r: UInt32 = 0, g: UInt32 = 0, b: UInt32 = 0
        Scanner(string: rHex).scanHexInt32(&r)
        Scanner(string: gHex).scanHexInt32(&g)
        Scanner(string: bHex).scanHexInt32(&b)
        return (r: CGFloat(r), g: CGFloat(g), b: CGFloat(b))
    }
    
    /// 设置颜色
    static func hexStrToColor(_ hexStr: String, _ alpha: CGFloat = 1.0) -> UIColor {
        let newColor = hexStrToColor(hexStr)
        guard let r = newColor.r, let g = newColor.g, let b = newColor.b else {
            assert(false, "Colors ---- Error")
            return .white
        }
        return color(r: r, g: g, b: b, alpha: alpha)
    }
    
    static func color(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha)
    }
    
    func transform() -> UIImage? {
        return UIImage.gt.image(color: self)
    }
}
