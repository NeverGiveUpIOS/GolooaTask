//
//  CreateGroupViewController.swift
//  Golaa
//
//  Created by duke on 2024/5/9.
//

import UIKit

class CreateGroupViewController: BasClasVC {
    
    var imgUrl: String = ""
    var nameText: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        navTitle("createNewGroup".msgLocalizable())
        buildUI()
    }
    
    private func buildUI() {
        
        view.addSubview(title1Label)
        view.addSubview(updateAvatarBtn)
        view.addSubview(avatarView)
        view.addSubview(title2Label)
        view.addSubview(nameContent)
        nameContent.addSubview(textField)
        view.addSubview(bottomBtn)
        
        title1Label.snp.makeConstraints { make in
            make.leading.equalTo(15)
            make.top.equalTo(15 + naviH)
        }
        
        updateAvatarBtn.snp.makeConstraints { make in
            make.top.equalTo(title1Label.snp.bottom).offset(10)
            make.leading.equalTo(15)
            make.width.height.equalTo(100)
        }
        
        avatarView.snp.makeConstraints { make in
            make.edges.equalTo(updateAvatarBtn)
        }
        
        title2Label.snp.makeConstraints { make in
            make.top.equalTo(updateAvatarBtn.snp.bottom).offset(30)
            make.leading.equalTo(15)
        }
        
        nameContent.snp.makeConstraints { make in
            make.top.equalTo(title2Label.snp.bottom).offset(10)
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.height.equalTo(50)
        }
        
        textField.snp.makeConstraints { make in
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.top.bottom.equalToSuperview()
        }
        
        bottomBtn.snp.makeConstraints { make in
            make.bottom.equalTo(-20 - safeAreaBt)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(52)
        }
    }
        
    // MARK: -
    // MARK: Lazy
    private lazy var title1Label: UILabel = {
        let lab = UILabel()
        lab.textColor = .black
        lab.text = "groupCover".msgLocalizable()
        lab.font = UIFontSemibold(14)
        return lab
    }()
    
    private lazy var avatarView: UIImageView =  {
        let img = UIImageView()
        img.gt.setCornerRadius(12)
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    private lazy var updateAvatarBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.gt.setCornerRadius(12)
        btn.image(.groupAdd1)
        btn.backgroundColor = .xf2
        btn.addTarget(self, action: #selector(avatarClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var title2Label: UILabel = {
        let lab = UILabel()
        lab.textColor = .black
        lab.font = UIFontSemibold(14)
        lab.text = "groupName".msgLocalizable()
        return lab
    }()
    
    private lazy var nameContent: UIView = {
        let view = UIView()
        view.gt.setCornerRadius(8)
        view.backgroundColor = .xf2
        return view
    }()
    
    private lazy var textField: UITextField = {
        let text = UITextField()
        text.textColor = .black
        text.tintColor = .appColor
        text.font = UIFontReg(14)
        text.addTarget(self, action: #selector(textFiledChange), for: .editingChanged)
        return text
    }()
    
    private lazy var bottomBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.gt.setCornerRadius(8)
        btn.setTitleColor(.x6, for: .normal)
        btn.isUserInteractionEnabled = false
        btn.setTitleColor(.black, for: .selected)
        btn.setTitle("createNewGroup".msgLocalizable(), for: .normal)
        btn.setBackgroundImage(.colorToImage(.appColor.alpha(0.6)), for: .normal)
        btn.setBackgroundImage(.colorToImage(.appColor.alpha(1.0)), for: .selected)
        btn.addTarget(self, action: #selector(bottomClick), for: .touchUpInside)
        return btn
    }()
}

extension CreateGroupViewController {
    
    @objc private func avatarClick(sender: UIButton) {
        showPicker()
    }
    
    @objc private func textFiledChange(sender: UITextField) {
        let limit = 30
        let text = textField.text ?? ""
        if text.count > limit {
            sender.text = String(text.prefix(limit))
        }
        nameText = text
        editStatue()
    }
    
    @objc private func bottomClick(sender: UIButton) {
        MessageReq.create(nameText, imgUrl) { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    func showPicker() {
        PictureTl.shared.showAlertPic()
        PictureTl.shared.callImgBlock = { [weak self] imgs in
            AliyunOSSHelper.shared.update(images: [imgs]) { result, paths in
                if result {
                    self?.imgUrl = paths[0]
                    self?.avatarView.image = imgs
                    self?.editStatue()
                }
            }
        }
    }
    
    private func editStatue() {
        let isUser = !nameText.isBlank && nameText.count > 0 && imgUrl.count > 0
        bottomBtn.isUserInteractionEnabled = isUser
        bottomBtn.isSelected = isUser
    }
}
