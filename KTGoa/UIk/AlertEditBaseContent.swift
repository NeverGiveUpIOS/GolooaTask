//
//  AlertEditBaseContent.swift
//  Golaa
//
//  Created by xiaoxuhui on 2024/5/22.
//

import UIKit

class AlertEditBaseContent: AlertBaseView {

    var subClick: ((_ value: String) -> Void)?
    
    var limit: Int = 8 {
        didSet { textView.limit = limit }
    }

    var text: String {
        return textView.textView.text
    }
    
    var value: String = "" {
        didSet { textView.textView.text = value }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: screW, height: 210))
        setupCoder()
        backgroundColor = .white
    }

    func setupCoder() {
        
        addSubview(textView)
        addSubview(subBtn)

        textView.snp.makeConstraints { make in
            make.top.equalTo(20)
            make.height.equalTo(100)
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
        }

        subBtn.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.centerX.equalToSuperview()
            make.top.equalTo(textView.snp.bottom).offset(20)
        }
    }

    // MARK: -
    // MARK: Lazy
    lazy var textView: LimitedTextView = {
        let view = LimitedTextView()
        view.gt.setCornerRadius(8)
        view.backgroundColor = .xf2
        return view
   }()
    
    lazy var subBtn: UIButton = {
        let button = UIButton()
        button.gt.setCornerRadius(25)
        button.font(UIFontMedium(16))
        button.title("save".meLocalizable())
        button.backgroundColor = .appColor
        button.addTarget(self, action: #selector(submitCilk), for: .touchUpInside)
        return button
    }()
    
}
 
extension AlertEditBaseContent {
  
    @objc func submitCilk() {
        if text.isBlank { return }
        subClick?(self.text)
        textView.resignResponder()
        dismissView()
    }
}
