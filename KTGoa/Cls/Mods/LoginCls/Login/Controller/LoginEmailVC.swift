//
//  LoginEmailVC.swift
//  Golaa
//
//  Created by xiaoxuhui on 2024/5/7.
//

import UIKit

class LoginEmailVC: BasClasVC {
    
    private var remainingTime = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sets()
    }
    
    func sets() {
        
        view.addSubview(tipLabel)
        view.addSubview(otherBtn)
        view.addSubview(numCell)
        view.addSubview(codeCell)
        view.addSubview(numLabel)
        view.addSubview(codeLabel)
        view.addSubview(loginButton)
        
        numCell.addSubview(numField)
        numCell.addSubview(sendCodeBtn)
        codeCell.addSubview(codeField)
        
        tipLabel.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.top.equalTo(naviH+50)
            make.right.equalTo(otherBtn.snp.left).offset(-30)
        }
        
        otherBtn.snp.makeConstraints { make in
            make.size.equalTo(60)
            make.right.equalTo(-10)
            make.centerY.equalTo(tipLabel.snp.centerY)
        }
        
        numLabel.snp.makeConstraints { make in
            make.left.equalTo(tipLabel)
            make.top.equalTo(tipLabel.snp.bottom).offset(60)
        }
        
        numCell.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(55)
            make.top.equalTo(numLabel.snp.bottom).offset(10)
        }
        
        numField.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.right.equalTo(-40)
            make.height.equalTo(50)
            make.centerY.equalToSuperview()
        }
        
        sendCodeBtn.snp.makeConstraints { make in
            make.right.equalTo(-13)
            make.centerY.equalToSuperview()
        }
        
        codeLabel.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(numCell.snp.bottom).offset(28)
        }
        
        codeCell.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(55)
            make.top.equalTo(codeLabel.snp.bottom).offset(10)
        }
        
        codeField.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(50)
            make.centerY.equalToSuperview()
        }
        
        loginButton.snp.makeConstraints { make in
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.height.equalTo(50)
            make.bottom.equalTo(-30-safeAreaBt)
        }
    }
    
    //MARK: -
    //MARK: Lazy
    private lazy var tipLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFontMedium(24)
        label.textColor = .black.alpha(0.9)
        label.text = "emailLogin".loginLocalizable()
        return label
    }()
    
    private lazy var otherBtn: UIButton = {
        let button = UIButton()
        button.image(UIImage(named: "do_phone"))
        button.addTarget(self, action: #selector(otherClick), for: .touchUpInside)
        return button
    }()
    
    private lazy var numLabel: UILabel = {
        let label = UILabel()
        label.font = UIFontMedium(14)
        label.textColor = .hexStrToColor("#070803")
        label.text = "enterEmailAddress".loginLocalizable()
        return label
    }()
    
    private lazy var codeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFontMedium(14)
        label.textColor = .hexStrToColor("#070803")
        label.text = "enterEmailVerificationCode".loginLocalizable()
        return label
    }()
    
    private lazy var numField: UITextField = {
        let tf = UITextField()
        tf.textColor = .black
        tf.tintColor = .appColor
        tf.font = UIFontSemibold(16)
        tf.keyboardType = .emailAddress
        tf.placeholder = "pleaseEnterEmailNumber".loginLocalizable()
        tf.gt.setPlaceholderAttribute(font: UIFontReg(12), color: .hexStrToColor("#999999"))
        return tf
    }()
    
    private lazy var codeField: UITextField = {
        let tf = UITextField()
        tf.textColor = .black
        tf.tintColor = .appColor
        tf.font = UIFontSemibold(16)
        tf.keyboardType = .numberPad
        tf.placeholder = "pleaseEnterVerifNumber".loginLocalizable()
        tf.gt.setPlaceholderAttribute(font: UIFontReg(12), color: .hexStrToColor("#999999"))
        return tf
    }()
    
    private lazy var numCell: UIView = {
        let view = UIView()
        view.gt.setCornerRadius(16)
        view.backgroundColor = .xf2
        return view
    }()
    
    private lazy var codeCell: UIView = {
        let view = UIView()
        view.gt.setCornerRadius(16)
        view.backgroundColor = .xf2
        return view
    }()
    
    private lazy var sendCodeBtn: UIButton = {
        let button = UIButton()
        button.image(.loginSendCode)
        button.font(UIFontReg(12))
        button.textColor(.hexStrToColor("#2697FF"))
        button.addTarget(self, action: #selector(sendClick), for: .touchUpInside)
        return button
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.gt.setCornerRadius(12)
        button.textColor(.black)
        button.backgroundColor = .appColor
        button.setTitle("confirm".loginLocalizable(), for: .normal)
        button.addTarget(self, action: #selector(loginClick), for: .touchUpInside)
        return button
    }()
}

extension LoginEmailVC {
    
    @objc func loginClick() {
        let email: String = numField.text ?? ""
        let code: String = codeField.text ?? ""
        if !email.isValidEmail { return }
        LoginReq.loginEmail(email: email, code: code)
    }
    
    @objc func otherClick() {
        self.navigationController?.popViewController(animated: false)
        RoutinStore.push(.phoneLogin, animated: true)
    }
    
    @objc func sendClick(sender: UIButton) {
        let email: String = numField.text ?? ""
        LoginReq.sendMailCode(email, type: .login) { [weak self] isReally in
            if isReally {
                self?.updateRemainingTime()
            }
            self?.sendCodeBtn.isUserInteractionEnabled = !isReally
        }
    }
    
    private func updateRemainingTime() {
        
        remainingTime -= 1
        
        if remainingTime > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.updateRemainingTime()
            }
            sendCodeBtn.image(nil)
            sendCodeBtn.title("\(remainingTime)s")
            sendCodeBtn.isUserInteractionEnabled = false
        } else {
            remainingTime = 0
            print("Countdown finished.")
            sendCodeBtn.image(.loginSendCode)
            sendCodeBtn.title("")
            sendCodeBtn.isUserInteractionEnabled = true
        }
        
    }
}

