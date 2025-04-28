//
//  ConstantMoc.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/7/23.
//

import UIKit

let screW = UIScreen.main.bounds.width
let screH = UIScreen.main.bounds.height
let ScreB = UIScreen.main.bounds
let statusBarH  = UIDevice.gt.statusBarHeight
let tabBarH = UIDevice.gt.tabBarHeight
let naviH = UIDevice.gt.naviBarHeight
let safeAreaTp = UIDevice.gt.safeAreaTop
let safeAreaBt = UIDevice.gt.safeAreaBottom

let isIphoneX = UIDevice.gt.iPhoneX

let hhf = "\n"

/// scaleWidth
public func scaleWidth(_ width: CGFloat) -> CGFloat {
    return width * (screW / 375.0)
}

public typealias CallBackVoidBlock = () -> ()
public typealias CallBackIntBlock  = (_ index: Int) -> ()
public typealias CallBackStringBlock  = (_ string: String) -> ()
public typealias CallBackBoolBlock  = (_ result: Bool) -> ()
public typealias CallBackArrayBlock  = (_ array: [Any]) -> ()
public typealias CallBackDictBlock  = (_ dict: [String:Any]) -> ()
public typealias CallBackAnyBlock  = (_ any: Any) -> ()


extension Int {
    var dbw: CGFloat {
        scaleWidth(CGFloat(self))
    }
}

extension Double {
    var dbw: CGFloat {
        scaleWidth(CGFloat(self))
    }
}
