//
//  UIApplicationExt.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/8/3.
//
import UIKit
import Photos

extension UIApplication: GTCompble {}

public extension GTBas where Base: UIApplication {

    /// 网络状态是否可用
    static func reachable() -> Bool {
        let data = NSData(contentsOf: URL(string: "https://www.baidu.com/")!)
        return (data != nil)
    }
    
    /// 检查用户是否打开系统推送权限
    // 判断用户是否允许推送
    static func checkPushNotification(completion: @escaping (_ authorized: Bool) -> ()) {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                if (settings.authorizationStatus == .authorized){
                    completion(true)
                } else {
                    completion(false)
                }
            }
        } else {
            let _autorized = UIApplication.shared.currentUserNotificationSettings?.types.contains(.alert) ?? false
            completion(_autorized)
        }
    }
    
    /// 注册APNs远程推送
    static func registerAPNsWithDelegate(_ delegate: Any) {
        if #available(iOS 10.0, *) {
            let options: UNAuthorizationOptions = [.alert, .badge, .sound]
            let center = UNUserNotificationCenter.current()
            center.delegate = (delegate as! UNUserNotificationCenterDelegate)
            center.requestAuthorization(options: options){ (granted: Bool, error:Error?) in
                if granted {
                    print("success")
                }
            }
            UIApplication.shared.registerForRemoteNotifications()
            //            center.delegate = self
        } else {
            // 请求授权
            let types: UIUserNotificationType = [.alert, .badge, .sound]
            let settings = UIUserNotificationSettings(types: types, categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            // 需要通过设备UDID, 和app bundle id, 发送请求, 获取deviceToken
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    @available(iOS 10.0, *)
    func addLocalUserNoti(trigger: AnyObject,
                          content: UNMutableNotificationContent,
                       identifier: String,
                   notiCategories: AnyObject,
                          repeats: Bool = true,
                          handler: ((UNUserNotificationCenter, UNNotificationRequest, NSError?)->Void)?) {
        
        var notiTrigger: UNNotificationTrigger?
        if let date = trigger as? NSDate {
            var interval = date.timeIntervalSince1970 - NSDate().timeIntervalSince1970
            interval = interval < 0 ? 1 : interval
            notiTrigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: repeats)
        } else if let components = trigger as? DateComponents {
            notiTrigger = UNCalendarNotificationTrigger(dateMatching: components as DateComponents, repeats: repeats)
        } else if let region = trigger as? CLCircularRegion {
            notiTrigger = UNLocationNotificationTrigger(region: region, repeats: repeats)
        }
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: notiTrigger)
        let center = UNUserNotificationCenter.current()
        
        center.add(request) { (error) in
            if error == nil {
                return
            }
            debugPrint("推送已添加成功")
        }
    }
    
    /// APP主动崩溃
    static func exitApp() {
        abort()
    }
}

public enum JKAppPermissionType {
    // 照相机
    case camera
    // 相册
    case album
    // 麦克风
    case audio
    // 定位
    case location
}
public extension GTBas where Base: UIApplication {
    
    /// 判断是否拥有权限，目前支持 照相机、相册、麦克风、定位，提示：这里判断是这些权限有没有被用户手动关闭
    /// - Parameter permission: 权限的类型
    /// - Returns: 结果
    static func isOpenPermission(_ permission: JKAppPermissionType) -> Bool {
        
        var result: Bool = true
        if permission == .camera || permission == .audio {
            // 是否开启相机和麦克风权限
            let authStatus = AVCaptureDevice.authorizationStatus(for: permission == .camera ? .video : .audio)
            result = authStatus != .restricted && authStatus != .denied
        } else if permission == .album {
            // 是否开启相册权限
            let authStatus = PHPhotoLibrary.authorizationStatus()
            result = authStatus != .restricted && authStatus != .denied
        } else if permission == .location {
            // 是否开启定位权限
            let authStatus = CLLocationManager.authorizationStatus()
            return authStatus != .restricted && authStatus != .denied
        }
        return result
    }
}
