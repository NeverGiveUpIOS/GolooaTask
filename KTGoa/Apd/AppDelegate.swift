//
//  AppDelegate.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/7/23.
//

import UIKit
import IQKeyboardManagerSwift
import AppTrackingTransparency
import AppsFlyerLib

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: ScreB)
        LanguageTl.shared.changeLanguage(language: .portuguese)
        LoginTl.shared.window = window
        LoginTl.shared.makeRootModes()
        mm.registerWithOption()
        setup()
        GlobalHelper.shared.start()
        return true
    }
    
    func setup() {
        Networking.shared.startMonitoring()
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        registerAPNs()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        if #available(iOS 14, *) {
            AppsFlyerLib.shared().waitForATTUserAuthorization(timeoutInterval: 60)
            ATTrackingManager.requestTrackingAuthorization { _ in
                AppsFlyerLib.shared().start()
            }
        } else {
            AppsFlyerLib.shared().start()
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    /// 注册推送
    func registerAPNs() {
        UIApplication.gt.registerAPNsWithDelegate(self)
    }
    
    /// 关闭通知权限
    func unregister() {
        UIApplication.shared.unregisterForRemoteNotifications()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let  userInfo = notification.request.content.userInfo
        debugPrint("注册通知相关======userInfo：\(userInfo)")
        completionHandler([.badge, .sound, .alert])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }

}
