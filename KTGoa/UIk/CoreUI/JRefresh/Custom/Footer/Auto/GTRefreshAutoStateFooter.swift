//
//  JRefreshAutoStateFooter.swift
//  GTRefresh
//
//  Created by Lee on 2023/8/22.
//  Copyright © 2023年 KKK. All rights reserved.
//

import UIKit

open class GTRefreshAutoStateFooter: GTRefreshAutoFooter {
    
    //MARK: - 状态相关
    ///文字距离圈圈、箭头的距离
    public var labelLeftInset: CGFloat = JRefreshConst.labelLeftInset
    ///显示刷新状态的label
    public lazy var stateLabel: UILabel = {
        let label = UILabel.J_lable()
        return label
    }()
    ///隐藏刷新状态的文字
    public var refreshingTitleHidden: Bool = false
    ///所有状态对应的文字
    lazy var stateTitles: [Int: Any] = [:]
    
    override open var state: JRefreshState {
        set(newState) {
            // 状态检查
            let oldState = self.state
            if oldState == newState {
                return
            }
            super.state = newState
            
            if refreshingTitleHidden && newState == .Refreshing {
                stateLabel.text = nil
            } else {
                stateLabel.text = stateTitles[newState.hashValue] as? String
            }
        }
        get {
            return super.state
        }
    }
}
extension GTRefreshAutoStateFooter {
    /// 设置state状态下的文字
    public func setTitle(_ title: String?, _ state: JRefreshState) {
        guard let title = title else { return }
        stateTitles[state.hashValue] = title
        stateLabel.text = stateTitles[state.hashValue] as? String
    }
}
//MARK: - 重写父类的方法
extension GTRefreshAutoStateFooter {
    override open func prepare() {
        super.prepare()
        addSubview(stateLabel)
        // 初始化文字
        setTitle(JRefreshAutoFoot.refreshingText, .Refreshing)
        setTitle(JRefreshAutoFoot.noMoreDataText, .NoMoreData)
        setTitle(JRefreshAutoFoot.idleText, .Idle)
        
        // 监听label
        stateLabel.isUserInteractionEnabled = true
        stateLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(stateLabelClick)))
    }
    
    override open func placeSubviews() {
        super.placeSubviews()
        
        if stateLabel.constraints.count > 0 {
            return
        }
        // 状态标签
        stateLabel.frame = bounds
    }
}
extension GTRefreshAutoStateFooter {
    @objc fileprivate func stateLabelClick() {
        if state == .Idle {
            beginRefreshing()
        }
    }
}








