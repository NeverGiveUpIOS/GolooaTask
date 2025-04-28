//
//  MineLayout.swift
//  Golaa
//
//  Created by Cb on 2024/5/14.
//

import Foundation

struct MineLayout {
    
    static let userAvatar = 60.0
    static let pouchHeight = 90.0
    static let benefitHeight = 100.0
    static let benefitLeading = 20.0

    static let headerHeight = 52.0
    static let headerLeading = leadingMargin + (padingLeading - leadingMargin)
    static let padingLeading = 15.0
    static let padingTop = 15.0
    static let leadingMargin = 6.5
    static let horCount = 3.0
    static let itemHeight = iconHeight + 6 + 17
    static let iconHeight = 36.0
    static let iconMinHeight = 24.0
    static let itemMinHeight = iconMinHeight + 6 + 17
    static let screenWidth = ceil(screW - 2 * padingLeading - 2 * leadingMargin)
    static let itemWidth = CGFloat(Int(screenWidth/horCount))
}
