//
//  WKWebViewExt.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/7/25.
//

import UIKit
import WebKit

public extension GTBas where Base: WKWebView {
    
    func loadWebUrl(_ urlString: String?, additionalHttpHeaders: [String: String]? = nil) {
        guard let urlString = urlString,
              let urlStr = urlString.removingPercentEncoding as String?,
              let url = URL(string: urlStr) as URL?
        else {
           debugPrint("=========Web链接错误======")
            return
        }
        let cookie: String = "document.cookie = 'user=\("userValue")';"
        let cookieScri = WKUserScript(source: cookie, injectionTime: .atDocumentStart, forMainFrameOnly: false)
        let userContentCo = WKUserContentController()
        userContentCo.addUserScript(cookieScri)
        bas.configuration.userContentController = userContentCo
        
        var request = URLRequest(url: url)
        if let headFields: [AnyHashable : Any] = request.allHTTPHeaderFields {
            if headFields["user"] != nil {
            } else {
                request.addValue("user=\("userValue")", forHTTPHeaderField: "Cookie")
            }
        }
        additionalHttpHeaders?.forEach { (key, value) in
            request.addValue(value, forHTTPHeaderField: key)
        }
        bas.load(request as URLRequest)
    }
}
