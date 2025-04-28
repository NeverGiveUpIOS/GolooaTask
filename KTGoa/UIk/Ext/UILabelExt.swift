//
//  UILabelExt.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/8/2.
//

import Foundation

extension UILabel {
    
    @discardableResult
    func attributedText(_ attributedText: NSAttributedString) -> Self {
        self.attributedText = attributedText
        return self
    }
    
    @discardableResult
    func text(_ text: String) -> Self {
        self.text = text
        return self
    }
    
    @discardableResult
    func line(_ number: Int) -> Self {
        numberOfLines = number
        return self
    }
    
    @discardableResult
    func textAlignment(_ alignment: NSTextAlignment) -> Self {
        textAlignment = alignment
        return self
    }
    
    @discardableResult
    func color(_ color: UIColor) -> Self {
        textColor = color
        return self
    }

    @discardableResult
    func color(_ hex: String) -> Self {
        textColor = UIColorHex(hex)
        return self
    }

    @discardableResult
    func font(_ font: UIFont) -> Self {
        self.font = font
        return self
    }

}


public extension GTBas where Base: UILabel {
    
    // MARK: 设置特定区域的字体大小
    /// 设置特定区域的字体大小
    /// - Parameters:
    ///   - font: 字体
    ///   - range: 区域
    func setRangeFontText(font: UIFont, range: NSRange) {
        let attributedString = bas.attributedText?.gt.setRangeFontText(font: font, range: range)
        bas.attributedText = attributedString
    }
    
    // MARK: 设置特定文字的字体大小
    /// 设置特定文字的字体大小
    /// - Parameters:
    ///   - text: 特定文字
    ///   - font: 字体
    func setsetSpecificTextFont(_ text: String, font: UIFont) {
        let attributedString = bas.attributedText?.gt.setSpecificTextFont(text, font: font)
        bas.attributedText = attributedString
    }
    
    // MARK: 设置特定区域的字体颜色
    /// 设置特定区域的字体颜色
    /// - Parameters:
    ///   - color: 字体颜色
    ///   - range: 区域
    func setSpecificRangeTextColor(color: UIColor, range: NSRange) {
        let attributedString = bas.attributedText?.gt.setSpecificRangeTextColor(color: color, range: range)
        bas.attributedText = attributedString
    }
    
    // MARK: 设置特定文字的字体颜色
    /// 设置特定文字的字体颜色
    /// - Parameters:
    ///   - text: 特定文字
    ///   - color: 字体颜色
    func setSpecificTextColor(_ text: String, color: UIColor) {
        let attributedString = bas.attributedText?.gt.setSpecificTextColor(text, color: color)
        bas.attributedText = attributedString
    }
    
    // MARK: 设置行间距
    /// 设置行间距
    /// - Parameter space: 行间距
    func setTextLineSpace(_ space: CGFloat) {
        let attributedString = bas.attributedText?.gt.setSpecificRangeTextLineSpace(lineSpace: space, alignment: bas.textAlignment, range: NSRange(location: 0, length: bas.text?.count ?? 0))
        bas.attributedText = attributedString
    }
    
    // MARK: 设置特定文字区域的下划线
    /// 设置特定区域的下划线
    /// - Parameters:
    ///   - color: 下划线颜色
    ///   - stytle: 下划线样式，默认单下划线
    ///   - range: 文字区域
    func setSpecificRangeTextUnderLine(color: UIColor, stytle: NSUnderlineStyle = .single, range: NSRange) {
        let attributedString = bas.attributedText?.gt.setSpecificRangeUnderLine(color: color, stytle: stytle, range: range)
        bas.attributedText = attributedString
    }

    // MARK: 插入图片
    /// 插入图片
    /// - Parameters:
    ///   - imgName: 要添加的图片名称，如果是网络图片，需要传入完整路径名，且imgBounds必须传值
    ///   - imgBounds: 图片的大小，默认为.zero，即自动根据图片大小设置，并以底部基线为标准。 y > 0 ：图片向上移动；y < 0 ：图片向下移动
    ///   - imgIndex:  图片的位置，默认放在开头
    func insertImage(imgName: String, imgBounds: CGRect = .zero, imgIndex: Int = 0) {
        // 设置换行方式
        bas.lineBreakMode = NSLineBreakMode.byCharWrapping
        let attributedString = bas.attributedText?.gt.insertImage(imgName: imgName, imgBounds: imgBounds, imgIndex: imgIndex)
        bas.attributedText = attributedString
    }

}
