//
//  JRefreshFooter.swift
//  GTRefresh
//
//  Created by Lee on 2023/8/22.
//  Copyright © 2023年 KKK. All rights reserved.
//

import UIKit

open class GTRefreshFooter: GTRefreshComponent {
    ///忽略多少scrollView的contentInset的bottom
    public var ignoredScrollViewContentInsetBottom: CGFloat = 0
    //MARK: - 创建footer方法
    public class func footerWithRefreshingBlock(_ refreshingBlock: @escaping Block) -> GTRefreshFooter {
        
        let cmp = self.init()
        cmp.refreshingBlock = refreshingBlock
        return cmp
    }
}

extension GTRefreshFooter {
    override open func prepare() {
        super.prepare()
        // 设置自己的高度
        height = JRefreshConst.footerHeight
    }
}
//MARK: - 公共方法
extension GTRefreshFooter {
    public func endRefreshingWithNoMoreData() {
        DispatchQueue.main.async {[weak self] in
            self?.state = .NoMoreData
        }
    }
    public func resetNoMoreData() {
        DispatchQueue.main.async {[weak self] in
            self?.state = .Idle
        }
    }
}









