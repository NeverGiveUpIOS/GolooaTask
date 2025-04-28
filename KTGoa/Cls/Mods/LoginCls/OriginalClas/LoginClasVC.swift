//
//  LoginClasVC.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/7/23.
//

import UIKit

class LoginClasVC: BasClasVC {
    
    var isAgree = false
        
    override func viewDidLoad() {
        super.viewDidLoad()
//        getPeizComReq()
    }

//    private func getPeizComReq() {
//        NetBasAPI.ReqAPI.getPeizComReq.getRequest(responseType: GolPeizInfo.self) { result in
//            switch result {
//            case .success(let golPeizInfo):
//                guard let golPeizData = golPeizInfo.data else { return  }
////                LoginTl.shared.golPeizData = golPeizData
//                break
//            case .failure(_):
//                break
//            }
//        }
//    }
    
    @IBAction func emLoginClick(_ sender: UIButton) {
        
        if !isAgree {
            ToastHud.showToastAction(message: "Concordo com o [Termo de Uso] e a [Política de Privacidade]")
            return
        }
        
        let vc = UIViewController.gt.getStoryBoardVc("LoginClasVC", identifier: "EmLogin")
        gt.pushViewController(vc)
        
    }
    
    //
    @IBAction func agreeBtnClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        isAgree = sender.isSelected
    }
    
    /// 用户协议
    @IBAction func userProClick(_ sender: Any) {
        if GlobalHelper.shared.dataConfigure.userAgreementUrl.count <= 0 {
            gt.pushViewController(BasWebClasVC("https://oss.tttaboo.com/h5/agreement/agree.html"))
            return
        }
        
        gt.pushViewController(BasWebClasVC(GlobalHelper.shared.dataConfigure.userAgreementUrl))
    }
    
    /// 隐私政策
    @IBAction func yspriClick(_ sender: Any) {
        if GlobalHelper.shared.dataConfigure.privacyPolicyUrl.count <= 0 {
            gt.pushViewController(BasWebClasVC("https://oss.tttaboo.com/h5/agreement/privacy.html"))
            return
        }
    
        gt.pushViewController(BasWebClasVC(GlobalHelper.shared.dataConfigure.privacyPolicyUrl))
    }
    
    
}
