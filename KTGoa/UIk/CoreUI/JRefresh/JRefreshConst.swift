//
//  JRefreshConst.swift
//  GTRefresh
//
//  Created by Lee on 2023/8/20.
//  Copyright © 2023年 KKK. All rights reserved.
//

import UIKit

public struct JRefreshConst {
    static let labelLeftInset: CGFloat = 25.0
    static let headerHeight: CGFloat = 54.0
    static let footerHeight: CGFloat = 44.0
    static let fastAnimationDuration = 0.25
    static let slowAnimationDuration = 0.4
}
public struct JRefreshKeyPath {
    static let contentOffset = "contentOffset"
    static let contentInset = "contentInset"
    static let contentSize = "contentSize"
    static let panState = "state"
}
public struct JRefreshHead {
    static let lastUpdateTimeKey = "JRefreshHeaderLastUpdateTimeKey".refreshLocalizable()
    static let idleText = "JRefreshHeaderIdleText".refreshLocalizable()
    static let pullingText = "JRefreshHeaderPullingText".refreshLocalizable()
    static let refreshingText = "JRefreshHeaderRefreshingText".refreshLocalizable()
    
    static let lastTimeText = "JRefreshHeaderLastTimeText".refreshLocalizable()
    static let dateTodayText = "JRefreshHeaderDateTodayText".refreshLocalizable()
    static let noneLastDateText = "JRefreshHeaderNoneLastDateText".refreshLocalizable()
}

public struct JRefreshAutoFoot {
    static let idleText = "JRefreshAutoFooterIdleText".refreshLocalizable()
    static let refreshingText = "JRefreshAutoFooterRefreshingText".refreshLocalizable()
    static let noMoreDataText = "JRefreshAutoFooterNoMoreDataText".refreshLocalizable()
}


public let JRefreshLabelFont = UIFont.boldSystemFont(ofSize: 14)
public let JRefreshLabelTextColor = UIColor(red: 90.0 / 255.0, green: 90.0 / 255.0, blue: 90.0 / 255.0, alpha: 1.0)
