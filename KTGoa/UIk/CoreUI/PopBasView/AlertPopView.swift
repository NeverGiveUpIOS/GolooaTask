//
//  AlertPopView.swift
//  Golaa
//
//  Created by chenkaisong on 2024/5/10.
//

import UIKit

class AlertPopView: AlertBaseView {
    
    var completion: CallBackVoidBlock?
    
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
    static func show(titles: String,
                     contents: String = "",
                     sures: String = "confirm".globalLocalizable(),
                     cacnces: String = "cancel".msgLocalizable(),
                     cacncesColor: UIColor = UIColorHex("#999999"),
                     isTouchToDismiss: Bool = true,
                     space: CGFloat = 32,
                     completion: CallBackVoidBlock? = nil,
                     cancelCompletion: CallBackVoidBlock? = nil) {
        
        let view = AlertPopView(frame: .zero,
                                titles: titles,
                                contents: contents,
                                sures: sures,
                                cacnces: cacnces,
                                cacncesColor: cacncesColor,
                                space: space,
                                completion: completion,
                                cancelCompletion: cancelCompletion)
        view.isDismissible = isTouchToDismiss
        view.show()
    }
    
    convenience  init(frame: CGRect,
                      titles: String,
                      contents: String,
                      sures: String,
                      cacnces: String,
                      cacncesColor: UIColor,
                      space: CGFloat,
                      completion: CallBackVoidBlock?,
                      cancelCompletion: CallBackVoidBlock?) {
        
        self.init(frame: frame)
        
        self.completion = completion
        self.cancelCompletion = cancelCompletion
        
        setupSubviews()
        setupLayouts(titles: titles,
                     contents: contents,
                     sures: sures,
                     cacnces: cacnces,
                     cacncesColor: cacncesColor,
                     space: space)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contView.gt.addCorner(radius: 20)
    }
    
    /// 内容
    private lazy var contView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    /// 标题
    private lazy var titlelab: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColorHex("#000000")
        label.font = UIFontSemibold(15)
        label.numberOfLines = 0
        return label
    }()
    
    /// 内容
    private lazy var contentLab: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColorHex("#999999")
        label.font = UIFontReg(13)
        label.numberOfLines = 0
        return label
    }()
    
    /// 取消按钮
    lazy var canceButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(UIColorHex("#999999"), for: .normal)
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
        button.setTitleColor(UIColorHex("#000000"), for: .normal)
        button.titleLabel?.font = UIFontSemibold(15)
        button.backgroundColor = .appColor
        button.gt.setCornerRadius(8)
        button.gt.handleClick { [weak self] _ in
            self?.completion?()
            self?.dismissView()
        }
        return button
    }()
}

// MARK: - UI
extension AlertPopView {
    
    private func setupSubviews() {
        
        addSubview(contView)
        contView.gt.addSubviews([
            titlelab,
            contentLab,
            canceButton,
            sureButton
        ])
    }
    
    private func setupLayouts(titles: String,
                              contents: String,
                              sures: String,
                              cacnces: String,
                              cacncesColor: UIColor,
                              space: CGFloat) {
        
        titlelab.text = titles
        contentLab.text = contents
        sureButton.setTitle(sures, for: .normal)
        canceButton.setTitle(cacnces, for: .normal)
        canceButton.setTitleColor(cacncesColor, for: .normal)
        
        contView.snp.makeConstraints { make in
            make.leading.equalTo(space)
            make.trailing.equalTo(-space)
            make.width.equalTo(screW - 2*space)
            make.top.bottom.equalToSuperview()
        }
        
        let isTitles = titles.count > 0
        titlelab.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.top.equalTo(isTitles ? 40 : 0)
        }
        
        let iscontents = contents.count > 0
        contentLab.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.top.equalTo(titlelab.snp.bottom).offset(isTitles ? 10 : 40)
        }
        
        let isCance = cacnces.count > 0
        let isSure = sures.count > 0
        
        if isCance && isSure {
            sureButton.snp.makeConstraints { make in
                make.leading.equalTo(44)
                make.trailing.equalTo(-44)
                make.height.equalTo(44)
                make.top.equalTo(contentLab.snp.bottom).offset(iscontents ? 40:32)
            }
            canceButton.snp.makeConstraints { make in
                make.centerX.height.width.equalTo(sureButton)
                make.top.equalTo(sureButton.snp.bottom).offset(18)
                make.bottom.equalTo(-18)
            }
            
            return
        }
        
        if isCance {
            // 只显示取消按钮
            canceButton.snp.makeConstraints { make in
                make.leading.equalTo(44)
                make.trailing.equalTo(-44)
                make.height.equalTo(44)
                make.bottom.equalTo(-26)
                make.top.equalTo(contentLab.snp.bottom).offset(iscontents ? 40:32)
            }
            return
        }
        
        if isSure {
            // 只显示确定按钮按钮
            sureButton.snp.makeConstraints { make in
                make.leading.equalTo(44)
                make.trailing.equalTo(-44)
                make.height.equalTo(44)
                make.bottom.equalTo(-26)
                make.top.equalTo(contentLab.snp.bottom).offset(iscontents ? 40:32)
            }
        }
    }
}
