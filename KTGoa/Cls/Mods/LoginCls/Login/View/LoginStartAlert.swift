//
//  LoginStartAlert.swift
//  Golaa
//
//  Created by xiaoxuhui on 2024/6/15.
//

import UIKit

class LoginStartAlert: AlertBaseView {
    
    var completion: CallBackBoolBlock?
    
    /// 显示弹窗
    static func show(completion: CallBackBoolBlock?) {
        let alert = LoginStartAlert()
        alert.isDismissible = true
        alert.completion = completion
        alert.show()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let value = "agreementText".loginLocalizable()
        let title = "agreementTitle".loginLocalizable()
        self.titleLabel.text = title
        self.contentLab.text = value
        datas()
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contView.gt.setCornerRadius(12)
    }
    
    /// 内容
    private lazy var contView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    /// 标题
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFontSemibold(15)
        label.textColor = .hexStrToColor("#000000")
        label.text = "rsaPublicKeyConfiguration".meLocalizable()
        return label
    }()
    
    /// 内容
    private lazy var contentLab: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFontReg(13)
        label.textAlignment = .center
        label.textColor = .hexStrToColor("#999999")
        return label
    }()
    
    /// 取消按钮
    lazy var canceButton: UIButton = {
        let button = UIButton(type: .custom)
        button.textColor(.x9)
        button.font(UIFontSemibold(15))
        button.title("cancel".msgLocalizable())
        button.gt.handleClick { [weak self] _ in
            self?.completion?(false)
            self?.dismissView()
        }
        return button
    }()
    
    /// 确定按钮
    lazy var sureButton: UIButton = {
        let button = UIButton(type: .custom)
        button.gt.setCornerRadius(8)
        button.textColor(.black)
        button.font(UIFontSemibold(15))
        button.backgroundColor = .appColor
        button.title("confirm".msgLocalizable())
        button.gt.handleClick { [weak self] _ in
            self?.completion?(true)
            self?.dismissView()
        }
        return button
    }()
}

// MARK: - UI
extension LoginStartAlert {
    
    func setupLayouts() {
        
        self.frame = ScreB
        
        addSubview(contView)
        contView.addSubview(titleLabel)
        contView.addSubview(contentLab)
        contView.addSubview(sureButton)
        contView.addSubview(canceButton)
        
        contView.snp.makeConstraints { make in
            make.leading.equalTo(32)
            make.trailing.equalTo(-32)
            make.centerX.equalToSuperview()
            make.width.equalTo(screW - 2*32)
            make.centerY.equalToSuperview().offset(-50)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(30)
            make.leading.equalTo(24)
            make.trailing.equalTo(-24)
        }
        
        contentLab.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.leading.equalTo(24)
            make.trailing.equalTo(-24)
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
        }
        
        sureButton.snp.makeConstraints { make in
            make.height.equalTo(54)
            make.leading.equalTo(24)
            make.trailing.equalTo(-24)
            make.top.equalTo(contentLab.snp.bottom).offset(30)
        }
        
        canceButton.snp.makeConstraints { make in
            make.height.equalTo(54)
            make.leading.equalTo(24)
            make.bottom.equalTo(-10)
            make.trailing.equalTo(-24)
            make.top.equalTo(sureButton.snp.bottom).offset(10)
        }
    }
    
    func datas() {
        let a = "userAgreement".loginLocalizable()
        let b = "privacyPolicy".loginLocalizable()
        let str = "agreementText".loginLocalizable()
        
        let attributed = NSMutableAttributedString(string: str)
        
//        if let range =  str.jk.nsRange(of: a).first {
//            attributed.yy_setColor(.black, range: range)
//            attributed.yy_setFont(UIFontReg(12), range: range)
//            attributed.yy_setTextHighlight(range, color: .black, backgroundColor: .clear) { [weak self] _, _, _, _ in
//                self?.dismissView()
//                RoutinStore.push(.webScene(.agreement))
//            }
//        }
//        
//        if let range = str.jk.nsRange(of: b).first {
//            attributed.yy_setColor(.black, range: range)
//            attributed.yy_setFont(UIFontReg(12), range: range)
//            attributed.yy_setTextHighlight(range, color: .black, backgroundColor: .clear) { [weak self] _, _, _, _ in
//                self?.dismissView()
//                RoutinStore.push(.webScene(.privacy))
//            }
//        }
        
        contentLab.attributedText = attributed
    }
}
