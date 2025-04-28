//
//  IndividualInfoViewController.swift
//  Golaa
//
//  Created by Cb on 2024/5/19.
//

import Foundation

class IndividualInfoViewController: BasClasVC {
    
    var nameCell: IndividualContentView?
    var introCell: IndividualContentView?
    var emailCell: IndividualContentView?
    var phoneCell: IndividualContentView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configViews()
        configActions()
        reload()
        
        avatarView.gt.addGestureTap { [weak self] _ in
            self?.showPicker()
        }
        
        cameraIcon.gt.addGestureTap { [weak self] _ in
            self?.showPicker()
        }
    }
    
    func reload() {
        let model = LoginTl.shared.userInfo ?? GUsrInfo()
        nameCell?.reload()
        introCell?.reload()
        emailCell?.reload()
        phoneCell?.reload()
        avatarView.headerImageUrl(model.avatar)
    }
    
    private func configViews() {
        navTitle("personalInformation".meLocalizable())
        
        view.insertSubview(scrollView, at: 0)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(screW)
        }
        
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.top.equalTo(50)
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.width.equalTo(screW - 30)
        }
        
        stackView.addArrangedSubview(avatarView)
        avatarView.snp.makeConstraints { make in
            make.width.height.equalTo(100)
        }
        
        stackView.addSubview(cameraIcon)
        cameraIcon.snp.makeConstraints { make in
            make.width.height.equalTo(28)
            make.trailing.equalTo(avatarView.snp.trailing).offset(4)
            make.bottom.equalTo(avatarView.snp.bottom).offset(4)
        }
        
        IndividualContentType.allCases.forEach { type in
            let view = IndividualContentView(scene: type)
            
            view.gt.addGestureTap { [weak self] _ in
                guard let self = self else { return }
                switch type {
                case .email:
                    self.emailCell = view
                    self.showEmailPicker()
                case .name:
                    self.nameCell = view
                    self.showNamePicker()
                case .introduction:
                    self.introCell = view
                    self.showSloganPicker()
                case .phone:
                    self.phoneCell = view
                default:
                    break
                }
            }

            stackView.addArrangedSubview(view)
            view.snp.makeConstraints { make in
                make.width.equalTo(screW - 30)
            }
        }
        
    }
    
    private func configActions() {
    }
    
    // MARK: - 属性
    private let scrollView: UIScrollView = {
        let img = UIScrollView()
        img.alwaysBounceVertical = true
        img.showsVerticalScrollIndicator = false
        return img
    }()
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 30
        view.axis = .vertical
        view.alignment = .leading
        view.distribution = .fill
        return view
    }()
    
    private let avatarView: UIImageView = {
        let img = UIImageView()
        img.gt.setCornerRadius(12)
        img.contentMode = .scaleAspectFill
        img.isUserInteractionEnabled = true
        return img
    }()
    
    private let cameraIcon: UIButton = {
        let btn = UIButton()
        btn.image(.mineCamera)
        btn.isUserInteractionEnabled = true
        return btn
    }()
}

extension IndividualInfoViewController {
    // avatar
    // slogan
    // nickname
    func showPicker() {
        PictureTl.shared.showAlertPic()
        PictureTl.shared.callImgBlock = { [weak self] imgs in
                AliyunOSSHelper.shared.update(images: [imgs]) { result, paths in
                    if result {
                        self?.subServer(["avatar": paths[0]])
                    }
                }
        }
    }
    
    func showNamePicker() {
        let alert = AlertEditBaseContent()
        alert.limit = 20
        alert.value = LoginTl.shared.userInfo?.showName ?? ""
        alert.subClick = { [weak self] value in
            self?.subServer(["nickname": value])
        }
        alert.show(position: .bottom)
    }
    
    func showSloganPicker() {
        let alert = AlertEditBaseContent()
        alert.limit = 50
        alert.value = LoginTl.shared.userInfo?.userInfo?.slogan ?? ""
        alert.subClick = { [weak self] value in
            self?.subServer(["slogan": value])
        }
        alert.show(position: .bottom)
    }
    
    func showEmailPicker() {}
    
    func subServer(_ pars: [String: Any]) {
        LoginTl.shared.editUsr(pars) { [weak self] _ in
            LoginTl.shared.getCurUserInfo { _ in
                self?.reload()
            }
        }
    }
    
}
