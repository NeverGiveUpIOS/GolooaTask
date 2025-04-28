//
//  RoutinStore.swift
//  Golaa
//
//  Created by Cb on 2024/5/15.
//

import Foundation

struct RoutinStore {

    // push跳转
    static func push(_ router: Router, param: Any? = nil, vc: UIViewController? = nil, animated: Bool = true) {
        let needFilter = filter(router)
        let result = pushAgoFilterRouter(router, needFilter: needFilter) == true ? false : animated
        guard let cType = router.vcType else { return }
        let vc = cType.init()
        vc.routerParam(param: param, router: router)
        if let nav = vc.navigationController {
            nav.pushViewController(vc, animated: result)
        } else {
            navigator?.pushViewController(vc, animated: result)
        }
    }
    
    // 返回上一页
    static func dismiss(animated: Bool = true) {
        navigator?.popViewController(animated: animated)
    }
    
    // 返回跟控制器
    static func dismissRoot(animated: Bool = true) {
        navigator?.popToRootViewController(animated: animated)
    }
    
    // tabBarController selectedIndex
    static func tabBarDidSelected(index: Int) {
        guard let window = UIApplication.shared.delegate?.window else { return }
        if let tabbar = window?.rootViewController as? BasTabBarVC {
            tabbar.selectedIndex = index
        }
    }
    
    // 需要过滤的页面集合
    private static let onceRouters: [Router] = [.groupChat, .singleChat]

    // MAKR: -
    // 获取导航控制器
    static var navigator: UINavigationController? {
        let topVC = getTopController()
        if let nav = topVC as? UINavigationController {
            return nav
        }
        return topVC.navigationController
    }
    
    // 是否需要过滤
    private static func filter(_ router: Router) -> Bool { onceRouters.contains(where: { $0 == router }) }

    // 跳转前处理需要过滤的路由
    private static func pushAgoFilterRouter(_ router: Router, needFilter: Bool = false) -> Bool? {
        if !needFilter { return nil }
        guard let routerType = router.vcType else { return nil }
        if let viewControllers = navigator?.viewControllers as? [Routinable] {
            var array = viewControllers
            for (index, i) in viewControllers.enumerated() {
                let type = type(of: i)
                if type == routerType {
                    i.routerDeinit()
                    array.remove(at: index)
                    navigator?.viewControllers = array
                    return true
                }
            }
        }
        return nil
    }
}
