//
//  StringExt.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/8/1.
//
import UIKit
import CommonCrypto
import CryptoKit

extension String {

    func date() -> Date? {
        let p = DateFormatter()
        p.dateFormat = "YYYY-MM-dd"
        return p.date(from: self)
    }
    
    func copy() {
        let tStr = self
        UIPasteboard.general.string = tStr
    }
    
    func md5() -> String {
          let data = self.data(using: .utf8)!
          var digest = Data(count: Int(CC_MD5_DIGEST_LENGTH))
          _ = digest.withUnsafeMutableBytes { digestBytes in
              data.withUnsafeBytes { dataBytes in
                  CC_MD5(dataBytes.baseAddress, CC_LONG(data.count), digestBytes.bindMemory(to: UInt8.self).baseAddress)
              }
          }
          
          return digest.map { String(format: "%02hhx", $0) }.joined()
      }
    
    // MARK: - JSON 字符串 ->  Dictionary
    func jsonStringToDictionary() -> Dictionary<String, Any>? {
        let jsonString = self
        guard let jsonData: Data = jsonString.data(using: .utf8) else { return nil }
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return (dict as! Dictionary<String, Any>)
        }
        return nil
    }
    
    // MARK: - 截取字符串从开始到 index
    public func sub(to index: Int) -> String {
        let end_Index = validIndex(original: index)
        return String(self[self.startIndex ..< end_Index])
    }
    
    // MARK: - 截取字符串从index到结束
    public func sub(from index: Int) -> String {
        let start_index = validIndex(original: index)
        return String(self[start_index ..< self.endIndex])
    }
    
    // MARK: - 获取指定位置和长度的字符串
    public func sub(start: Int, length: Int = -1) -> String {
        var len = length
        if len == -1 || (start + length) > self.count {
            len = self.count - start
        }
        let st = self.index(self.startIndex, offsetBy: start)
        let en = self.index(st, offsetBy: len)
        let range = st ..< en
        return String(self[range]) // .substring(with:range)
    }
    
    private func validIndex(original: Int) -> String.Index {
        switch original {
        case ...self.startIndex.utf16Offset(in: self):
            return self.startIndex
        case self.endIndex.utf16Offset(in: self)...:
            return self.endIndex
        default:
            return self.index(self.startIndex, offsetBy: original > self.count ? self.count : original)
        }
    }

    
    // MARK: 去掉所有空格
    /// 去掉所有空格
    var removeAllSapce: String {
        return self.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
    }
    
    // MARK: 字符串转 Int
    /// 字符串转 Int
    /// - Returns: Int
    func toInt() -> Int? {
        guard let doubleValue = Double(self) else { return nil }
        return Int(doubleValue)
    }
}

extension String {
    
    // MARK: 判断是否全是空白,包括空白字符和换行符号，长度为0返回true
    public var isBlank: Bool {
        return self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) == ""
    }
    
    /// 判断是否是有效的电子邮件地址
    public var isValidEmail: Bool {
        let rgex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        return predicateValue(rgex: rgex)
    }
    
    private func predicateValue(rgex: String) -> Bool {
        let checker: NSPredicate = NSPredicate(format: "SELF MATCHES %@", rgex)
        return checker.evaluate(with: self)
    }
    
    // MARK: 对字符串(多行)指定出字体大小和最大的 Size，获取 (Size)
     func rectSize(font: UIFont, size: CGSize) -> CGSize {
        let attributes = [NSAttributedString.Key.font: font]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect: CGRect = self.boundingRect(with: size, options: option, attributes: attributes, context: nil)
        return rect.size
    }
    
    // MARK: 对字符串(多行)指定字体及Size，获取 (高度)
    public func rectHeight(font: UIFont, size: CGSize) -> CGFloat {
        return rectSize(font: font, size: size).height
    }
    
    // MARK: 对字符串(多行)指定字体及Size，获取 (宽度)
    public func rectWidth(font: UIFont, size: CGSize) -> CGFloat {
        return rectSize(font: font, size: size).width
    }
    
    // MARK: 对字符串(单行)指定字体，获取 (Size)
    public func singleLineSize(font: UIFont) -> CGSize {
        let attrs = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: attrs as [NSAttributedString.Key: Any])
    }
    
    // MARK: 对字符串(单行)指定字体，获取 (width)
    public func singleLineWidth(font: UIFont) -> CGFloat {
        let attrs = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: attrs as [NSAttributedString.Key: Any]).width
    }
    
    // MARK: 对字符串(单行)指定字体，获取 (Height)
    /// 对字符串(单行)指定字体，获取 (height)
    /// - Parameter font: 字体的大小
    /// - Returns: 返回单行字符串的 height
    public func singleLineHeight(font: UIFont) -> CGFloat {
        let attrs = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: attrs as [NSAttributedString.Key: Any]).height
    }
    
    // MARK: 字符串通过 label 根据高度&字体 —> Size
    /// 字符串通过 label 根据高度&字体 ——> Size
    /// - Parameters:
    ///   - height: 字符串最大的高度
    ///   - font: 字体大小
    /// - Returns: 返回Size
    public func sizeAccording(width: CGFloat, height: CGFloat = CGFloat(MAXFLOAT), font: UIFont) -> CGSize {
        if self.isBlank {return CGSize(width: 0, height: 0)}
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        let label = UILabel(frame: rect).font(font).text(self).line(0)
        return label.sizeThatFits(rect.size)
    }
    
    // MARK: 字符串通过 label 根据高度&字体 —> Width
    /// 字符串通过 label 根据高度&字体 ——> Width
    /// - Parameters:
    ///   - height: 字符串最大高度
    ///   - font: 字体大小
    /// - Returns: 返回宽度大小
    public func widthAccording(width: CGFloat, height: CGFloat = CGFloat(MAXFLOAT), font: UIFont) -> CGFloat {
        if self.isBlank {return 0}
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        let label = UILabel(frame: rect).font(font).text(self).line(0)
        return label.sizeThatFits(rect.size).width
    }
    
    // MARK: 字符串通过 label 根据宽度&字体 —> height
    /// 字符串通过 label 根据宽度&字体 ——> height
    /// - Parameters:
    ///   - width: 字符串最大宽度
    ///   - font: 字体大小
    /// - Returns: 返回高度大小
    public func heightAccording(width: CGFloat, height: CGFloat = CGFloat(MAXFLOAT), font: UIFont) -> CGFloat {
        if self.isBlank {return 0}
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        let label = UILabel(frame: rect).font(font).text(self).line(0)
        return label.sizeThatFits(rect.size).height
    }
    
    // MARK: 字符串根据宽度 & 字体 & 行间距 —> Size
    public func sizeAccording(width: CGFloat, height: CGFloat = CGFloat(MAXFLOAT), font: UIFont, lineSpacing: CGFloat) -> CGSize {
        if self.isBlank {return CGSize(width: 0, height: 0)}
        let rect = CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
        let label = UILabel(frame: rect).font(font).text(self).line(0)
        let attrStr = NSMutableAttributedString(string: self)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        attrStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, self.count))
        label.attributedText = attrStr
        return label.sizeThatFits(rect.size)
    }
    
    // MARK: 字符串根据宽度 & 字体 & 行间距 —> width
    public func widthAccording(width: CGFloat, height: CGFloat = CGFloat(MAXFLOAT), font: UIFont, lineSpacing: CGFloat) -> CGFloat {
        if self.isBlank {return 0}
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        let label = UILabel(frame: rect).font(font).text(self).line(0)
        let attrStr = NSMutableAttributedString(string: self)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        attrStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, self.count))
        label.attributedText = attrStr
        return label.sizeThatFits(rect.size).width
    }
    
    // MARK: 字符串根据宽度 & 字体 & 行间距 —> height
    public func heightAccording(width: CGFloat, height: CGFloat = CGFloat(MAXFLOAT), font: UIFont, lineSpacing: CGFloat) -> CGFloat {
        if self.isBlank {return 0}
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        let label = UILabel(frame: rect).font(font).text(self).line(0)
        let attrStr = NSMutableAttributedString(string: self)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        attrStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, self.count))
        label.attributedText = attrStr
        return label.sizeThatFits(rect.size).height
    }
}
