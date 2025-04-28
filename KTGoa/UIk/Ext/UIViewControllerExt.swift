//
//  UIViewControllerExt.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/7/23.
//

import UIKit

extension UIViewController: GTCompble {}

extension GTBas where Base: UIViewController {
    
    // MARK: - 获取当前控制器
    static func topCurController() -> UIViewController? {
        guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first, let rootVC = window.rootViewController  else {
            return nil
        }
        return topVC(rootVC)
    }
    
    //MARK: - 获取当前的keyWindow
    static var keyWindow: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.filter { $0.isKeyWindow }.first
        } else {
            return UIApplication.shared.keyWindow
        }
    }
    
    static func getStoryBoardVc(_ name: String, identifier: String) -> BasClasVC {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as? BasClasVC {
            return viewController
        } else {
            print("Failed to load MyViewController from the Main storyboard.")
            return BasClasVC()
        }
    }
    
    // MARK: --  push
    func pushViewController(_ controller:UIViewController) {
        DispatchQueue.main.async {
            let nav = UIViewController.gt.topCurController()?.navigationController
            nav?.pushViewController(controller, animated: true)
        }
    }
    
    // MARK: -  pop回上一个界面
    func popToPreviousVC() {
        guard let nav = self.bas.navigationController else { return }
        if let index = nav.viewControllers.firstIndex(of: self.bas), index > 0 {
            let vc = nav.viewControllers[index - 1]
            nav.popToViewController(vc, animated: true)
        }
    }
    
    // MARK: - 关闭当前控制器
    func disCurrentVC() {
        guard let nav = self.bas.navigationController else {
            bas.dismiss(animated: true, completion: nil)
            return
        }
        if nav.viewControllers.count > 1 {
            nav.popViewController(animated: true)
        } else if let _ = nav.presentingViewController {
            nav.dismiss(animated: true, completion: nil)
        }
    }
    
    private static func topVC(_ rootVC: UIViewController?) -> UIViewController? {
        if let presentedVC = rootVC?.presentedViewController {
            return topVC(presentedVC)
        }
        if let nav = rootVC as? UINavigationController,
           let lastVC = nav.viewControllers.last {
            return topVC(lastVC)
        }
        if let tab = rootVC as? UITabBarController,
           let selectedVC = tab.selectedViewController {
            return topVC(selectedVC)
        }
        return rootVC
    }
}
