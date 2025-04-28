//
//  AlertBaseView.swift
//  Golaa
//
//  Created by chenkaisong on 2024/5/9.
//

import UIKit

/// 显示位置
enum DisplayPosition: String {
    case top
    case center
    case bottom
}

enum AlertContainerType {
    case curView
    case window
}

class AlertBaseView: UIView {

    /// 点击是否消失
    var isDismissible = true
    /// 距离顶部或者底部间距
    var disMargin: CGFloat = 0
    /// 透明背景色
    var alphaColor = UIColor.black.withAlphaComponent(0.5)
    
    /// 消失
    func dismissView(_ animated: Bool = true) {
        self.popupView()?.dismiss(animated: animated)
    }
    
    /// 消失事件
    @objc func touchDismissEvent() {
        // debugPrint("=====didDismissCallback========")
    }
    
    /// 显示
    /// - Parameters:
    ///   - position: 显示位置
    ///   - containerType: 容器类型
    ///   - isFadeIn: 是否渐变显示
    ///   - isFadeIn: 是否需要动画
    func show(position: DisplayPosition = .center,
              containerType: AlertContainerType = .window,
              isFadeIn: Bool = true,
              isAnimated: Bool = true) {
        
        guard let  containerView = containerType == .curView ? getTopController().view : getKeyWindow() else {
            return
        }
        
        switch position {
        case .center:
            if isFadeIn {
                PopSever.centerFadeIn(contentView: self, containerView: containerView, isDismissible: isDismissible, bagColor: alphaColor, isAnimated: isAnimated)
            } else {
                PopSever.centerZoomIn(contentView: self, containerView: containerView, isDismissible: isDismissible, bagColor: alphaColor, isAnimated: isAnimated)
            }
        case .bottom:
            if isFadeIn {
                PopSever.bottonFadeIn(contentView: self, containerView: containerView, isDismissible: isDismissible, bottomMargin: disMargin, bagColor: alphaColor, isAnimated: isAnimated)
            } else {
                PopSever.bottomUpward(contentView: self, containerView: containerView, isDismissible: isDismissible, bottomMargin: disMargin, bagColor: alphaColor, isAnimated: isAnimated)
            }
        default:
            if isFadeIn {
                PopSever.topFadeIn(contentView: self, containerView: containerView, isDismissible: isDismissible, topMargin: disMargin, bagColor: alphaColor, isAnimated: isAnimated)
            } else {
                PopSever.topDownward(contentView: self, containerView: containerView, isDismissible: isDismissible, topMargin: disMargin, bagColor: alphaColor, isAnimated: isAnimated)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        addNotiObserver(self, #selector(touchDismissEvent), "touchDismissEvent")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: self.frame.size.width, height: self.frame.size.height)
    }
    
    deinit {
        removeNotiObserver(self)
    }
    
}
