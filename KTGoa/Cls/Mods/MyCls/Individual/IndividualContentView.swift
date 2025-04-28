//
//  IndividualContentView.swift
//  Golaa
//
//  Created by Cb on 2024/5/20.
//

import Foundation

enum IndividualContentType: CaseIterable {
    case name
    case sex
    case introduction
    case phone
    case email
    
    var rawValue: String {
        switch self {
        case .name:
            return "myNickname".loginLocalizable()
        case .sex:
            return "gender".loginLocalizable()
        case .introduction:
            return "personalIntroduction".homeLocalizable()
        case .phone:
            return "phoneNumber".meLocalizable()
        case .email:
            return "email".meLocalizable()
        }
    }

    var placeholder: String {
        switch self {
        case .name:
            return "notFilledIn".meLocalizable()
        case .sex:
            return ""
        case .introduction:
            return "notFilledIn".meLocalizable()
        case .phone:
            return "notBound".meLocalizable()
        case .email:
            return "notBound".meLocalizable()
        }
    }
    
    var value: String {
        let model = LoginTl.shared.userInfo ?? GUsrInfo()
        switch self {
        case .name:
            return model.nickname
        case .introduction:
            return model.userInfo?.slogan ?? ""
        case .phone:
            return model.phone
        case .email:
            return model.email
        default:
            return ""
        }
    }
}

class IndividualContentView: UIView {
    
    let scene: IndividualContentType

    func reload() {
        textField.text = scene.value
        textField.placeholder = scene.placeholder
        switch LoginTl.shared.userInfo?.gender {
        case .body:
            mrLabel.sendActions(for: .touchUpInside)
        case .girl:
            msLabel.sendActions(for: .touchUpInside)
        case .none:
            break
        }
    }
    
    init(scene: IndividualContentType) {
        self.scene = scene
        super.init(frame: .zero)
        configViews()
        configActions()
        reload()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configViews() {
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stackView.addArrangedSubview(titleLabel)
        
        if scene == .sex {
            
            let view = UIView()
            stackView.addArrangedSubview(view)
            
            view.addSubview(mrLabel)
            view.addSubview(msLabel)
            
            mrLabel.snp.makeConstraints { make in
                make.width.equalTo(100)
                make.height.equalTo(50)
                make.leading.top.bottom.equalToSuperview()
            }
            
            msLabel.snp.makeConstraints { make in
                make.width.equalTo(100)
                make.height.equalTo(50)
                make.trailing.top.bottom.equalToSuperview()
                make.leading.equalTo(mrLabel.snp.trailing).offset(16)
            }

        } else {
            
            stackView.addArrangedSubview(textField)
            textField.snp.makeConstraints { make in
                make.width.equalToSuperview()
                make.height.equalTo(50)
            }
        }
    }
    
    private func configActions() {}
    
    // MARK: - 属性
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 10
        view.distribution = .fill
        view.alignment = .leading
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = .black
        lab.text = scene.rawValue
        lab.font = .systemFont(ofSize: 14)
        lab.textAlignment = .left
        return lab
    }()
    
    private lazy var textField: UITextField = {
        let text = UITextField()
        text.gt.setCornerRadius(8)
        text.textColor = .black
        text.leftViewMode = .always
        text.font = .systemFont(ofSize: 14)
        text.placeholder = scene.placeholder
        text.isUserInteractionEnabled = false
        text.backgroundColor = UIColor.xf2
        text.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        return text
    }()
    
    lazy var mrLabel: UIButton = {
        let button = UIButton()
        button.gt.setCornerRadius(16)
        button.isUserInteractionEnabled = false
        button.setImage(.loginMr.withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(genderClick), for: .touchUpInside)
        return button
    }()
    
    lazy var msLabel: UIButton = {
        let button = UIButton()
        button.gt.setCornerRadius(16)
        button.isUserInteractionEnabled = false
        button.setImage(.loginMs.withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(genderClick), for: .touchUpInside)
        return button
    }()
    
    @objc func genderClick(sender: UIButton) {
        let iconNorColor: UIColor = .hexStrToColor("BABABA")
        let iconSelBodyColor: UIColor = .hexStrToColor("#3C8CF9")
        let iconSelGirlColor: UIColor = .hexStrToColor("F188C7")
        
        let bgNorColor: UIColor = .hexStrToColor("#F8F8F8")
        let bgNorBodyColor: UIColor = .hexStrToColor("#EDF7FF")
        let bgNorGirlColor: UIColor = .hexStrToColor("#FFECF8")
        
        if sender == mrLabel {
            mrLabel.tintColor = iconSelBodyColor
            msLabel.tintColor = iconNorColor
            mrLabel.backgroundColor = bgNorBodyColor
            msLabel.backgroundColor = bgNorColor
         
        } else {
            mrLabel.tintColor = iconNorColor
            msLabel.tintColor = iconSelGirlColor
            mrLabel.backgroundColor = bgNorColor
            msLabel.backgroundColor = bgNorGirlColor
        }
    }
}
