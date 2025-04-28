//
//  CommentUpdateImgView.swift
//  Golaa
//
//  Created by duke on 2024/5/20.
//

import UIKit

class CommentUpdateImgView: UIView {
    var tapAddPhotoBlock: CallBackAnyBlock?
    var tapImageBlock: (() -> Void)?
    var clearBlock: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildUI() {
        backgroundColor = .xf2
        gt.setCornerRadius(8)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAddPhotoAction)))
        addSubview(addIcon)
        addSubview(label)
        addSubview(imageView)
        addSubview(clear)
        
        addIcon.snp.makeConstraints { make in
            make.top.equalTo(31.5)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        label.snp.makeConstraints { make in
            make.top.equalTo(addIcon.snp.bottom).offset(13)
            make.centerX.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        clear.snp.makeConstraints { make in
            make.trailing.equalTo(-10)
            make.top.equalTo(10)
            make.width.height.equalTo(20)
        }
    }
    
    private func chosePicState(_ image: UIImage) {
        imageView.image = image
        imageView.isHidden = false
        clear.isHidden = false
        tapAddPhotoBlock?(image)
    }
    
    @objc private func tapAddPhotoAction(sender: UITapGestureRecognizer) {
        PictureTl.shared.showAlertPic()
        PictureTl.shared.callImgBlock = { [weak self] image in
            guard let self = self else { return }
            self.chosePicState(image)
        }
    }
    
    @objc private func tapImageAction(sender: UITapGestureRecognizer) {
        tapImageBlock?()
    }
    
    @objc private func clickClearBtn(sender: UIButton) {
        imageView.image = nil
        clearBlock?()
        imageView.isHidden = true
        clear.isHidden = true
    }
    
    lazy var addIcon: UIImageView = {
        let img = UIImageView()
        img.image = .homeAuthAdd
        return img
    }()
    
    lazy var label: UILabel = {
        let lab = UILabel()
        lab.text = "uploadAnImage".homeLocalizable()
        lab.textColor = .hexStrToColor("#999999")
        lab.font = UIFontReg(12)
        return lab
    }()
    
    lazy var imageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.isHidden = true
        img.image = .chatGift
        img.gt.setCornerRadius(14)
        img.isUserInteractionEnabled = true
        img.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapImageAction)))
        return img
    }()
    
    lazy var clear: UIButton = {
        let btn = UIButton(type: .custom)
        btn.image(.imageClear)
        btn.addTarget(self, action: #selector(clickClearBtn), for: .touchUpInside)
        btn.isHidden = true
        return btn
    }()
}
