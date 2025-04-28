//
//  PublisherAlertView.swift
//  Golaa
//
//  Created by xiaoxuhui on 2024/6/4.
//

import UIKit

class PublisherAlertView: AlertBaseView {

    var completion: CallBackStringBlock?
    
    var cancelCompletion: CallBackVoidBlock?

    /// 显示弹窗
    /// - Parameters:
    ///   - titles: 标题 可为空
    ///   - details: 详情 可为空
    ///   - sures: 确定按钮
    ///   - cacnces: 取消按钮 可为空
    ///   - isTouchToDismiss: 点击是否消失
    ///   - space: 左右间距
    ///   - completion:
    static func show(titles: String = "",
                     contents: String = "",
                     isTouchToDismiss: Bool = false,
                     completion: CallBackStringBlock?,
                     cancelCompletion: CallBackVoidBlock? = nil) {
        
        let view = PublisherAlertView(frame: .zero,
                                contents: contents,
                                completion: completion,
                                cancelCompletion: cancelCompletion)
        
        view.isDismissible = isTouchToDismiss
        view.show()
    }
    
    convenience init(frame: CGRect,
                      contents: String,
                      completion: CallBackStringBlock?,
                      cancelCompletion: CallBackVoidBlock?) {
        
        self.init(frame: frame)
//        self.titleLabel.text = contents
        self.textView.text = contents
        self.completion = completion
        self.cancelCompletion = cancelCompletion
        setupLayouts()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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

    private lazy var textView: UITextView = {
        let text = UITextView()
        text.gt.setCornerRadius(8)
        text.textColor = .x9
        text.tintColor = .appColor
        text.backgroundColor = .xf2
        text.font = .init(name: "Menlo", size: 14)
        text.contentInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        return text
    }()
    
    /// 取消按钮
    lazy var canceButton: UIButton = {
        let button = UIButton(type: .custom)
        button.title("Done")
        button.textColor(.x9)
        button.font(UIFontSemibold(15))
        button.gt.handleClick { [weak self] _ in
            self?.cancelCompletion?()
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
            self?.completion?(self?.textView.text ?? "")
            self?.dismissView()
        }
        return button
    }()
}

extension PublisherAlertView {

    func setupLayouts() {
        
        self.frame = ScreB
        
        addSubview(contView)
        contView.addSubview(titleLabel)
        contView.addSubview(textView)
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
        
        textView.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.leading.equalTo(24)
            make.trailing.equalTo(-24)
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
        }
        
        sureButton.snp.makeConstraints { make in
            make.height.equalTo(54)
            make.leading.equalTo(24)
            make.trailing.equalTo(-24)
            make.top.equalTo(textView.snp.bottom).offset(30)
        }
        
        canceButton.snp.makeConstraints { make in
            make.height.equalTo(54)
            make.leading.equalTo(24)
            make.bottom.equalTo(-10)
            make.trailing.equalTo(-24)
            make.top.equalTo(sureButton.snp.bottom).offset(10)
        }
    }
}
