//
//  GroupEditNameController.swift
//  Golaa
//
//  Created by xiaoxuhui on 2024/5/24.
//

import UIKit

class GroupEditNameController: BasClasVC {
    
    var groupId: String = ""
    var nameDes: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navTitle("groupName".msgLocalizable())
        buildUI()
    }
    
    
    func buildUI() {
        view.addSubview(textField)
        view.addSubview(completeBtn)
        
        textField.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(50)
            make.top.equalTo(naviH+30)
        }
        
        completeBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 240, height: 50))
            make.top.equalTo(textField.snp.bottom).offset(50)
        }
    }
    
    // MARK: -
    // MARK: Lazy
    private lazy var textField: UITextField = {
        let text = UITextField()
        text.gt.setCornerRadius(8)
        text.tintColor = .appColor
        text.font = UIFontReg(14)
        text.gt.addLeftTextPadding(15)
        text.backgroundColor = .xf2
        text.delegate = self
        return text
    }()
    
    private lazy var completeBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.gt.setCornerRadius(8)
        btn.textColor(.black)
        btn.font(UIFontSemibold(15))
        btn.backgroundColor = .appColor.alpha(0.6)
        btn.isUserInteractionEnabled = false
        btn.title("confirm".globalLocalizable())
        btn.addTarget(self, action: #selector(completeClick), for: .touchUpInside)
        return btn
    }()
    
    @objc func completeClick() {
        GroupReq.updateGroup(groupId, name: nameDes) { [weak self] error in
            if error == nil {
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}

extension GroupEditNameController: UITextFieldDelegate {
    
    func endEditTextField() {
        textField.resignFirstResponder()
        textField.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        nameDes = (currentText as NSString).replacingCharacters(in: range, with: string)
        completeBtn.backgroundColor = nameDes.count <= 0 ? .appColor.alpha(0.6) : .appColor
        completeBtn.isUserInteractionEnabled = nameDes.count > 0
        return nameDes.count <= 20
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditTextField()
        return true
    }
}
