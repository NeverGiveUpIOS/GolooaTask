//
//  GolPeizInfo.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/7/27.
//

import UIKit

struct GolPeizInfo: Codable {
    
    var code: Int = 0
    var data: GolPeizData?
    var status: String = ""
    
}

struct GolPeizData: Codable {
    /// 隐私政策H5地址
    var privacyPolicyUrl: String = ""
    /// 用户协议H5地址
    var userAgreementUrl: String = ""
}
