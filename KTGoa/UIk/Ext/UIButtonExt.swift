//
//  UIButtonExt.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/7/23.
//

import UIKit

// MARK: - Button的一些设置
public extension UIButton {
    
    // MARK: - 设置title
    @discardableResult
    func title(_ text: String, _ state: UIControl.State = .normal) -> Self {
        setTitle(text, for: state)
        return self
    }
    
    // MARK: - 设置TextColor
    @discardableResult
    func textColor(_ color: UIColor, _ state: UIControl.State = .normal) -> Self {
        setTitleColor(color, for: state)
        return self
    }
    
    // MARK: - 设置TextFont
    @discardableResult
    func font(_ font: UIFont) -> Self {
        titleLabel?.font = font
        return self
    }
    
    // MARK: - 设置UIImage
    @discardableResult
    func image(_ image: UIImage?, _ state: UIControl.State = .normal) -> Self {
        setImage(image, for: state)
        return self
    }
    
    // MARK: - 设置背景图片
    @discardableResult
    func bgImage(_ image: UIImage?, _ state: UIControl.State = .normal) -> Self {
        setBackgroundImage(image, for: state)
        return self
    }
}

// MARK: - Button 点击事件
public extension GTBas where Base: UIButton {
    
    // MARK: - button的点击事件
    func handleClick(_ controlEvents: UIControl.Event = .touchUpInside, buttonCallBack: ((_ button: UIButton?) -> ())?){
        bas.stCallBack = buttonCallBack
        bas.addTarget(bas, action: #selector(bas.swiftButtonAction), for: controlEvents)
    }
}

// MARK: - 设置图片和 title 的位置关系(title和image要在设置布局关系之前设置)
public extension GTBas where Base: UIButton {
    
    enum ImageTitlePos {
        case imgTop
        case imgBottom
        case imgLeft
        case imgRight
    }
    
    @discardableResult
    func setImageTitlePos(_ layout: ImageTitlePos, spacing: CGFloat = 0) -> UIButton {
        switch layout {
        case .imgLeft:
            alignHorizontal(spacing: spacing, imageFirst: true)
        case .imgRight:
            alignHorizontal(spacing: spacing, imageFirst: false)
        case .imgTop:
            alignVertical(spacing: spacing, imageTop: true)
        case .imgBottom:
            alignVertical(spacing: spacing, imageTop: false)
        }
        return self.bas
    }
    
    /// 垂直方向
    private func alignVertical(spacing: CGFloat, imageTop: Bool) {
        guard let imageSize = self.bas.imageView?.image?.size,
              let text = self.bas.titleLabel?.text,
              let font = self.bas.titleLabel?.font
        else {
            return
        }
        let labelString = NSString(string: text)
        let titleSize = labelString.size(withAttributes: [NSAttributedString.Key.font: font])
        
        let imageVerticalOffset = (titleSize.height + spacing) / 2
        let titleVerticalOffset = (imageSize.height + spacing) / 2
        let imageHorizontalOffset = (titleSize.width) / 2
        let titleHorizontalOffset = (imageSize.width) / 2
        let sign: CGFloat = imageTop ? 1 : -1
        
        bas.imageEdgeInsets = UIEdgeInsets(top: -imageVerticalOffset * sign,
                                           left: imageHorizontalOffset,
                                           bottom: imageVerticalOffset * sign,
                                           right: -imageHorizontalOffset)
        bas.titleEdgeInsets = UIEdgeInsets(top: titleVerticalOffset * sign,
                                           left: -titleHorizontalOffset,
                                           bottom: -titleVerticalOffset * sign,
                                           right: titleHorizontalOffset)
        
        let edgeOffset = (min(imageSize.height, titleSize.height) + spacing) / 2
        bas.contentEdgeInsets = UIEdgeInsets(top: edgeOffset, left: 0, bottom: edgeOffset, right: 0)
    }
    
    /// 水平方向
    private func alignHorizontal(spacing: CGFloat, imageFirst: Bool) {
        let edgeOffset = spacing / 2
        bas.imageEdgeInsets = UIEdgeInsets(top: 0, left: -edgeOffset,
                                           bottom: 0,right: edgeOffset)
        bas.titleEdgeInsets = UIEdgeInsets(top: 0, left: edgeOffset,
                                           bottom: 0, right: -edgeOffset)
        if !imageFirst {
            bas.transform = CGAffineTransform(scaleX: -1, y: 1)
            bas.imageView?.transform = CGAffineTransform(scaleX: -1, y: 1)
            bas.titleLabel?.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        bas.contentEdgeInsets = UIEdgeInsets(top: 0, left: edgeOffset, bottom: 0, right: edgeOffset)
    }
    
}

private var buttonCallClickkey: Void?
extension UIButton: GTProComble {
    internal typealias T = UIButton
    internal var stCallBack: StCallBack? {
        get { return gt_getAssObject(self, &buttonCallClickkey) }
        set { gt_setRetainedAssObject(self, &buttonCallClickkey, newValue) }
    }
    
    @objc internal func swiftButtonAction(_ button: UIButton) {
        self.stCallBack?(button)
    }
}

public func gt_getAssObject<T>(_ object: Any, _ key: UnsafeRawPointer) -> T? {
    return objc_getAssociatedObject(object, key) as? T
}

public func gt_setRetainedAssObject<T>(_ object: Any, _ key: UnsafeRawPointer, _ value: T, _ policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) {
    objc_setAssociatedObject(object, key, value, policy)
}
