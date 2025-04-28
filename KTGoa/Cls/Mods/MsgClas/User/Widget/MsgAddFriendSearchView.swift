//
//  MsgAddFriendSearchView.swift
//  Golaa
//
//  Created by chenkaisong on 2024/5/20.
//

import UIKit

public typealias MsgAddFriendSearchBlock  = (_ string: String, _ isClear: Bool) -> ()

class MsgAddFriendSearchView: UIView, UITextFieldDelegate {
        
    var isClearText = false
    var callBlock: MsgAddFriendSearchBlock?
    var inputText = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(textField)
        textField.snp.makeConstraints { make in
            make.leading.equalTo(15)
            make.trailing.equalTo(-54)
            make.height.equalTo(34)
            make.top.equalTo(7)
            make.bottom.equalTo(-7)
        }
        
        addSubview(clearButton)
        clearButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.trailing.equalTo(-15)
            make.centerY.equalTo(textField)
        }
    }
    
    func setupLeftView() {
        textField.gt.addLeftIcon(.msgAddSearch, leftViewFrame: .init(x: 0, y: 0, width: 35, height: 30), imageSize: .init(width: 20, height: 20))
    }
    
    func setupPlacehold(_ text: String) {
        textField.placeholder = text
        textField.gt.addLeftTextPadding(10)
    }
    
    func setupClearImage(_ image: UIImage?) {
        clearButton.image(image)
        clearButton.image(image,.highlighted)
        
        if image == nil {
            textField.snp.remakeConstraints { make in
                make.leading.equalTo(0)
                make.trailing.equalTo(0)
                make.height.equalTo(34)
                make.width.equalTo(screW - 135)
                make.top.equalTo(7)
                make.bottom.equalTo(-7)
            }
        }
    }
    
    func endEditTextField() {
        textField.resignFirstResponder()
        textField.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        callBlock?(inputText, false)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        inputText = (currentText as NSString).replacingCharacters(in: range, with: string)
        if inputText.count <= 0 {
            callBlock?("", false)

        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditTextField()
        return true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var textField: UITextField = {
        let text =  UITextField()
        text.font = UIFontReg(13)
        text.textColor = UIColorHex("#000000")
        text.gt.setCornerRadius(8)
        text.backgroundColor = UIColorHex("#F2F2F2")
        text.returnKeyType = .search
        text.delegate = self
        text.placeholder = "searchNicknameuserId".msgLocalizable()
        return text
    }()

    lazy var clearButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(.msgAddClear, for: .normal)
        button.setImage(.msgAddClear, for: .highlighted)
        button.gt.handleClick { [weak self] _ in
            self?.textField.text = ""
            self?.callBlock?("", true)
        }
        return button
    }()
        
}
