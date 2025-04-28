//
//  JRefreshAutoGifFooter.swift
//  GTRefresh
//
//  Created by Lee on 2023/8/23.
//  Copyright © 2023年 KKK. All rights reserved.
//

import UIKit

open class GTRefreshAutoGifFooter: GTRefreshAutoStateFooter {
    
    lazy var gifView: UIImageView = {
        let gifView = UIImageView()
        return gifView
    }()
    
    lazy var stateImages: [Int: Any] = [:]
    lazy var stateDurations: [Int: Any] = [:]
    
    override open var state: JRefreshState {
        set(newState) {
            
            
            // 状态检查
            let oldState = self.state
            if oldState == newState {
                return
            }
            super.state = newState
            
            // 根据状态做事情
            if newState == .Refreshing {
                let image = stateImages[newState.hashValue] as? Array<UIImage>
                guard let images = image, images.count != 0 else {return}
                gifView.stopAnimating()
                gifView.isHidden = false
                if images.count == 1 { //单张图片
                    gifView.image = images.last
                } else {
                    gifView.animationImages = images
                    gifView.animationDuration = stateDurations[newState.hashValue] as? TimeInterval ?? 0.0
                    gifView.startAnimating()
                }
            } else if newState == .Idle || newState == .NoMoreData {
                gifView.stopAnimating()
                gifView.isHidden = true
            }
        }
        get {
            return super.state
        }
    }
}

extension GTRefreshAutoGifFooter {
    override open func prepare() {
        super.prepare()
        addSubview(gifView)
        // 初始化间距
        labelLeftInset = 20
    }
    override open func placeSubviews() {
        super.placeSubviews()
        
        if gifView.constraints.count > 0 {return}
        gifView.frame = bounds
        if refreshingTitleHidden {
            gifView.contentMode = .center
        } else {
            gifView.contentMode = .right
            gifView.width = width * 0.5 - stateLabel.textWidth() * 0.5 - labelLeftInset
        }
    }
}

//MARK: - 公共方法
extension GTRefreshAutoGifFooter {
    public func setImages(_ images: Array<UIImage>, _ duration: TimeInterval, _ state: JRefreshState) {
        stateImages[state.hashValue] = images
        stateDurations[state.hashValue] = duration
        // 根据图片设置控件的高度
        let image = images.first
        if image?.size.height ?? 0 > height {
            height = image?.size.height ?? 0
        }
    }
    public func setImages(_ images: Array<UIImage>, _ state: JRefreshState) {
        setImages(images, Double(images.count) * 0.1, state)
    }
}
