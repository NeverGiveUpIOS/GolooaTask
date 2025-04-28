//
//  PublisherInfoController.swift
//  Golaa
//
//  Created by xiaoxuhui on 2024/6/3.
//

import UIKit

class PublisherInfoController: BasClasVC {
    
    var model: UserRsaPublic?

    override func viewDidLoad() {
        super.viewDidLoad()
        navTitle("publisherInformation".meLocalizable())
        setupCoder()
        setupAction()
        request()
        reloadUsr()
    }
    
    func setupCoder() {
        view.addSubview(titleLabel)
        view.addSubview(desLabel)
        view.addSubview(arrowIcon)
        view.addSubview(pubLabel)
        view.addSubview(textValue)
        view.addSubview(editIcon)
        view.addSubview(placeholderLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(15)
            make.top.equalTo(naviH+25)
        }
        
        desLabel.snp.makeConstraints { make in
            make.leading.equalTo(15)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
        
        arrowIcon.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.trailing.equalTo(-15)
            make.centerY.equalTo(desLabel)
        }
        
        pubLabel.snp.makeConstraints { make in
            make.leading.equalTo(15)
            make.top.equalTo(desLabel.snp.bottom).offset(35)
        }
        
        textValue.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.top.equalTo(pubLabel.snp.bottom).offset(10)
        }
        
        editIcon.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.bottom.trailing.equalTo(textValue).offset(-15)
        }
        
        placeholderLabel.snp.makeConstraints { make in
            make.top.equalTo(textValue.snp.top).offset(16)
            make.trailing.equalTo(textValue.snp.trailing).offset(-16)
            make.leading.equalTo(textValue.snp.leading).offset(15)
        }
    }
 
    func setupAction() {
        arrowIcon.gt.addGestureTap { _ in
            RoutinStore.pushUrl(self.model?.doc ?? "")
        }
        editIcon.gt.addGestureTap { [weak self] _ in
            self?.showPublisher()
        }
        textValue.gt.addGestureTap { [weak self] _ in
            self?.showPublisher()
        }
    }
    
    func showPublisher() {
        let value = model?.key ?? ""
        PublisherAlertView.show(contents: value) { string in
            if !string.isBlank, (string != self.model?.key) {
                UserReq.rsaSave(string) { error in
                    if error == nil {
                        self.request()
                        LoginTl.shared.getCurUserInfo { _ in
                            self.reloadUsr()
                        }
                    }
                }
            }
        }
    }
    
    func request() {
        UserReq.rsaPublic { model, _ in
            self.model = model
            self.reload()
        }
    }
    
    func reload() {
        guard let model = model else { return }
        textValue.text = model.key
    }
    
    func reloadUsr() {
        let hasRsa = (LoginTl.shared.userInfo?.hasRsa ?? false)
        editIcon.isHidden = !hasRsa
        if hasRsa {
            textValue.snp.remakeConstraints { make in
                make.height.equalTo(120)
                make.leading.equalTo(15)
                make.trailing.equalTo(-15)
                make.top.equalTo(pubLabel.snp.bottom).offset(10)
            }
        } else {
        
            textValue.snp.remakeConstraints { make in
                make.height.equalTo(50)
                make.leading.equalTo(15)
                make.trailing.equalTo(-15)
                make.top.equalTo(pubLabel.snp.bottom).offset(10)
            }
        }
    }
    
    // MARK: -
    // MARK: Lazy
    private lazy var titleLabel: UILabel = {
        let lab = UILabel()
        lab.gt.setCornerRadius(8)
        lab.textColor = .black
        lab.font = UIFontSemibold(15)
        lab.text = "quickStart".meLocalizable()
        return lab
    }()
    
    private lazy var arrowIcon: UIImageView = {
        let img = UIImageView()
        img.image = .groupMemberNext
        img.isUserInteractionEnabled = true
        return img
    }()
    
    private lazy var editIcon: UIImageView = {
        let img = UIImageView()
        img.image = .groupEditName
        img.isUserInteractionEnabled = true
        return img
    }()

    private lazy var desLabel: UILabel = {
        let lab = UILabel()
        lab.gt.setCornerRadius(8)
        lab.textColor = .x3
        lab.font = UIFontReg(12)
        lab.text = "rsaPublicKeyConfiguration".meLocalizable()
        return lab
    }()
    
    private lazy var pubLabel: UILabel = {
        let lab = UILabel()
        lab.gt.setCornerRadius(8)
        lab.textColor = .black
        lab.font = UIFontSemibold(15)
        lab.text = "rsaPublicKey".msgLocalizable()
        return lab
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.hexStrToColor("#999999")
        lab.font = UIFontReg(12)
        lab.numberOfLines = 0
        lab.text = "veryImportantPleaseConfigureTheRsa".meLocalizable()
        return lab
    }()
    
    private lazy var textValue: UITextView = {
        let text = UITextView()
        text.gt.setCornerRadius(8)
        text.textColor = .x9
        text.backgroundColor = .xf2
        text.isUserInteractionEnabled = false
        text.font = .init(name: "Menlo", size: 12)
        text.contentInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        text.delegate = self
        return text
    }()
    
}

extension PublisherInfoController: UITextViewDelegate {
    
       func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
           let currentText = textView.text ?? ""
           let newText = (currentText as NSString).replacingCharacters(in: range, with: text)
           placeholderLabel.isHidden = text.count > 0
           return true
       }
    
}
