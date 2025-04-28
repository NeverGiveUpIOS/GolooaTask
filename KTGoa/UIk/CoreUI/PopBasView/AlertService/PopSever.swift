//
//  PopSever.swift
//  Golaa
//
//  Created by chenkaisong on 2024/5/9.
//

import UIKit

// 提供多种样式 可参考自行添加BaseAnimator.Layout 和 PopupViewAnimator自行添加
class PopSever: NSObject {}

/*
 // 使用示例 PopSever.centerFadeIn(contentView:UIView())
 // 点击contentView按钮消失  调用示例  view.popupView()?.dismiss(animated: true, completion: nil)
 // contentView重载intrinsicContentSize属性并返回其内容的CGSize，无需再设置frame值。
 override var intrinsicContentSize: CGSize {
 return CGSize(width: 200, height: 200)
 }
 */

// MARK: - show Center
extension PopSever {
    
    /// 渐变显示 默认显示在keyWindow
    /// - Parameters:
    ///   - contentView: 自定义view
    ///   - containerView:  默认显示keyWindow
    static func centerFadeIn(contentView: UIView,
                             containerView: UIView = getKeyWindow()) {
        PopSever.centerFadeIn(contentView: contentView, containerView: containerView, isDismissible: true, bagColor: UIColor.black.withAlphaComponent(0.6))
    }
    
    /// 渐变渐变
    /// - Parameters:
    ///   - contentView: 自定义view
    ///   - containerView:  显示容器
    ///   - isDismissible: 点击contentView以外区域是否显示消失
    ///   - bagColor: 背景色
    static func centerFadeIn(contentView: UIView,
                             containerView: UIView,
                             isDismissible: Bool,
                             bagColor: UIColor,
                             isAnimated: Bool = true) {
        let layout: KBaseAnimator.KPopViewLayout = .center(.init())
        
        let animator: PopupViewAnimator = KFadeInOutAnimator(layout: layout)
        
        let popupView = PopupView(containerView: containerView, contentView: contentView, animator: animator)
        
        // 配置交互 点击contentView意外区域消失
        if isDismissible {
            popupView.isDismissible = true
            popupView.isInteractive = true
            popupView.isPenetrable = false
        }
        
        popupView.posionENUM = .center
        
        // 配置背景 style 可自行添加
        popupView.backgroundView.style = .solidColor
        
        // 背景色
        popupView.backgroundView.color = bagColor
        popupView.display(animated: isAnimated, completion: nil)
    }
    
    /// 缩放显示
    /// - Parameters:
    ///   - contentView: 自定义view
    ///   - containerView:  默认显示keyWindow
    static func centerZoomIn(contentView: UIView,
                             containerView: UIView = getKeyWindow()) {
        PopSever.centerFadeIn(contentView: contentView, containerView: containerView, isDismissible: true, bagColor: UIColor.black.withAlphaComponent(0.6))
    }
    
    /// 缩放显示
    /// - Parameters:
    ///   - contentView:  自定义view
    ///   - containerView: 显示容器
    ///   - isDismissible: 点击contentView以外区域是否显示消失
    ///   - bagColor: 背景色
    
    static func centerZoomIn(contentView: UIView,
                             containerView: UIView,
                             isDismissible: Bool,
                             bagColor: UIColor,
                             isAnimated: Bool = true) {
        let layout: KBaseAnimator.KPopViewLayout = .center(.init())
        
        let animator: PopupViewAnimator = ZoomInOutAnimator(layout: layout)
        
        let popupView = PopupView(containerView: containerView, contentView: contentView, animator: animator)
        
        // 配置交互 点击contentView意外区域消失
        if isDismissible {
            popupView.isDismissible = true
            popupView.isInteractive = true
            popupView.isPenetrable = false
        }
        
        popupView.posionENUM = .center
        
        // 配置背景 style 可自行添加
        popupView.backgroundView.style = .solidColor
        
        // 背景色
        popupView.backgroundView.color = bagColor
        popupView.display(animated: isAnimated, completion: nil)
    }
}

// MARK: - show Bottom
extension PopSever {
    
    /// 渐变显示 默认显示在keyWindow
    /// - Parameters:
    ///   - contentView: 自定义view
    ///   - containerView:  默认显示keyWindow
    ///   - bottomMargin:  距离底部间距 默认时0
    static func bottomFadeIn(contentView: UIView,
                             containerView: UIView = getKeyWindow(),
                             bottomMargin: CGFloat = 0,
                             isAnimated: Bool = true) {
        PopSever.bottonFadeIn(contentView: contentView, 
                              containerView: containerView,
                              isDismissible: true,
                              bottomMargin: bottomMargin,
                              bagColor: UIColor.black.withAlphaComponent(0.6),
                              isAnimated: isAnimated)
    }
    
    ///  渐变显示
    /// - Parameters:
    ///   - contentView: 自定义view
    ///   - containerView: 显示容器
    ///   - isDismissible: 点击contentView以外区域是否显示消失
    ///   - bottomMargin:  距离底部间距 默认0
    ///   - bagColor: 背景色
    static func bottonFadeIn(contentView: UIView,
                             containerView: UIView,
                             isDismissible: Bool,
                             bottomMargin: CGFloat,
                             bagColor: UIColor,
                             isAnimated: Bool = true) {
        let layout: KBaseAnimator.KPopViewLayout = .bottom(.init(bottomMargin: bottomMargin))
        
        let animator: PopupViewAnimator = KFadeInOutAnimator(layout: layout)
        
        let popupView = PopupView(containerView: containerView, contentView: contentView, animator: animator)
        
        // 配置交互 点击contentView意外区域消失
        if isDismissible {
            popupView.isDismissible = true
            popupView.isInteractive = true
            popupView.isPenetrable = false
        }
        
        popupView.posionENUM = .bottom
        
        // 配置背景 style 可自行添加
        popupView.backgroundView.style = .solidColor
        
        // 背景色
        popupView.backgroundView.color = bagColor
        popupView.display(animated: isAnimated, completion: nil)
    }
    
    ///  从下开始显示
    /// - Parameters:
    ///   - contentView: 自定义view
    ///   - containerView: 默认显示keyWindow
    ///   - bottomMargin: 距离底部间距 默认0
    static func bottomUpward(contentView: UIView,
                             containerView: UIView = getKeyWindow(),
                             bottomMargin: CGFloat = 0,
                             isAnimated: Bool = true) {
        PopSever.bottomUpward(contentView: contentView, 
                              containerView: containerView,
                              isDismissible: true,
                              bottomMargin: bottomMargin,
                              bagColor: UIColor.black.withAlphaComponent(0.6),
                              isAnimated: isAnimated)
    }
    
    ///  从下开始显示
    /// - Parameters:
    ///   - contentView: 自定义view
    ///   - containerView: 显示容器
    ///   - isDismissible: 点击contentView以外区域是否显示消失
    ///   - bottomMargin:  距离底部间距 默认0
    ///   - bagColor: 背景色
    static func bottomUpward(contentView: UIView,
                             containerView: UIView,
                             isDismissible: Bool,
                             bottomMargin: CGFloat,
                             bagColor: UIColor,
                             isAnimated: Bool = true) {
        
        let layout: KBaseAnimator.KPopViewLayout = .bottom(.init(bottomMargin: bottomMargin))
        
        let animator: PopupViewAnimator = UpwardAnimator(layout: layout)
        
        let popupView = PopupView(containerView: containerView, contentView: contentView, animator: animator)
        
        // 配置交互 点击contentView意外区域消失
        if isDismissible {
            popupView.isDismissible = true
            popupView.isInteractive = true
            popupView.isPenetrable = false
        }
        
        popupView.posionENUM = .bottom
        
        // 配置背景 style 可自行添加
        popupView.backgroundView.style = .solidColor
        
        // 背景色
        popupView.backgroundView.color = bagColor
        popupView.display(animated: isAnimated, completion: nil)
    }
}

// MARK: - show Top
extension PopSever {
    
    /// 渐变显示
    /// - Parameters:
    ///   - contentView: 自定义view
    ///   - containerView: 显示承载的view 默认显示keyWindow
    ///   - topMargin:  距离顶部间距 默认0
    static func topFadeIn(contentView: UIView,
                          containerView: UIView = getKeyWindow(),
                          topMargin: CGFloat = 0,
                          isAnimated: Bool = true) {
        PopSever.topFadeIn(contentView: contentView,
                           containerView: containerView,
                           isDismissible: true,
                           topMargin: topMargin,
                           bagColor: UIColor.black.withAlphaComponent(0.6),
                           isAnimated: isAnimated)
    }
    
    /// 渐变方式
    static func topFadeIn(contentView: UIView,
                          containerView: UIView,
                          isDismissible: Bool,
                          topMargin: CGFloat,
                          bagColor: UIColor,
                          isAnimated: Bool = true) {
        let layout: KBaseAnimator.KPopViewLayout = .top(.init(topMargin: topMargin))
        
        let animator: PopupViewAnimator = KFadeInOutAnimator(layout: layout)
        
        let popupView = PopupView(containerView: containerView, contentView: contentView, animator: animator)
        
        // 配置交互 点击contentView意外区域消失
        if isDismissible {
            popupView.isDismissible = true
            popupView.isInteractive = true
            popupView.isPenetrable = false
        }
        
        popupView.posionENUM = .top
        
        // 配置背景 style 可自行添加
        popupView.backgroundView.style = .solidColor
        
        // 背景色
        popupView.backgroundView.color = bagColor
        popupView.display(animated: isAnimated, completion: nil)
    }
    
    /// 从上开始显示
    /// - Parameters:
    ///   - contentView: 自定义view
    ///   - containerView: 显示承载的view 默认显示keyWindow
    ///   - topMargin:  距离顶部间距 默认0
    static func topDownward(contentView: UIView,
                            containerView: UIView = getKeyWindow(),
                            topMargin: CGFloat = 0,
                            isAnimated: Bool = true) {
        PopSever.topDownward(contentView: contentView, 
                             containerView: containerView,
                             isDismissible: true,
                             topMargin: topMargin,
                             bagColor: UIColor.black.withAlphaComponent(0.6),
                             isAnimated: isAnimated)
    }
    
    ///  从上开始显示
    /// - Parameters:
    ///   - contentView: 自定义view
    ///   - containerView: 显示容器
    ///   - isDismissible: 点击contentView以外区域是否显示消失
    ///   - topMargin:  距离顶部间距 默认0
    ///   - bagColor: 背景色
    static func topDownward(contentView: UIView,
                            containerView: UIView,
                            isDismissible: Bool,
                            topMargin: CGFloat,
                            bagColor: UIColor,
                            isAnimated: Bool = true) {
        let layout: KBaseAnimator.KPopViewLayout = .top(.init(topMargin: topMargin))
        
        let animator: PopupViewAnimator = KDownwardAnimator(layout: layout)
        
        let popupView = PopupView(containerView: containerView, contentView: contentView, animator: animator)
        
        // 配置交互 点击contentView意外区域消失
        if isDismissible {
            popupView.isDismissible = true
            popupView.isInteractive = true
            popupView.isPenetrable = false
        }
        
        popupView.posionENUM = .top
        
        // 配置背景 style 可自行添加
        popupView.backgroundView.style = .solidColor
        
        // 背景色
        popupView.backgroundView.color = bagColor
        popupView.display(animated: isAnimated, completion: nil)
    }
}
