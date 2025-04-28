//
//  WebContentScriptHandle.swift
//  Golaa
//
//  Created by duke on 2024/5/25.
//

import UIKit
import WebKit

class WebContentScriptHandle: NSObject {
    
    private var webView: WKWebView?
    
    func bind(webView: WKWebView) {
        self.webView = webView
    }
    
    func addScriptMethods(_ userContent: WKUserContentController) {
        WebContentScriptMethod.allCases.forEach({ userContent.add(self, name: $0.rawValue) })
    }
    
    func removeScriptMethods(_ userContent: WKUserContentController) {
        WebContentScriptMethod.allCases.forEach({ userContent.removeScriptMessageHandler(forName: $0.rawValue) })
    }
}

extension WebContentScriptHandle: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        debugPrint("------ message.name: \(message.name) ------")
        debugPrint("------ message.body: \(message.body) ------")
        let name = message.name
        let body = message.body as? String
        guard !name.isEmpty else {
            return
        }
        let model = WebContentModel.deserialize(from: body)
        guard let method = WebContentScriptMethod(rawValue: name) else {
            return
        }
        let dict = body?.jsonStringToDictionary() ?? [:]
        
        switch method {
        case .getUserInfo:
            getUserInfoToWeb()
            if let result = dict["hideNavigationBar"] as? Int, result == 1 {
                postNotiObserver("GTHideNavigationBarNoti")
            } else if let result = dict["isFullScreen"] as? Int, result == 1 {
                postNotiObserver("GtIsFullScreen")
            }
            if let result = dict["title"] as? String, !result.isEmpty {
                postNotiObserver("GtChangeWebTitle",result)
                
            }
        case .pushPage:
            guard let model = model, let jump = WebContentScriptJump(rawValue: model.jumpName) else {
                return
            }
            
            switch jump {
            case .payLianCustomer:
                RoutinStore.pushOnlineService()
            case .lianCustomer:
                RoutinStore.pushOnlineService()
            case .avarAuth:
                RoutinStore.push(.auth)
            case .userEdit:
                RoutinStore.push(.individualInfo)
            case .pay:
                RoutinStore.push(.buyCoin)
            case .payGold:
                RoutinStore.push(.buyCoin)
            case .payCoinRecord:
                RoutinStore.push(.coinRecord)
            case .appStore:
                // TODO: - 待完成
                guard let url = URL(string: "") else { return }
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            case .homeLiaoList:
                RoutinStore.dismissRoot(animated: false)
                RoutinStore.tabBarDidSelected(index: 1)
            case .userDes:
                RoutinStore.push(.ordinaryUserInfo)
            case .message:
                RoutinStore.navigator?.popToRootViewController(animated: false)
                guard let window = UIApplication.shared.delegate?.window else { return }
                if let tabbar = window?.rootViewController as? BasClasVC {
                    tabbar.tabBarController?.selectedIndex = 1
                }
            case .back:
                RoutinStore.navigator?.popViewController(animated: true)
            }
        case .back:
            RoutinStore.navigator?.popViewController(animated: true)
        case .invShare:
            guard let model = model else { return }
            if model.qrCo == "1" {
                 PosterShareAlert().show(model: model)
            } else {
                let pboard = UIPasteboard.general
                pboard.string = model.link
                ToastHud.showToastAction(message: "copySuccessful".homeLocalizable())
            }
        case .invFriShare:
            break // 暂无
        case .userLiao:
            guard let userId = dict["userId"] as? String else { return }
            RoutinStore.push(.singleChat, param: userId)
            FlyerLibHelper.log(.enterSingleTalkScreen, source: "0")
        case .refresh:
            if let info = dict["pageInfo"] as? String, info == "UserInfo" {
                // 刷新用户信息
                NotificationCenter.default.post(name: .userInfoUpdate, object: self)
            } else if let info = dict["pageInfo"] as? String, info == "refresh_recharge" {
                refresh()
            }
        case .updateEvent:
            guard let event = dict["event"] as? String else { return }
            let param = (dict["param"] as? String)?.jsonStringToDictionary() ?? [:]
            FlyerLibHelper.log(event, values: param)
            
            // Paymax 支付成功回调处理
            if event == FlyerLogEvent.payDepositResult.name,
               (param["result"] as? Int) == 1,
               let source = param["source"] as? Int {
                if source == 1 { // Paymax 支付保证金成功
                    RoutinStore.dismissRoot(animated: false)
                    RoutinStore.push(.publishComple)
                } else if source == 2 { // Paymax 补交保证金成功
                    RoutinStore.dismissRoot(animated: false)
                    RoutinStore.push(.publishComple)
                }
            }
            debugPrint("H5 - updateEvent: event = \(event), param = \(param)")
        case .openNewWos:
            debugPrint("H5 - openNewWos \(body ?? "")")
            if let url = body {
                RoutinStore.pushUrl(url)
            }
        }
    }
    
    func refresh() {
        let script = "init()"
        webView?.evaluateJavaScript(script) { (_, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    private func getUserInfoToWeb() {
        var params: [String: Any] = [:]
        params["Authorization"] = LoginTl.shared.token
        params["userId"] = LoginTl.shared.usrId
        params["appId"] = HeaderAppId
        params["appKey"] = "golaa"
        params["version"] = AppVersion
        params["lang"] = Curlanguage
        guard let arg = params.toJSON() else {
            return
        }
        webView?.evaluateJavaScript("getUserInfoFromApp('\(arg)')", completionHandler: { _, error in
            if let error = error {
                debugPrint(error.localizedDescription)
            }
        })
    }
}
