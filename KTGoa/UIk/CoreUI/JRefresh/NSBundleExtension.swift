//
//  NSBundleExtension.swift
//  GTRefresh
//
//  Created by Lee on 2023/8/21.
//  Copyright © 2023年 KKK. All rights reserved.
//

import UIKit

public extension Bundle {
    class func refreshBunle() -> Bundle {
        return Bundle(path: Bundle(for: GTRefreshComponent.self).path(forResource: "JRefresh", ofType: "bundle")!)!
    }
    
    class func arrowImage() -> UIImage {
        return UIImage(contentsOfFile: refreshBunle().path(forResource: "arrow@2x", ofType: "png")!)!.withRenderingMode(.alwaysTemplate)
    }
    
    class func localizedString(_ key: String) -> String {
        return localizedString(key, nil)
    }
    class func localizedString(_ key: String, _ value: String?) -> String {
        var language = NSLocale.preferredLanguages.first ?? ""
        if language.hasPrefix("en") {
            language = "en"
        } else if language.hasPrefix("zh") {
            if (language.range(of: "Hans") != nil) {
                language = "zh-Hans"
            } else {
                language = "zh-Hant"
            }
        } else {
            language = "en"
        }
        let bundle = Bundle(path: refreshBunle().path(forResource: language, ofType: "lproj")!)
        let value = bundle?.localizedString(forKey: key, value: value, table: nil)
        return Bundle.main.localizedString(forKey: key, value: value, table: nil)
    }
}
