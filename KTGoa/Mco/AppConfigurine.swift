//
//  AppDisposição.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/8/1.
//

let AppVersion = Bundle.gt.appVersion

var Curlanguage: String {
    return LanguageTl.shared.curLanguage.netValue
}

let HeaderAppId = "Golaa/iOS/\(AppVersion)/golaa"

/// 云信AppKey
var NimAppKey: String {
    switch NetAPI.curEnvironment {
    case .dev:
        return "420d5df97751319ed36815c1a4f17f7e"
    case .pro:
        return "420d5df97751319ed36815c1a4f17f7e"
    case .uat:
        return "420d5df97751319ed36815c1a4f17f7e"
    }
}

/// 云信推送name
var NimApnsCername: String {
    switch NetAPI.curEnvironment {
    case .dev:
        return "test-golaa"
    case .pro:
        return "prod-golaa"
    case .uat:
        return "uat-golaa"
    }
}

/// 云信消息环境变量，用于指向不同的抄送、第三方回调等配置
var NimMsgEnv: String {
    switch NetAPI.curEnvironment {
    case .dev:
        return "gl_test"
    case .pro:
        return "gl_prod"
    case .uat:
        return "gl_uat"
    }
}
