//
//  AuthViewController.swift
//  Golaa
//
//  Created by duke on 2024/5/15.
//

import UIKit

class AuthViewController: BasClasVC {
    
    let namePlaceholder = "nameDisplayedPublisherHomepageTaskDetails".homeLocalizable()
    var image1: UIImage?
    var image2: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildUI()
    }
    
    @objc  func clickAddPhoto1Action(sender: UITapGestureRecognizer) {
        PictureTl.shared.showAlertPic()
        PictureTl.shared.callImgBlock = { [weak self] img in
            guard let self = self else { return }
            guard let image = self.addPhoto1View.viewWithTag(100) as? UIImageView else { return }
            guard let clear = self.addPhoto1View.viewWithTag(101) as? UIButton else { return }
            image.image = img
            self.image1 = img
            image.isHidden = false
            clear.isHidden = false
            self.updateBottomState()
        }
    }
    
    @objc  func clickAddPhoto2Action(sender: UITapGestureRecognizer) {
        PictureTl.shared.showAlertPic()
        PictureTl.shared.callImgBlock = { [weak self] img in
            guard let self = self else { return }
            guard let image = self.addPhoto2View.viewWithTag(100) as? UIImageView else { return }
            guard let clear = self.addPhoto2View.viewWithTag(101) as? UIButton else { return }
            image.image = img
            self.image2 = img
            image.isHidden = false
            clear.isHidden = false
            self.updateBottomState()
        }
    }
    
    @objc  func clickClearImage1(sender: UIButton) {
        guard let image = self.addPhoto1View.viewWithTag(100) as? UIImageView else { return }
        guard let clear = self.addPhoto1View.viewWithTag(101) as? UIButton else { return }
        image.image = UIImage()
        image1 = nil
        image.isHidden = true
        clear.isHidden = true
        updateBottomState()
    }
    
    @objc  func clickClearImage2(sender: UIButton) {
        guard let image = self.addPhoto2View.viewWithTag(100) as? UIImageView else { return }
        guard let clear = self.addPhoto2View.viewWithTag(101) as? UIButton else { return }
        image.image = UIImage()
        image2 = nil
        image.isHidden = true
        clear.isHidden = true
        updateBottomState()
    }
    
    @objc  func browser1(sender: UITapGestureRecognizer) {
        PhotoBroView.showWithImages(nil, images: [image1 ?? UIImage()])
    }
    
    @objc  func browser2(sender: UITapGestureRecognizer) {
        PhotoBroView.showWithImages(nil, images: [image2 ?? UIImage()])
    }
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.isScrollEnabled = true
        if #available(iOS 13.0, *) {
            view.automaticallyAdjustsScrollIndicatorInsets = false
        } else {
            view.contentInsetAdjustmentBehavior = .never
        }
        return view
    }()
    
    lazy var bgView: UIImageView = {
        let img = UIImageView()
        img.image = .homeAuthBg
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    lazy var titleLabel: UILabel = {
        let lab = UILabel()
        lab.font = .oswaldDemiBold(24)
        lab.textColor = .black
        lab.text = "submitVerification".homeLocalizable()
        lab.numberOfLines = 0
        return lab
    }()
    
    lazy var arcView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.gt.setCustomCoRadius([.layerMinXMinYCorner, .layerMaxXMinYCorner], cornerRadius: 16)
        return view
    }()
    
    lazy var nameTitle: UILabel = {
        let lab = UILabel()
        lab.font = UIFontSemibold(14)
        lab.textColor = .black
        lab.text = "publisherName".homeLocalizable()
        return lab
    }()
    
    lazy var nameTV: UITextView = {
        let view = UITextView()
        view.font = UIFontReg(12)
        view.textColor = .black
        view.gt.setCornerRadius(8)
        view.backgroundColor = .xf2
        view.keyboardType = .default
        view.gt_placeholder = namePlaceholder
        view.gt_placeholderColor = .hexStrToColor("#999999")
        view.textContainerInset = .init(top: 15, left: 15, bottom: 15, right: 15)
        view.delegate = self
        return view
    }()
    
    lazy var emailTitle: UILabel = {
        let lab = UILabel()
        lab.font = UIFontSemibold(14)
        lab.textColor = .black
        lab.text = "contactEmail".homeLocalizable()
        return lab
    }()
    
    lazy var emailTV: UITextView = {
        let view = UITextView()
        view.font = UIFontReg(12)
        view.textColor = .black
        view.gt.setCornerRadius(8)
        view.backgroundColor = .xf2
        view.keyboardType = .default
        view.textContainerInset = .init(top: 15, left: 15, bottom: 15, right: 15)
        view.delegate = self
        return view
    }()
    
    lazy var realNameTitle: UILabel = {
        let lab = UILabel()
        lab.font = UIFontSemibold(14)
        lab.textColor = .black
        lab.text = "fullName".homeLocalizable()
        return lab
    }()
    
    lazy var realNameTV: UITextView = {
        let text = UITextView()
        text.font = UIFontReg(12)
        text.textColor = .black
        text.gt.setCornerRadius(8)
        text.backgroundColor = .xf2
        text.keyboardType = .default
        text.textContainerInset = .init(top: 15, left: 15, bottom: 15, right: 15)
        text.delegate = self
        return text
    }()
    
    lazy var imageTitle: UILabel = {
        let lab = UILabel()
        lab.font = UIFontSemibold(14)
        lab.textColor = .black
        lab.text = "uploadIdpassportdocumentPhoto".homeLocalizable()
        lab.numberOfLines = 0
        return lab
    }()
    
    lazy var addPhoto1View: UIView = {
        let view = UIView()
        view.backgroundColor = .xf2
        view.gt.setCornerRadius(14)
        let icon = UIImageView()
        icon.image = .homeAuthAdd
        view.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.top.equalTo(52)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(24)
        }
        let label = UILabel()
        label.font = UIFontReg(12)
        label.textColor = .black
        label.text = "uploadAnImage".homeLocalizable()
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalTo(icon.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.tag = 100
        image.isHidden = true
        image.gt.setCornerRadius(14)
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(browser1)))
        view.addSubview(image)
        image.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let clear = UIButton(type: .custom)
        clear.image(.imageClear)
        clear.addTarget(self, action: #selector(clickClearImage1), for: .touchUpInside)
        clear.tag = 101
        clear.isHidden = true
        view.addSubview(clear)
        clear.snp.makeConstraints { make in
            make.trailing.equalTo(-15)
            make.top.equalTo(15)
            make.width.height.equalTo(20)
        }
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickAddPhoto1Action)))
        return view
    }()
    
    lazy var addPhoto2View: UIView = {
        let view = UIView()
        view.backgroundColor = .xf2
        view.gt.setCornerRadius(14)
        let icon = UIImageView()
        icon.image = .homeAuthAdd
        view.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.top.equalTo(52)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(24)
        }
        let label = UILabel()
        label.font = UIFontReg(12)
        label.textColor = .black
        label.text = "uploadAnImage".homeLocalizable()
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalTo(icon.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.tag = 100
        image.isHidden = true
        image.gt.setCornerRadius(14)
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(browser2)))
        view.addSubview(image)
        image.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let clear = UIButton(type: .custom)
        clear.image(.imageClear)
        clear.addTarget(self, action: #selector(clickClearImage2), for: .touchUpInside)
        clear.tag = 101
        clear.isHidden = true
        view.addSubview(clear)
        clear.snp.makeConstraints { make in
            make.trailing.equalTo(-15)
            make.top.equalTo(15)
            make.width.height.equalTo(20)
        }
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickAddPhoto2Action)))
        return view
    }()
    
    lazy var bottomBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("verifyNow".homeLocalizable(), for: .normal)
        btn.setTitleColor(.hexStrToColor("#666666"), for: .normal)
        btn.setTitleColor(.hexStrToColor("#666666"), for: .highlighted)
        btn.setTitleColor(.black, for: .selected)
        btn.titleLabel?.font = UIFontSemibold(14)
        btn.setBackgroundImage(UIColor.appColor.withAlphaComponent(0.5).transform(), for: .normal)
        btn.setBackgroundImage(UIColor.appColor.withAlphaComponent(0.5).transform(), for: .highlighted)
        btn.setBackgroundImage(UIColor.appColor.transform(), for: .selected)
        btn.gt.setCornerRadius(8)
        btn.gt.preventDoubleHit(5)
        btn.gt.handleClick { [weak self] _ in
            self?.bottomClickReq()
        }
        return btn
    }()
}

extension AuthViewController {
    
    func bottomClickReq() {
        guard self.bottomBtn.isSelected,
              let name = nameTV.text,
              let email = emailTV.text,
              let realName = realNameTV.text,
              let image1 = image1,
              let image2 = image2
        else {
            return
        }
        
        mutatePostAuthResult(name: name, email: email, realName: realName, image1: image1, image2: image2)
    }
    
    private func mutatePostAuthResult(name: String,
                                      email: String,
                                      realName: String,
                                      image1: UIImage,
                                      image2: UIImage) {
        // 上传 oss
        AliyunOSSHelper.shared.update(images: [image1, image2], type: .publishAuth) { result, filePaths in
            if result, filePaths.count == 2 {
                var params: [String: Any] = [:]
                params["publishName"] = name
                params["publishEmail"] = email
                params["realName"] = realName
                params["certImage"] = filePaths.joined(separator: ",")
                NetAPI.HomeAPI.auth.reqToJsonHandler(parameters: params) { _ in
                    RoutinStore.dismissRoot(animated: false)
                    RoutinStore.push(.authComplete)
                    debugPrint("认证成功等待审核...")
                } failed: { error in
                }
            } else {
            }
        }
    }
    
}

