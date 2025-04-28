//
//  LoginPhoneVC.swift
//  Golaa
//
//  Created by xiaoxuhui on 2024/5/7.
//

import UIKit

class LoginPhoneVC: BasClasVC {
    
    private var remainingTime = 60
    
    var area: String = "" {
        didSet {
            areaLabel.text = "+\(area)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        sets()
        
        if let value = GlobalHelper.shared.metas.phoneArea.first?.value {
            area = value
        } else {
            area = "852"
        }
    }
    
    func sets() {
        
        view.addSubview(tipLabel)
        view.addSubview(otherBtn)
        
        view.addSubview(numCell)
        view.addSubview(codeCell)
        
        view.addSubview(numLabel)
        view.addSubview(codeLabel)
        
        view.addSubview(loginButton)
        
        numCell.addSubview(areaLabel)
        numCell.addSubview(areaArrow)
        numCell.addSubview(areaButton)
        numCell.addSubview(areaLine)
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
        
        areaLabel.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.width.equalTo(40)
            make.centerY.equalToSuperview()
        }
        
        areaArrow.snp.makeConstraints { make in
            make.size.equalTo(8)
            make.centerY.equalToSuperview()
            make.left.equalTo(areaLabel.snp.right).offset(8)
        }
        
        areaLine.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 1, height: 16))
            make.left.equalTo(areaArrow.snp.right).offset(12)
        }
        
        areaButton.snp.makeConstraints { make in
            make.left.equalTo(0)
            make.height.equalTo(50)
            make.right.equalTo(areaLine)
            make.centerY.equalToSuperview()
        }
        
        numField.snp.makeConstraints { make in
            make.right.equalTo(-40)
            make.height.equalTo(50)
            make.centerY.equalToSuperview()
            make.left.equalTo(areaLine.snp.right).offset(22)
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
    
    lazy var tipLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFontMedium(24)
        label.textColor = .black.alpha(0.9)
        label.text = "loginWithPhoneNumber".loginLocalizable()
        return label
    }()
    
    lazy var otherBtn: UIButton = {
        let button = UIButton()
        button.image(UIImage(named: "do_email"))
        button.addTarget(self, action: #selector(otherClick), for: .touchUpInside)
        return button
    }()
    
    lazy var numLabel: UILabel = {
        let label = UILabel()
        label.font = UIFontMedium(14)
        label.textColor = .hexStrToColor("#070803")
        label.text = "enterPhoneNumber".loginLocalizable()
        return label
    }()
    
    lazy var codeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFontMedium(14)
        label.textColor = .hexStrToColor("#070803")
        label.text = "enterVerificationCode".loginLocalizable()
        return label
    }()
    
    lazy var numField: UITextField = {
        let tf = UITextField()
        tf.textColor = .black
        tf.tintColor = .appColor
        tf.font = UIFontSemibold(16)
        tf.keyboardType = .phonePad
        tf.placeholder = "pleaseEnterPhoneNumber".loginLocalizable()
        tf.gt.setPlaceholderAttribute(font: UIFontReg(12), color: .hexStrToColor("#999999"))
        return tf
    }()
    
    lazy var codeField: UITextField = {
        let tf = UITextField()
        tf.textColor = .black
        tf.tintColor = .appColor
        tf.font = UIFontSemibold(16)
        tf.keyboardType = .numberPad
        tf.placeholder = "pleaseEnterVerifNumber".loginLocalizable()
        tf.gt.setPlaceholderAttribute(font: UIFontReg(12), color: .hexStrToColor("#999999"))
        return tf
    }()
    
    lazy var numCell: UIView = {
        let view = UIView()
        view.gt.setCornerRadius(16)
        view.backgroundColor = .xf2
        return view
    }()
    
    lazy var codeCell: UIView = {
        let view = UIView()
        view.gt.setCornerRadius(16)
        view.backgroundColor = .xf2
        return view
    }()
    
    lazy var sendCodeBtn: UIButton = {
        let button = UIButton()
        button.image(.loginSendCode)
        button.font(UIFontReg(12))
        button.textColor(.hexStrToColor("#2697FF"))
        button.addTarget(self, action: #selector(sendClick), for: .touchUpInside)
        return button
    }()
    
    lazy var areaLine: UIView = {
        let view = UIView()
        view.backgroundColor = .hexStrToColor("#999999")
        return view
    }()
    
    lazy var areaArrow: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "login_ar")
        return view
    }()
    
    lazy var areaLabel: UILabel = {
        let label = UILabel()
        label.font = UIFontSemibold(16)
        label.textColor = .hexStrToColor("#070803")
        return label
    }()
    
    lazy var areaButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(alertClick), for: .touchUpInside)
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
    
    @objc func loginClick() {
        let area: String = area
        let code: String = codeField.text ?? ""
        let phone: String = numField.text ?? ""
        LoginReq.loginPhone(area: area, phone: phone, code: code)
    }
    
    @objc func otherClick() {
        self.navigationController?.popViewController(animated: false)
        RoutinStore.push(.emailLogin, animated: true)
    }
    
    @objc func alertClick() {
        
        view.endEditing(true)
        
        let datas = GlobalHelper.shared.metas.areaLabels
        
        if datas.count <= 0 {
            let pars = ["types": MetasType.apis]
            NetAPI.GlobalAPI.metas.reqToModelHandler(true, parameters: pars, model: GlobalMetas.self) { [weak self] model, _ in
                GlobalHelper.shared.metas = model
                self?.showPickView()
            } failed: { _ in
            }
            return
        }
        showPickView()
    }
    
    private func showPickView() {
        let models = GlobalHelper.shared.metas.phoneArea
        let datas = GlobalHelper.shared.metas.areaLabels
        let pickerView = CustomPickView(frame: ScreB, dataSource: datas, inComponent: 0)
        pickerView.show()
        pickerView.rowAndComponentCallBack = { [weak self] text in
            if let index = datas.firstIndex(where: { $0 == text }) {
                let model = models[index]
                self?.area = model.value
            }
        }
    }
    
    @objc func sendClick(sender: UIButton) {
        let area: String = area
        let phone: String = numField.text ?? ""
        LoginReq.sendPhoneCode(phone, area: area, type: .login) { isReally in
            if isReally {
                self.updateRemainingTime()
            }
            self.sendCodeBtn.isUserInteractionEnabled = !isReally
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
            sendCodeBtn.image(.loginSendCode)
            sendCodeBtn.title("")
            sendCodeBtn.isUserInteractionEnabled = true
        }
        
    }
}
