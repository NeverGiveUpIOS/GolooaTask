//
//  VersionAlertView.swift
//  Golaa
//
//  Created by Cb on 2024/5/28.
//

import Foundation

class VersionAlertView: AlertBaseView {
    
    private var completion: CallBackVoidBlock?
    
    private var cancelCompletion: CallBackVoidBlock?
        
    init(model: GlobalVersionModel) {
        self.model = model
        super.init(frame: UIScreen.main.bounds)
        buildUI()
        bind()
        configData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: screW - 64, height: 342)
    }
    
    private func buildUI() {
        addSubview(contentVew)
        contentVew.addSubview(bgView)
        contentVew.addSubview(icon)
        bgView.addSubview(stackView)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descLabel)
        stackView.addArrangedSubview(sureButton)

        contentVew.snp.makeConstraints { make in
            make.width.equalTo(screW - 64)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(24)
            make.trailing.equalTo(-24)
            make.top.equalTo(110)
            make.bottom.equalTo(-16)
        }
        
        icon.snp.makeConstraints { make in
            make.width.height.equalTo(220)
            make.centerX.equalToSuperview()
            make.centerY.equalTo(bgView.snp.top)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        
        descLabel.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(7)
        }
        
        stackView.setCustomSpacing(7, after: titleLabel)
        
        sureButton.snp.makeConstraints { make in
            make.width.equalTo(223)
            make.height.equalTo(44)
        }
        
        stackView.setCustomSpacing(40, after: descLabel)
        
        if !model.isForce {
            stackView.addArrangedSubview(canceButton)
            canceButton.snp.makeConstraints { make in
                make.width.equalTo(223)
                make.height.equalTo(44)
            }
        }

    }

    private func bind() {}
    
    static func show(model: GlobalVersionModel) {
        if AppVersion != model.version {
            if model.state == 2 {
                if !model.isForce {
                    if !todayNeedShow(true) { return }
                }
                VersionAlertView(model: model).show(position: .center)
            }
        }
    }
    
    static func todayNeedShow(_ needSave: Bool = false) -> Bool {
        let dateMatter = DateFormatter(format: "YYYY-MM-dd")
        let dayTime = dateMatter.string(from: Date())
        var result = true
        if let content = UserDefaults.standard.string(forKey: CacheKey.versionShowState) {
            result = content != dayTime
        }
        
        if needSave && result {
            UserDefaults.standard.setValue(dayTime, forKey: CacheKey.versionShowState)
            UserDefaults.standard.synchronize()
        }
        return result
    }
    
    private func configData() {
        titleLabel.text = "discoverTheNewVersion".globalLocalizable()
        descLabel.text = model.desc
        sureButton.setTitle("updateNow".globalLocalizable(), for: .normal)
        canceButton.setTitle("nextTime".globalLocalizable(), for: .normal)
        isDismissible = !model.isForce
    }
    
    // MARK: - 属性
    
    private let model: GlobalVersionModel
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        view.spacing = 0
        view.distribution = .fill
        return view
    }()
    
    private lazy var contentVew: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.gt.setCornerRadius(12)
        return view
    }()
    
    private lazy var icon: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "mine_version_top")
        return img
    }()
    
    private lazy var titleLabel: UILabel = {
        let lab = UILabel()
        lab.font = UIFontSemibold(15)
        lab.textColor = .hexStrToColor("#000000")
        lab.textAlignment = .center
        lab.numberOfLines = 0
        return lab
    }()
    
    private lazy var descLabel: UILabel = {
        let lab = UILabel()
        lab.font = .systemFont(ofSize: 13)
        lab.textColor = .hexStrToColor("#999999")
        lab.textAlignment = .center
        lab.numberOfLines = 0
        return lab
    }()
    
    /// 取消按钮
    lazy var canceButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(.hexStrToColor("#999999"), for: .normal)
        button.titleLabel?.font = UIFontSemibold(15)
        button.gt.handleClick { [weak self] _ in
            self?.cancelCompletion?()
            self?.dismissView()
        }
        return button
    }()
    
    /// 确定按钮
    lazy var sureButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(.hexStrToColor("#000000"), for: .normal)
        button.titleLabel?.font = UIFontSemibold(15)
        button.backgroundColor = .appColor
        button.gt.setCornerRadius(8)
        button.gt.handleClick { [weak self] _ in
            guard let self = self else { return }
            if !self.model.isForce {
                self.completion?()
                self.dismissView()
            }
            if let url = URL(string: self.model.link), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        return button
    }()
    
}
