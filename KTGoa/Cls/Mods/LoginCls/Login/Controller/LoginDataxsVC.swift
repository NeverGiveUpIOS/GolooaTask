//
//  LoginDataxsVC.swift
//  Golaa
//
//  Created by xiaoxuhui on 2024/5/7.
//

import UIKit

class LoginDataxsVC: BasClasVC {
    
    var gender: Gender = .body
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sets()
    }
    
    func sets() {
        view.addSubview(helloLabel)
        view.addSubview(welcoLabel)
        view.addSubview(nameLabel)
        view.addSubview(genderLabel)
        view.addSubview(codeLabel)
        
        view.addSubview(mrLabel)
        view.addSubview(msLabel)
        
        view.addSubview(nameField)
        view.addSubview(codeField)
        view.addSubview(doneButton)
        
        helloLabel.snp.makeConstraints { make in
            make.left.equalTo(30)
            make.top.equalTo(naviH+28)
        }
        
        welcoLabel.snp.makeConstraints { make in
            make.left.equalTo(30)
            make.top.equalTo(helloLabel.snp.bottom).offset(8)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(30)
            make.top.equalTo(welcoLabel.snp.bottom).offset(55)
        }
        
        nameField.snp.makeConstraints { make in
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.height.equalTo(52)
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
        }
        
        genderLabel.snp.makeConstraints { make in
            make.left.equalTo(30)
            make.top.equalTo(nameField.snp.bottom).offset(30)
        }
        
        mrLabel.snp.makeConstraints { make in
            make.left.equalTo(30)
            make.size.equalTo(CGSize(width: 100, height: 52))
            make.top.equalTo(genderLabel.snp.bottom).offset(10)
        }
        
        msLabel.snp.makeConstraints { make in
            make.centerY.equalTo(mrLabel)
            make.left.equalTo(mrLabel.snp.right).offset(16)
            make.size.equalTo(CGSize(width: 100, height: 52))
        }
        
        codeLabel.snp.makeConstraints { make in
            make.left.equalTo(30)
            make.top.equalTo(mrLabel.snp.bottom).offset(30)
        }
        
        codeField.snp.makeConstraints { make in
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.height.equalTo(52)
            make.top.equalTo(codeLabel.snp.bottom).offset(10)
        }
        
        doneButton.snp.makeConstraints { make in
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.height.equalTo(55)
            make.bottom.equalTo(-safeAreaBt-30)
        }
        
        
        switch LoginTl.shared.userInfo?.gender {
        case .body:
            genderClick(sender: mrLabel)
        case .girl:
            genderClick(sender: msLabel)
        case .none:
            break
        }
        nameField.text = LoginTl.shared.userInfo?.nickname ?? ""
    }
    
    // MARK: -
    // MARK: Lazy
    lazy var helloLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFontSemibold(26)
        label.text = "hello".loginLocalizable()
        return label
    }()
    
    lazy var welcoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFontReg(17)
        label.textColor = .hexStrToColor("#989898")
        label.text = "welcomeToGolaa".loginLocalizable()
        return label
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFontReg(14)
        label.textColor = .hexStrToColor("#060700")
        label.text = "myNickname".loginLocalizable()
        return label
    }()
    
    lazy var genderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFontReg(14)
        label.textColor = .hexStrToColor("#060700")
        label.text = "gender".loginLocalizable()
        return label
    }()
    
    lazy var codeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFontReg(14)
        label.textColor = .hexStrToColor("#060700")
        label.text = "invitationCode".loginLocalizable()
        return label
    }()
    
    lazy var nameField: UITextField = {
        let tf = UITextField()
        tf.gt.setCornerRadius(12)
        tf.font = UIFontReg(14)
        tf.layer.borderWidth = 1.5
        tf.gt.addLeftTextPadding(15)
        tf.textColor = .hexStrToColor("#070803")
        tf.layer.borderColor = UIColor.hexStrToColor("#EAEBEF").cgColor
        tf.delegate = self
        //  tf.rx.text.orEmpty.asDriver().drive(tf.rx.countLimit(20)).disposed(by: disposeBag)
        return tf
    }()
    
    lazy var codeField: UITextField = {
        let tf = UITextField()
        tf.gt.setCornerRadius(12)
        tf.font = UIFontReg(14)
        tf.layer.borderWidth = 1.5
        tf.gt.addLeftTextPadding(15)
        tf.textColor = .hexStrToColor("#070803")
        tf.layer.borderColor = UIColor.hexStrToColor("#EAEBEF").cgColor
        return tf
    }()
    
    lazy var mrLabel: UIButton = {
        let button = UIButton()
        button.gt.setCornerRadius(16)
        button.setImage(.loginMr.withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(genderClick), for: .touchUpInside)
        return button
    }()
    
    lazy var msLabel: UIButton = {
        let button = UIButton()
        button.gt.setCornerRadius(16)
        button.setImage(.loginMs.withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(genderClick), for: .touchUpInside)
        return button
    }()
    
    lazy var doneButton: UIButton = {
        let button = UIButton()
        button.gt.setCornerRadius(12)
        button.font(UIFontMedium(15))
        button.backgroundColor = .appColor
        button.textColor(.hexStrToColor("#070803"))
        button.title("confirm".loginLocalizable())
        button.addTarget(self, action: #selector(subClick), for: .touchUpInside)
        return button
    }()
}

extension LoginDataxsVC: UITextFieldDelegate {
    
    func endEditTextField(_ textField: UITextField) {
        textField.resignFirstResponder()
        textField.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditTextField(textField)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        guard string != hhf else {
            endEditTextField(textField)
            return false
        }
        return newText.count <= 20
    }
}

extension LoginDataxsVC {
    
    @objc func genderClick(sender: UIButton) {
        let iconNorColor: UIColor = .hexStrToColor("BABABA")
        let iconSelBodyColor: UIColor = .hexStrToColor("#3C8CF9")
        let iconSelGirlColor: UIColor = .hexStrToColor("F188C7")
        
        let bgNorColor: UIColor = .hexStrToColor("#F8F8F8")
        let bgNorBodyColor: UIColor = .hexStrToColor("#EDF7FF")
        let bgNorGirlColor: UIColor = .hexStrToColor("#FFECF8")
        
        if sender == mrLabel {
            gender = .body
            mrLabel.tintColor = iconSelBodyColor
            msLabel.tintColor = iconNorColor
            mrLabel.backgroundColor = bgNorBodyColor
            msLabel.backgroundColor = bgNorColor
            
        } else {
            gender = .girl
            mrLabel.tintColor = iconNorColor
            msLabel.tintColor = iconSelGirlColor
            mrLabel.backgroundColor = bgNorColor
            msLabel.backgroundColor = bgNorGirlColor
        }
    }
    
    @objc func subClick() {
        var pars: [String: Any] = [:]
        pars["gender"] = gender.rawValue
        pars["nickname"] = nameField.text
        pars["inviteCode"] = codeField.text
        FlyerLibHelper.log(.perfectDataClick, source: "\(LoginTl.shared.loginSource)")
        LoginTl.shared.editUsr(pars) { model in
            UserDefaults.gt.saveValueForKey(value: true, key: "UserIsSupplyCache")
            if let model = model {
                LoginTl.shared.savrUserInfo(model)
                LoginTl.shared.makeRootModes()
            }
        }
    }
}
