//
//  BasClasVC.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/7/23.
//

import UIKit

class BasClasVC: UIViewController, Routinable {
    
    var basNavbView: BasNavBarView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        setupNavView()
        setupWidgetLayout()
        addNotiObserver(self, #selector(networkStatusChange(noti:)), "NetworkStatusChange")
        addNotiObserver(self, #selector(onLanguageChange), "ChangeLanguageRelay")
        
    }
    
    /// 多语言切换
    @objc func onLanguageChange() {
        
    }
    
    /// 网路状态变化
    @objc func networkStatusChange(noti: NSNotification) {
        
    }
    
    /// 添加自定义导航栏
    func setupNavView() {
        basNavbView = BasNavBarView(frame: .init(x: 0, y: 0, width: screW, height: naviH))
        view .addSubview(basNavbView!)
        backItem(.init(named: "back_black"))
        
        if navigationController?.viewControllers.count ?? 0 == 1 {
            basNavbView?.backItem?.isHidden = true
        } else {
            basNavbView?.backItem?.isHidden = false
        }
        
        basNavbView?.backItem?.gt.handleClick { [weak self] button in
            self?.backPop()
        }
        
        basNavbView?.rightItem?.gt.handleClick { [weak self] button in
            self?.rightItemClick()
        }
    }
    
    /// 添加字控件
    func setupWidgetLayout() {
        
    }
    
    /// 返回
    func backPop() {
        gt.popToPreviousVC()
    }
    
    func rightItemClick() {
        
    }
    
    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return  .bottom
    }
    
    // MARK: - Routinable 路由协议
    func routerParam(param: Any?, router: RoutinRouter?) {
        
    }
    
    func routerDeinit() {
        debugPrint("内存已释放")
        removeNotiObserver(self)
    }
    
    deinit {
        removeNotiObserver(self)
        debugPrint("内存已释放")
    }
    
}

// MARK: - 导航设置
extension BasClasVC {
    
    /// 导航蓝颜色
    func navBagColor(_ color: UIColor) {
        basNavbView?.backgroundColor = color
    }
    /// 导航显隐
    func hiddenNavView(_ result: Bool) {
        basNavbView?.isHidden = result
    }
    
    /// navTitle
    func navTitle(_ text: String,
                  textColor: UIColor = .black,
                  font: UIFont = UIFontMedium(16)) {
        basNavbView?.navTitle?.text = text
        basNavbView?.navTitle?.textColor = textColor
        basNavbView?.navTitle?.font = font
        basNavbView?.navTitle?.sizeToFit()
    }
    
    /// 设置返回Item
    func backItem(_ image: UIImage?,
                  text: String = "",
                  textColor: UIColor = .black,
                  font: UIFont = UIFontReg(14)) {
        basNavbView?.backItem?.image(image)
        basNavbView?.backItem?.title(text)
        basNavbView?.backItem?.textColor(textColor)
        basNavbView?.backItem?.font(font)
        basNavbView?.backItem?.sizeToFit()
    }
    
    /// 设置RightItem
    func rightItem(_ image: UIImage?,
                   text: String = "",
                   textColor: UIColor = .black,
                   font: UIFont = UIFontReg(14)) {
        basNavbView?.rightItem?.isHidden = false
        basNavbView?.rightItem?.image(image)
        basNavbView?.rightItem?.title(text)
        basNavbView?.rightItem?.textColor(textColor)
        basNavbView?.rightItem?.font(font)
        basNavbView?.rightItem?.sizeToFit()
    }
    
}
