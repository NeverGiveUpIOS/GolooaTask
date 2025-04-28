//
//  BasWebClasVC.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/7/25.
//

import UIKit
import WebKit

class BasWebClasVC: BasClasVC {
    
    var webView: WKWebView?
    var progressView: UIProgressView?
    var userContentController: WKUserContentController = WKUserContentController()
    var urlString: String?
    
    init(_ weburl: String) {
        urlString = weburl
        super.init(nibName: nil, bundle: nil)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clearWebviewCache()
        addKvoJt()
        loadWebView()
    }
    
    override func setupWidgetLayout() {
        
        let userContentController = WKUserContentController()
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController
        configuration.allowsInlineMediaPlayback = true
        
        let preferences = WKPreferences()
        preferences.javaScriptCanOpenWindowsAutomatically = true
        preferences.javaScriptEnabled = true
        preferences.minimumFontSize = 10.0
        configuration.preferences = preferences
        
        webView = WKWebView(frame: .init(x: 0, y: naviH, width: screW, height: screH - naviH), configuration: configuration)
        webView?.uiDelegate = self
        webView?.navigationDelegate = self
        webView?.scrollView.delegate = self
        
        self.userContentController = configuration.userContentController
        view.addSubview(webView!)
        
        progressView = UIProgressView(frame: .init(x: 0, y: 0, width: screW, height: 1))
        progressView?.progressTintColor = .clear
        progressView?.transform = CGAffineTransform(scaleX: 1.0, y: 0.5)
        progressView?.trackTintColor = UIColorHex("#FFDA00")
        webView?.addSubview(progressView!)
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "title" {
            if (object as? AnyObject) === webView {
                if (basNavbView?.navTitle?.text?.count ?? 0) == 0 {
                    navTitle(change?[NSKeyValueChangeKey.newKey] as? String ?? "")
                }
            }
        }
        else if keyPath == "estimatedProgress" {
            progressView?.setProgress(Float((webView?.estimatedProgress ?? 0)), animated: true)
            progressView?.setProgress(Float((webView?.estimatedProgress ?? 0)), animated: true)
            progressView?.isHidden = webView?.estimatedProgress == 1
        }
    }
    
    deinit {
        webView?.removeObserver(self, forKeyPath: "title")
        webView?.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension BasWebClasVC {
    
    func loadWebView() {
        guard let tUrl = urlString else { return }
        print("webView的链接=====:\(tUrl)")
        webView?.gt.loadWebUrl(tUrl)
    }
    
    private func addKvoJt() {
        webView?.addObserver(self, forKeyPath: "title", options: [.new], context: nil)
        webView?.addObserver(self, forKeyPath: "estimatedProgress", options: [.new], context: nil)
    }
    
    private func clearWebviewCache() {
        let websiteDataTypes = WKWebsiteDataStore.allWebsiteDataTypes()
        let dateFrom = NSDate(timeIntervalSince1970: 0)
        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes, modifiedSince: dateFrom as Date) {
        }
    }
    
}

extension BasWebClasVC: WKUIDelegate, WKNavigationDelegate, UIScrollViewDelegate {
    
    // WKUIDelegate
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    // WKNavigationDelegate
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView?.isHidden = true
        if self.basNavbView?.navTitle?.text?.count == 0 {
            navTitle(webView.title ?? "")
        }
    }
    
}
