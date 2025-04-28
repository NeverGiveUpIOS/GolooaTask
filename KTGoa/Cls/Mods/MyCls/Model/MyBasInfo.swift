//
//  MyBasInfo.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/7/27.
//

import UIKit

struct MyKefuInfo: Codable {
    
    var code: Int = 0
    var data: MyKefuData?
    var status: String = ""
    
}

struct MyKefuData: Codable {
    /// 客服链接
    var url: String = ""
    
}
