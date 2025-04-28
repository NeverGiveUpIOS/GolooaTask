//
//  WebContentViewContrller.swift
//  Golaa
//
//  Created by Cb on 2024/5/20.
//

import Foundation
import WebKit

class WebContentViewContrller: BasClasVC {
    private var scene: WebContentScene = .url("")
    private var url: String { scene.url }
    var isHideNavBar = false {
        didSet {
            basNavbView?.isHidden = isHideNavBar
            webView.snp.makeConstraints { make in
                make.top.equalTo(isHideNavBar ? 0 : naviH)
            }
            progressView.snp.makeConstraints { make in
                make.top.equalTo(isHideNavBar ? 0 : naviH)
            }
        }
    }
    private var isFullScreen = false {
        didSet {
            basNavbView?.isHidden = false
            basNavbView?.alpha = isFullScreen ? 0 : 1
            webView.snp.makeConstraints { make in
                make.top.equalTo(isFullScreen ? 0 : naviH)
            }
        }
    }
    private var progressOb: NSKeyValueObservation?
    
    override func routerParam(param: Any?, router: RoutinRouter?) {
        if let router = router, case RoutinRouter.webScene(let scene) = router {
            self.scene = scene
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configViews()
        configSubscribes()
        clearCache()
        configData()
        addNoti()
    }
    
    private func addNoti() {
        addNotiObserver(self, #selector(hideNavigationBarNoti), "GTHideNavigationBarNoti")
        addNotiObserver(self, #selector(isFullScreenNoti), "GtIsFullScreen")
        addNotiObserver(self, #selector(changeWebTitleNoti(noti:)), "GtChangeWebTitle")

    }
    
    @objc private func hideNavigationBarNoti() {
        isHideNavBar = true
    }
    
    @objc private func isFullScreenNoti() {
        isFullScreen = true
    }
    
    deinit {
        removeNotiObserver(self)
    }
    
    @objc private func changeWebTitleNoti(noti: NSNotification) {
        if let title = noti.object as? String {
            navTitle(title)
        }
        isFullScreen = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scriptHandle.addScriptMethods(userContent)
        if isHideNavBar {
            hiddenNavView(true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        scriptHandle.removeScriptMethods(userContent)
        if isHideNavBar {
            hiddenNavView(false)
        }
    }
    
    private func configViews() {
        configuration.userContentController = userContent
        view.addSubview(webView)
        view.addSubview(progressView)
        webView.snp.makeConstraints { make in
            make.top.equalTo(naviH)
            make.leading.trailing.bottom.equalToSuperview()
        }
        progressView.snp.makeConstraints { make in
            make.top.equalTo(naviH)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(3)
        }
    }
    
    private func configSubscribes() {
        progressOb = webView.observe(\.estimatedProgress, options: [.new]) { [weak self] _, _ in
            guard let self = self else { return }
            self.progressView.isHidden = false
            self.progressView.progress = Float(self.webView.estimatedProgress)
        }
    }
    
    private func configData() {
        var urlStr = url
        if !urlStr.contains("lang=") {
            if urlStr.contains("?") {
                urlStr.append("&lang=" + Curlanguage)
            } else {
                urlStr.append("?&lang=" + Curlanguage)
            }
        }
        
        if let url = URL(string: urlStr) {
            let request = URLRequest(url: url)
            webView.load(request)
            progressView.isHidden = false
        } else {
            if let encodedUrlString = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                if let url = URL(string: encodedUrlString) {
                    let request = URLRequest(url: url)
                    webView.load(request)
                    progressView.isHidden = false
                }
            }
        }
    }
    
    private func clearCache() {
        let date = Date(timeIntervalSince1970: 0)
        let dataTypes: Set<String> = [
            WKWebsiteDataTypeDiskCache,
            WKWebsiteDataTypeOfflineWebApplicationCache,
            WKWebsiteDataTypeMemoryCache,
            WKWebsiteDataTypeCookies
        ]
        WKWebsiteDataStore.default().removeData(ofTypes: dataTypes, modifiedSince: date) {
            
        }
    }
    
    // MARK: - 属性
    private lazy var scriptHandle: WebContentScriptHandle = {
        let tc = WebContentScriptHandle()
        tc.bind(webView: webView)
        return tc
    }()
    
    private lazy var userContent = WKUserContentController()
    
    private lazy var progressView: UIProgressView = {
        let pro = UIProgressView(progressViewStyle: .default)
        pro.trackTintColor = .white
        pro.progressTintColor = .appColor
        pro.progress = 0.01
        pro.isHidden = true
        return pro
    }()
    
    private let configuration: WKWebViewConfiguration = {
        let con = WKWebViewConfiguration()
        con.preferences.javaScriptEnabled = true
        con.preferences.javaScriptCanOpenWindowsAutomatically = true
        con.allowsInlineMediaPlayback = true
        con.mediaTypesRequiringUserActionForPlayback = []
        return con
    }()
    
    private lazy var webView: WKWebView = {
        let web = WKWebView(frame: .zero, configuration: configuration)
        web.allowsBackForwardNavigationGestures = true
        web.navigationDelegate = self
        if #available(iOS 11.0, *) {
            web.scrollView.contentInsetAdjustmentBehavior = .never
        }
        return web
    }()
}

extension WebContentViewContrller: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.isHidden = true
        if let title = scene.title {
            navTitle(title)
        } else {
            webView.evaluateJavaScript("document.title") { [weak self] title, _ in
                guard let title = title as? String else { return }
                self?.navTitle(title)
            }
        }
    }
}
