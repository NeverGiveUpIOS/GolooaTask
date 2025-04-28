//
//  GetTaskChatHomeItem.swift
//  Golaa
//
//  Created by duke on 2024/5/20.
//

import UIKit

class GetTaskChatHomeCell: UICollectionViewCell {
    
    var callBlock: CallBackStringBlock?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildUI() {
        gt.setCornerRadius(8)
        backgroundColor = .xf2
        addSubview(icon)
        addSubview(textField)
        
        icon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(17)
            make.width.height.equalTo(30)
        }
        
        textField.snp.makeConstraints { make in
            make.leading.equalTo(icon.snp.trailing).offset(26)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(-15)
        }
    }
    
    var model: GetTaskConfigItem?
    func bind(model: GetTaskConfigItem) {
        self.model = model
        icon.imageWithUrl(withURL: model.label)
        textField.text = model.text
    }
    
    private lazy var icon: UIImageView = {
        let img = UIImageView()
        img.gt.setCornerRadius(8)
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    lazy var textField: UITextField = {
        let text = UITextField()
        text.textColor = .black
        text.font = UIFontReg(12)
        text.placeholder = "https://"
        text.gt.setPlaceholderAttribute(font: UIFontReg(12), color: .hexStrToColor("#999999"))
        text.clearButtonMode = .whileEditing
        text.returnKeyType = .done
        text.keyboardType = .default
        text.delegate = self
        return text
    }()
}

extension GetTaskChatHomeCell: UITextFieldDelegate {
    func endEditTextField(_ textField: UITextField) {
        textField.resignFirstResponder()
        textField.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let text = self.textField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        self.callBlock?(text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditTextField(textField)
        return true
    }
}
