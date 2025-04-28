//
//  GiftItemIndexView.swift
//  Golaa
//
//  Created by chenkaisong on 2024/5/23.
//

import UIKit

class GiftItemIndexView: UIPageControl {
    
    /// 活跃指示器颜色
    public var activeColor: UIColor = .hexStrToColor("#000000")
    
    /// 非活跃指示器颜色
    public var inactiveColor: UIColor = .hexStrToColor("#EBEBEB")
    
    /// 活跃指示器大小
    public var activeSize = CGSize(width: 10, height: 4)
    
    /// 非活跃指示器大小
    public var inactiveSize = CGSize(width: 4, height: 4)

    private let magicTag = "KMPageControl".hash

    /// 指示器间距
    public var dotSpacing: CGFloat = 5.0 {
        didSet {
            updateDots()
        }
    }
    
    override public var currentPage: Int {
        didSet {
            updateDots()
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        updateDots(animated: false)
    }
    
    /// 更新指示器
    func updateDots(animated: Bool = true) {
        
        guard numberOfPages > 0 else { return }
        
        let view = self
        let spacing = dotSpacing
        let dotsTotalW: CGFloat = CGFloat(numberOfPages - 1)
            * (inactiveSize.width + spacing)
            + activeSize.width
        let totalW = view.bounds.width

        var startX: CGFloat = totalW > dotsTotalW
            ? (totalW - dotsTotalW)/2.0
            : 0
        for idx in (0..<numberOfPages) {
            let isActive = idx == currentPage
            let color = isActive ? activeColor : inactiveColor
            let size = isActive ? activeSize: inactiveSize
            let imageV = self.imageView(for: view, index: idx)
            let pointX = startX
            let pointY = view.bounds.midY - size.height/2.0

            let change = {
                imageV?.frame = .init(x: pointX, y: pointY, width: size.width, height: size.height)
                imageV?.layer.cornerRadius = min(size.width, size.height)/2.0
                imageV?.backgroundColor = color
            }
            if animated {
                UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                    change()
                })
            } else {
                change()
            }
            startX += size.width + spacing
        }
    }
    
    func imageView(for view: UIView, index page: Int) -> UIImageView? {
        let tag = magicTag + page
        if let imageV = view.viewWithTag(tag) as? UIImageView {
            return imageV
        }
        let imageV  = UIImageView()
        imageV.tag = tag
        view.addSubview(imageV)
        return imageV
    }
}
