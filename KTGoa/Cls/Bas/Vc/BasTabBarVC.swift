//
//  BasTabBarVC.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/7/23.
//

import UIKit

class BasTabBarVC: UITabBarController {

    private lazy var msgClas = BasNavgVC(rootViewController: MessageViewController())

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
        tabBar.isTranslucent = false
        tabBar.barTintColor =  .white
        tabBar.backgroundColor = .white
        
        addControllers()
        mm.unReadMsgDelegate = self
        setups()
    }
    
    private func setups() {
        // 登录成功后的一些初始化配置
        IAPHelper.shared.setup()
        // 加载及保存用户信息
        LoginTl.shared.getCurUserInfo { usr in
        }
    }
    
    private func addControllers() {
        let homeClas = BasNavgVC(rootViewController: HomeViewController())
        // let myVc = UIViewController.gt.getStoryBoardVc("MyClasVC", identifier: "MyClasVC")
        let MyClas = BasNavgVC(rootViewController: MineViewController())
        self.setViewControllers([homeClas, msgClas, MyClas], animated: true)
        
        homeClas.hidesBottomBarWhenPushed = false
        homeClas.tabBarItem.image = .homeNol.withRenderingMode(.alwaysOriginal)
        homeClas.tabBarItem.selectedImage = .homeSel.withRenderingMode(.alwaysOriginal)
        homeClas.tabBarItem.tag = 0
        
        msgClas.hidesBottomBarWhenPushed = false
        msgClas.tabBarItem.image = .msgNol.withRenderingMode(.alwaysOriginal)
        msgClas.tabBarItem.selectedImage = .msgSel.withRenderingMode(.alwaysOriginal)
        msgClas.tabBarItem.tag = 1
        
        MyClas.hidesBottomBarWhenPushed = false
        MyClas.tabBarItem.image = .myNol.withRenderingMode(.alwaysOriginal)
        MyClas.tabBarItem.selectedImage = .mySel.withRenderingMode(.alwaysOriginal)
        MyClas.tabBarItem.tag = 2
    }
}

extension BasTabBarVC : UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
}

extension BasTabBarVC: NimUnReadMsgDelegate {
    
    func unReadNumber(_ count: Int) {
        if count > 0 {
            msgClas.tabBarItem.badgeValue = count > 99 ? "99+" : "\(count)"
            msgClas.tabBarItem.badgeColor = .red
        } else {
            msgClas.tabBarItem.badgeValue = nil
            msgClas.tabBarItem.badgeColor = .clear
        }
        
        DispatchQueue.main.async {
            if #available(iOS 16.0, *) {
                UNUserNotificationCenter.current().setBadgeCount(count, withCompletionHandler: { error in
                })
            } else {
                UIApplication.shared.applicationIconBadgeNumber = count
            }
        }
    }
}
