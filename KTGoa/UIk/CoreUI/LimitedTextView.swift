//
//  LimitedTextView.swift
//  Golaa
//
//  Created by xiaoxuhui on 2024/5/29.
//

import UIKit

class LimitedTextView: UIView {
        
    public var limit: Int = 50
    
    var callBlock: CallBackStringBlock?
    
    func becomeResponder() {
        textView.becomeFirstResponder()
    }
    
    func resignResponder() {
        textView.resignFirstResponder()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCoder()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCoder() {
        addSubview(textView)
        addSubview(countLabel)
        textView.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.leading.equalTo(10)
            make.trailing.equalTo(-10)
            make.bottom.equalTo(countLabel.snp.top).offset(-5)
        }
        
        countLabel.snp.makeConstraints { make in
            make.bottom.equalTo(-5)
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
        }
    }
    
    lazy var textView: UITextView = {
        let text = UITextView()
        text.textColor = .x3
        text.tintColor = .appColor
        text.font = UIFontReg(14)
        text.backgroundColor = .clear
        text.delegate = self
        return text
    }()
    
    private lazy var countLabel: UILabel = {
        let lab = UILabel()
        lab.text = "(0/50)"
        lab.textColor = .x9
        lab.font = UIFontReg(10)
        lab.textAlignment = .right
        return lab
    }()
}

extension LimitedTextView: UITextViewDelegate {
    
       func textViewDidChange(_ textView: UITextView) {
           let currentText = textView.text ?? ""
           
           let limit = self.limit
           self.countLabel.text = "(\(currentText.count)/\(limit))"
           if currentText.count > limit {
               let limitText = String(currentText.prefix(limit))
               self.textView.text = limitText
           }
           
           callBlock?(textView.text)
       }
       
       func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
           let currentText = textView.text ?? ""
           let newText = (currentText as NSString).replacingCharacters(in: range, with: text)
           
           // 检查新文本是否超出最大字符数
           return newText.count <= limit
       }
}
