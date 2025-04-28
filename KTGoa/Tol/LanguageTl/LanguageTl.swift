//
//  LanguageTl.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/8/1.
//

import UIKit

class LanguageTl {
    
    static let shared = LanguageTl()
        
    init() {
        if let value = UserDefaults.standard.string(forKey: CacheKey.curLang) {
            let type = LanguageType.caseLangValue(value)
//            if type != curLanguage {
                changeLanguage(language: type)
//            }
        } else {
            // 更新语言资源文件
            updateLanguageBundle()
        }
    }
    
    // 修改语言
    func changeLanguage(language: LanguageType) {
        self.curLanguage = language
        updateLanguageBundle()
        // 发送语言更新通知
        postNotiObserver("ChangeLanguageRelay")
        UserDefaults.standard.set(language.netValue, forKey: CacheKey.curLang)
        UserDefaults.standard.synchronize()
    }
    
    // 修改bundle资源
    private func updateLanguageBundle() {
        guard let path = Bundle.main.path(forResource: curLanguage.lprojValue, ofType: "lproj") else { return }
        guard let bundle = Bundle(path: path) else { return }
        languageBundle = bundle
    }
    
    // MAKR: - 属性
    // 当前语言
    private(set) var curLanguage: LanguageType = .portuguese
    
    // 当前语言资源文件
    private var languageBundle: Bundle = .main
    
}


fileprivate extension LanguageTl {
    
    enum Modules {
        case home
        case message
        case mine
        case login
        case global
        case refresh

        var rawValue: String {
            switch self {
            case .home:
                return "Home"
            case .message:
                return "Message"
            case .mine:
                return "Mine"
            case .login:
                return "Login"
            case .global:
                return "Global"
            case .refresh:
                return "Refresh"
            }
        }
        
        // 国际化文字获取
        func value(_ key: String, content: String? = nil) -> String {
            let result = NSLocalizedString(key, tableName: rawValue, bundle: LanguageTl.shared.languageBundle, value: "", comment: "")
            if let content = content {
                return String(format: result, content)
            }
            return result
        }
        
        func value(_ key: String, args: any CVarArg...) -> String {
            let result = NSLocalizedString(key, tableName: rawValue, bundle: LanguageTl.shared.languageBundle, value: "", comment: "")
            return String(format: result, args)
        }
    }

}


extension String {
    func homeLocalizable(_ value: String? = nil) -> String {
        LanguageTl.Modules.home.value(self, content: value)
    }
    
    func msgLocalizable(_ value: String? = nil) -> String {
        LanguageTl.Modules.message.value(self, content: value)
    }
    
    func meLocalizable(_ value: String? = nil) -> String {
        LanguageTl.Modules.mine.value(self, content: value)
    }
    
    func loginLocalizable(_ value: String? = nil) -> String {
        LanguageTl.Modules.login.value(self, content: value)
    }
    
    func globalLocalizable(_ value: String? = nil) -> String {
        LanguageTl.Modules.global.value(self, content: value)
    }
    
    func refreshLocalizable(_ value: String? = nil) -> String {
        LanguageTl.Modules.refresh.value(self, content: value)
    }
    
    // 新增 多个参数 传参
    
    func homeLocalizable(_ args: any CVarArg...) -> String {
        LanguageTl.Modules.home.value(self, args: args)
    }
    
    func msgLocalizable(_ args: any CVarArg...) -> String {
        LanguageTl.Modules.message.value(self, args: args)
    }
    
    func meLocalizable(_ args: any CVarArg...) -> String {
        LanguageTl.Modules.mine.value(self, args: args)
    }
    
    func loginLocalizable(_ args: any CVarArg...) -> String {
        LanguageTl.Modules.login.value(self, args: args)
    }
    
    func globalLocalizable(_ args: any CVarArg...) -> String {
        LanguageTl.Modules.login.value(self, args: args)
    }
}
