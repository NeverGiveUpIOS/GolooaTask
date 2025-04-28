//
//  ChatTextView.swift
//  Golaa
//
//  Created by chenkaisong on 2024/5/11.
//

import UIKit

class ChatTextView: UITextView {
    /// 最大高度
    private var maxTextHeight: CGFloat {
        let textFont = font ??  UIFontReg(12)
        return CGFloat(ceilf(Float(textFont.lineHeight * CGFloat(maxNumberOfLines) + textContainerInset.top + textContainerInset.bottom)))
    }
    
    /// 占位文字label
    private lazy var placeholderLabel: UILabel = {
        let view = UILabel()
        view.backgroundColor = UIColor.clear
        view.text = placeholder
        view.textColor = placeholderColor
        view.numberOfLines = 0
        return view
    }()
    
    /// 最大行数
    var maxNumberOfLines: Int = 6
    
    /// 占位文字
    var placeholder: String = "" {
        didSet {
            placeholderLabel.text = placeholder
        }
    }
    
    /// 占位文字颜色
    var placeholderColor = UIColor.lightGray {
        didSet {
            placeholderLabel.textColor = placeholderColor
        }
    }
    
    /// 文字变化回掉
    var textDidChangeCallback: ((String) -> Void)?
    
    /// 字体
    override var font: UIFont? {
        didSet {
            placeholderLabel.font = font
        }
    }
    
    override var text: String! {
        didSet {
            textDidChange()
        }
    }
    
    /// 高度变化回掉
    var textViewHeightChangeCallback: ((CGFloat) -> Void)?
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.gt.setCornerRadius(19)
        backgroundColor = .xf2
        placeholder = "enterMsg".msgLocalizable()
        placeholderColor =  .hexStrToColor("#CBCBCB")
        autocapitalizationType = .none
        enablesReturnKeyAutomatically = true
        layoutManager.allowsNonContiguousLayout = false
        scrollsToTop = false
        returnKeyType = .send
        autocorrectionType = .no
        textColor = .black
        textContainerInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 10)
        initSubViews()
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: nil)
    }
}

extension ChatTextView {
    private func initSubViews() {
        addSubview(placeholderLabel)
        placeholderLabel.snp.makeConstraints { make in
            make.left.equalTo(18)
            make.centerY.equalToSuperview()
            make.height.lessThanOrEqualToSuperview()
        }
        font = UIFontReg(12)
        isScrollEnabled = false
        scrollsToTop = false
        showsHorizontalScrollIndicator = false
        enablesReturnKeyAutomatically = true
        // 实时监听textView值得改变
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextView.textDidChangeNotification, object: self)
    }
    
    @objc private func textDidChange() {
        textDidChangeCallback?(text)
        placeholderLabel.isHidden = text.count > 0
        // 计算高度
        setNeedsLayout()
        layoutIfNeeded()
        var height = CGFloat(ceilf(Float(sizeThatFits(CGSize(width: frame.size.width, height: CGFloat(MAXFLOAT))).height)))
        if height > maxTextHeight {
            height = maxTextHeight
            isScrollEnabled = true
        } else {
            isScrollEnabled = false
        }
        if frame.height != height {
            textViewHeightChangeCallback?(height)
        }
        scrollRangeToVisible(NSRange(location: selectedRange.location, length: 1))
    }
}
