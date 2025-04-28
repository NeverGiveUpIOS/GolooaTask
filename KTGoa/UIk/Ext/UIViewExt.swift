//
//  UIViewExt.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/7/23.
//

import UIKit

extension UIView: GTCompble {}

// MARK: - UIView 的一些交互
public extension GTBas where Base: UIView {
    
    // MARK: - 键盘收起来
    func keyboardEnd() {
        bas.endEditing(true)
    }
    
    // MARK: - 添加方法
    func addActionClosure(_ actionClosure: @escaping ViewCallGesBlock) {
        if let sender = self.bas as? UIButton {
            sender.gt.handleClick(.touchUpInside) { (control) in
                guard let weakControl = control else {
                    return
                }
                actionClosure(nil, weakControl, weakControl.tag)
            }
        } else {
            _ = self.bas.gt.addGestureTap { (reco) in
                actionClosure((reco as! UITapGestureRecognizer), reco.view!, reco.view!.tag)
            }
        }
    }
    
    // MARK: 9.2、手势 - 单击
    @discardableResult
    func addGestureTap(_ action: @escaping RecognizerClosure) -> UITapGestureRecognizer {
        let obj = UITapGestureRecognizer(target: nil, action: nil)
        obj.numberOfTapsRequired = 1
        obj.numberOfTouchesRequired = 1
        addComGesRecog(obj)
        obj.addAction { (recognizer) in
            action(recognizer)
        }
        return obj
    }
    
    private func addComGesRecog(_ gestureRecognizer: UIGestureRecognizer) {
        bas.isUserInteractionEnabled = true
        bas.isMultipleTouchEnabled = true
        bas.addGestureRecognizer(gestureRecognizer)
    }
}

// MARK: - 关于UIView的 圆角、阴影、边框 的设置
public extension GTBas where Base: UIView {
    
    // MARK: - 添加圆角
    func addCorner(conrners: UIRectCorner = .allCorners , radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: self.bas.bounds, byRoundingCorners: conrners, cornerRadii: CGSize(width: radius, height: radius))
        self.bas.layer.mask = nil
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bas.bounds
        maskLayer.path = maskPath.cgPath
        self.bas.layer.mask = maskLayer
    }
    
    // MARK: - 添加圆角和边框
    func addCorner(conrners: UIRectCorner, radius: CGFloat, borderWidth: CGFloat, borderColor: UIColor) {
        let maskPath = UIBezierPath(roundedRect: self.bas.bounds, byRoundingCorners: conrners, cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bas.bounds
        maskLayer.path = maskPath.cgPath
        self.bas.layer.mask = maskLayer
        
        let borderLayer = CAShapeLayer()
        borderLayer.path = maskLayer.path
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.lineWidth = borderWidth
        borderLayer.frame =  self.bas.bounds
        self.bas.layer.addSublayer(borderLayer)
    }
    
    // MARK: - 给继承于view的类添加阴影
    /// 给继承于view的类添加阴影
    /// - Parameters:
    ///   - shadowColor: 阴影的颜色
    ///   - shadowOffset: 阴影的偏移度：CGSizeMake(X[正的右偏移,负的左偏移], Y[正的下偏移,负的上偏移])
    ///   - shadowOpacity: 阴影的透明度
    ///   - shadowRadius: 阴影半径，默认 3
    func addShadow(shadowColor: UIColor, shadowOffset: CGSize, shadowOpacity: Float, shadowRadius: CGFloat = 3) {
        bas.layer.shadowColor = shadowColor.cgColor
        bas.layer.shadowOpacity = shadowOpacity
        bas.layer.shadowRadius = shadowRadius
        bas.layer.shadowOffset = shadowOffset
    }
    
    // MARK: 添加阴影和圆角并存
    /// 添加阴影和圆角并存
    ///
    /// - Parameter superview: 父视图
    /// - Parameter conrners: 具体哪个圆角
    /// - Parameter radius: 圆角大小
    /// - Parameter shadowColor: 阴影的颜色
    /// - Parameter shadowOffset: 阴影的偏移度：CGSizeMake(X[正的右偏移,负的左偏移], Y[正的下偏移,负的上偏移])
    /// - Parameter shadowOpacity: 阴影的透明度
    /// - Parameter shadowRadius: 阴影半径，默认 3
    ///
    /// - Note1: 如果在异步布局(如：SnapKit布局)中使用，要在布局后先调用 layoutIfNeeded，再使用该方法
    /// - Note2: 如果在添加阴影的视图被移除，底部插入的父视图的layer是不会被移除的⚠️
    func addCornerAndShadow(superview: UIView, conrners: UIRectCorner , radius: CGFloat = 3, shadowColor: UIColor, shadowOffset: CGSize, shadowOpacity: Float, shadowRadius: CGFloat = 3) {
        
        let maskPath = UIBezierPath(roundedRect: self.bas.bounds, byRoundingCorners: conrners, cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bas.bounds
        maskLayer.path = maskPath.cgPath
        self.bas.layer.mask = maskLayer
        
        let subLayer = CALayer()
        let fixframe = self.bas.frame
        subLayer.frame = fixframe
        subLayer.cornerRadius = radius
        subLayer.backgroundColor = shadowColor.cgColor
        subLayer.masksToBounds = false
        // shadowColor阴影颜色
        subLayer.shadowColor = shadowColor.cgColor
        // shadowOffset阴影偏移,x向右偏移3，y向下偏移2，默认(0, -3),这个跟shadowRadius配合使用
        subLayer.shadowOffset = shadowOffset
        // 阴影透明度，默认0
        subLayer.shadowOpacity = shadowOpacity
        // 阴影半径，默认3
        subLayer.shadowRadius = shadowRadius
        subLayer.shadowPath = maskPath.cgPath
        superview.layer.insertSublayer(subLayer, below: self.bas.layer)
    }
    
    // MARK: - 添加边框
    func addBorder(borderWidth: CGFloat, borderColor: UIColor) {
        bas.layer.borderWidth = borderWidth
        bas.layer.borderColor = borderColor.cgColor
        bas.layer.masksToBounds = true
    }
    
    func setCornerRadius(_ cornerRadius: CGFloat, _ clipsToBounds: Bool = true) {
        bas.layer.cornerRadius = cornerRadius
        bas.clipsToBounds = clipsToBounds
    }
    
    /// -- 指定圆角
    func setCustomCoRadius(_ corners: CACornerMask, cornerRadius: CGFloat) {
        self.bas.layer.cornerRadius = cornerRadius
        self.bas.clipsToBounds = true
        self.bas.layer.maskedCorners = corners
    }
    
    //MARK: - 添加多个View子视图
    func addSubviews(_ views: [UIView]) {
        views.forEach { view in
            self.bas.addSubview(view)
        }
    }
    
    func removeSubviews() {
        self.bas.subviews.forEach({ $0.removeFromSuperview() })
    }
    
    
}

// MARK: - UIView 有关 Frame 的扩展
public extension GTBas where Base: UIView {
    
    // MARK: - x
    var x: CGFloat {
        get {
            return bas.frame.origin.x
        }
        set(newValue) {
            var tempFrame: CGRect = bas.frame
            tempFrame.origin.x = newValue
            bas.frame = tempFrame
        }
    }
    
    // MARK: - y
    var y: CGFloat {
        get {
            return bas.frame.origin.y
        }
        set(newValue) {
            var tempFrame: CGRect = bas.frame
            tempFrame.origin.y = newValue
            bas.frame = tempFrame
        }
    }
    
    // MARK: - height
    var height: CGFloat {
        get {
            return bas.frame.size.height
        }
        set(newValue) {
            var tempFrame: CGRect = bas.frame
            tempFrame.size.height = newValue
            bas.frame = tempFrame
        }
    }
    
    // MARK: - width
    var width: CGFloat {
        get {
            return bas.frame.size.width
        }
        set(newValue) {
            var tempFrame: CGRect = bas.frame
            tempFrame.size.width = newValue
            bas.frame = tempFrame
        }
    }
    
    // MARK: - size
    var size: CGSize {
        get {
            return bas.frame.size
        }
        set(newValue) {
            var tempFrame: CGRect = bas.frame
            tempFrame.size = newValue
            bas.frame = tempFrame
        }
    }
    
    // MARK: - centerX
    var centerX: CGFloat {
        get {
            return bas.center.x
        }
        set(newValue) {
            var tempCenter: CGPoint = bas.center
            tempCenter.x = newValue
            bas.center = tempCenter
        }
    }
    
    // MARK: - centerY
    var centerY: CGFloat {
        get {
            return bas.center.y
        }
        set(newValue) {
            var tempCenter: CGPoint = bas.center
            tempCenter.y = newValue
            bas.center = tempCenter
        }
    }
    
    // MARK: - center
    var center: CGPoint {
        get {
            return bas.center
        }
        set(newValue) {
            var tempCenter: CGPoint = bas.center
            tempCenter = newValue
            bas.center = tempCenter
        }
    }
    
    // MARK: - top 上端横坐标(y)
    var top: CGFloat {
        get {
            return bas.frame.origin.y
        }
        set(newValue) {
            var tempFrame: CGRect = bas.frame
            tempFrame.origin.y = newValue
            bas.frame = tempFrame
        }
    }
    
    // MARK: - left 左端横坐标(x)
    var left: CGFloat {
        get {
            return bas.frame.origin.x
        }
        set(newValue) {
            var tempFrame: CGRect = bas.frame
            tempFrame.origin.x = newValue
            bas.frame = tempFrame
        }
    }
    
    // MARK: - bottom 底端纵坐标 (y + height)
    var bottom: CGFloat {
        get {
            return bas.frame.origin.y + bas.frame.size.height
        }
        set(newValue) {
            bas.frame.origin.y = newValue - bas.frame.size.height
        }
    }
    
    // MARK: - right  (x + width)
    var right: CGFloat {
        get {
            return bas.frame.origin.x + bas.frame.size.width
        }
        set(newValue) {
            bas.frame.origin.x = newValue - bas.frame.size.width
        }
    }
    
    // MARK: - origin 点
    var origin: CGPoint {
        get {
            return bas.frame.origin
        }
        set(newValue) {
            var tempOrigin: CGPoint = bas.frame.origin
            tempOrigin = newValue
            bas.frame.origin = tempOrigin
        }
    }
}

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
    // MARK: - 设置边框虚线
    func setDashedBorder(color: UIColor, lineWidth: CGFloat, space: NSNumber = 4) {
        let border = CAShapeLayer()
        border.strokeColor = color.cgColor
        border.fillColor = nil
        border.path = UIBezierPath(rect: bounds).cgPath
        border.frame = bounds
        border.lineWidth = lineWidth
        border.lineCap = .square
        border.lineDashPattern = [space, space]
        layer.addSublayer(border)
    }
    
    /// -- 设置边框以及颜色
    func setBoardLine(_ color: UIColor, _ borderWidth: CGFloat) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = borderWidth
    }
    
    /// 设置渐变
    func gradientLayer(startPoint: CGPoint,
                       endPoint: CGPoint,
                       frame: CGRect,
                       colors: [Any]) {
        
        for sublayer in self.layer.sublayers ?? [] {
            if let gradientLayer = sublayer as? CAGradientLayer {
                gradientLayer.removeFromSuperlayer()
            }
        }
        
        let graLayer = CAGradientLayer()
        graLayer.startPoint = startPoint
        graLayer.endPoint = endPoint
        graLayer.frame = frame
        graLayer.colors = colors
        self.layer.insertSublayer(graLayer, at: 0)
    }
}

public typealias ViewCallGesBlock = ((UITapGestureRecognizer?, UIView, NSInteger) ->Void)
public typealias ControlClosure = ((UIControl) ->Void)
public typealias RecognizerClosure = ((UIGestureRecognizer) ->Void)


public protocol GTNibLoadable {
}

// MARK: -加载xib视图
public extension GTNibLoadable where Self: UIView {
    static func loadNibWithNibName(_ nibName: String? = nil) -> Self {
        let loadNme = nibName == nil ? "\(self)" : nibName!
        return Bundle.main.loadNibNamed(loadNme, owner: nil, options: nil)?.first as! Self
    }
}
