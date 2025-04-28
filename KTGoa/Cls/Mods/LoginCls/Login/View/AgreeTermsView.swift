//
//  AgreeTermsView.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/8/9.
//

import UIKit

class AgreeTermsView: UIView, UITextViewDelegate {
    
    let checkboxButton = UIButton(type: .custom)
    let termsTextView = UITextView()
    
    var isAgree = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        // Setup checkbox button
        checkboxButton.image(.boxNor)
        checkboxButton.image(.boxSel, .selected)
        checkboxButton.addTarget(self, action: #selector(toggleCheckbox), for: .touchUpInside)
        checkboxButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Setup terms text view
        termsTextView.isEditable = false
        termsTextView.isScrollEnabled = false
        termsTextView.backgroundColor = .clear
        termsTextView.isSelectable = true
        termsTextView.delegate = self
        termsTextView.attributedText = getAttributedText()
        termsTextView.translatesAutoresizingMaskIntoConstraints = false
        termsTextView.linkTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        
        // Add subviews
        addSubview(checkboxButton)
        addSubview(termsTextView)
        
        // Layout constraints
        NSLayoutConstraint.activate([
            checkboxButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            checkboxButton.topAnchor.constraint(equalTo: topAnchor),
            checkboxButton.widthAnchor.constraint(equalToConstant: 10),
            checkboxButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            termsTextView.leadingAnchor.constraint(equalTo: checkboxButton.trailingAnchor, constant: 0),
            termsTextView.trailingAnchor.constraint(equalTo: trailingAnchor),
            termsTextView.topAnchor.constraint(equalTo: topAnchor),
            termsTextView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    @objc private func toggleCheckbox() {
        checkboxButton.isSelected.toggle()
        isAgree = checkboxButton.isSelected
    }
    
    private func getAttributedText() -> NSAttributedString {
        let attributedString = NSMutableAttributedString()
        
        let text1 = "agree".msgLocalizable()
        let text2 = "userAgreement".loginLocalizable()
        let text3 = "and".loginLocalizable()
        let text4 = "privacyPolicy".loginLocalizable()
        
        attributedString.append(NSAttributedString(string: text1, attributes: [
            NSAttributedString.Key.font: UIFontReg(12),
            .foregroundColor: UIColorHex("#999999"),
        ]))
        
        let termsAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFontReg(12),
            .foregroundColor: UIColor.white,
            .link: URL(string: "terms://")!
        ]
        attributedString.append(NSAttributedString(string: text2, attributes: termsAttributes))
        
        attributedString.append(NSAttributedString(string: text3, attributes: [
            NSAttributedString.Key.font: UIFontReg(12),
            .foregroundColor: UIColorHex("#999999"),
        ]))
        
        let privacyAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFontReg(12),
            .foregroundColor: UIColor.white,
            .link: URL(string: "privacy://")!
        ]
        attributedString.append(NSAttributedString(string: text4, attributes: privacyAttributes))
        
        return attributedString
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.absoluteString.contains("terms") {
            if GlobalHelper.shared.dataConfigure.userAgreementUrl.count <= 0 {
                self.dataCommon(.agreement)
            } else {
                RoutinStore.push(.webScene(.agreement))
            }
        } else if URL.absoluteString.contains("privacy") {
            if GlobalHelper.shared.dataConfigure.privacyPolicyUrl.count <= 0 {
                self.dataCommon(.privacy)
            } else {
                RoutinStore.push(.webScene(.privacy))
            }
        }
        return false
    }
    
    private func dataCommon(_ scene: WebContentScene) {
        NetAPI.GlobalAPI.dataCommon.reqToModelHandler(true, parameters: nil, model: GlobalCommonData.self) { model, _ in
            GlobalHelper.shared.dataConfigure = model
            RoutinStore.push(.webScene(scene))
        } failed: {  _ in
        }
    }
    
}
