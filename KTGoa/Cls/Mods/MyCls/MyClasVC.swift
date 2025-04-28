//
//  MyClasVC.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/7/23.
//

import UIKit

class MyClasVC: BasClasVC {

    @IBOutlet weak var userHead: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var usrId: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hiddenNavView(true)
        view.backgroundColor = UIColorHex("#F2F2F2")
        
        userHead.imageWithUrl(withURL: LoginTl.shared.userInfo?.avatar ?? "")
        username.text = LoginTl.shared.userInfo?.showName
        usrId.text = "ID: \(LoginTl.shared.userInfo?.id ?? "")"
    }
    
    
    /// 联系客服
    @IBAction func conecKfClick(_ sender: Any) {
        if GlobalHelper.shared.serviceUrl.count <= 0 {
            ToastHud.showToastAction(message: "Obtendo informações do cliente, verifique mais tarde")
            return
        }
        gt.pushViewController(BasWebClasVC(GlobalHelper.shared.serviceUrl))
    }
    
    /// 意见反馈
    @IBAction func yjfkClick(_ sender: Any) {
        let vc = UIViewController.gt.getStoryBoardVc("MyClasVC", identifier: "MyFeedbackClasVC")
        gt.pushViewController(vc)
    }
    
    /// 更多设置
    @IBAction func moreSetClick(_ sender: Any) {
        let vc = UIViewController.gt.getStoryBoardVc("MyClasVC", identifier: "MyMoreSetClasVC")
        gt.pushViewController(vc)
    }
    
}
