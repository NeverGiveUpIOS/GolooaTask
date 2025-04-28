//
//  EmLoginViewController.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/7/24.
//

import UIKit

class EmLoginViewController: BasClasVC {
    
    @IBOutlet weak var emTextField: UITextField!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var getCode: UIButton!
    
    private var remainingTime = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func getCodeClick(_ sender: Any) {
        if emTextField.text?.count ?? 0 <= 0 {
            ToastHud.showToastAction(message: "por favor insira seu e-mail")
            return
        }
        
        getLoginEmCode()
    }
    
    @IBAction func combtnClick(_ sender: Any) {
        
        if emTextField.text?.count ?? 0 <= 0 {
            ToastHud.showToastAction(message: "por favor insira seu e-mail")
            return
        }
        
        if codeTextField.text?.count ?? 0 <= 0 {
            ToastHud.showToastAction(message: "Por favor insira o código de verificação de e-mail")
            return
        }
        
//         LoginReq.loginEmail(email: emTextField.text ?? "", code: codeTextField.text ?? "")
        LoginReq.loginPhone(area: "86", phone: "18208542187", code: "651234")
    }
    
    private func getLoginEmCode() {
        LoginReq.sendMailCode(emTextField.text ?? "", type: .login) { [weak self] isReally in
            self?.updateRemainingTime()
        }
    }

    private func updateRemainingTime() {

        remainingTime -= 1

        if remainingTime > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.updateRemainingTime()
            }
            getCode.image(nil)
            getCode.title("\(remainingTime)s")
            getCode.isUserInteractionEnabled = false
        } else {
            remainingTime = 0
            print("Countdown finished.")
            getCode.image(.loginEmGetCode)
            getCode.title("")
            getCode.isUserInteractionEnabled = true
        }

    }
        
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.gt.keyboardEnd()
    }
    
}
