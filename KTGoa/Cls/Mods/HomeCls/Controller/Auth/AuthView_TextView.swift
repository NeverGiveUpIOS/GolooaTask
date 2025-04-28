//
//  AuthView_TextView.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/8/7.
//

import Foundation

extension AuthViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let currentText = textView.text ?? ""
        
        if textView == nameTV {
            if currentText.count > 30 {
                let limitText = String(currentText.prefix(30))
                self.nameTV.text = limitText
            }
        }
        
        if textView == emailTV {
            if currentText.count > 100 {
                let limitText = String(currentText.prefix(100))
                self.emailTV.text = limitText
            }
        }
        
        if textView == realNameTV {
            if currentText.count > 30 {
                let limitText = String(currentText.prefix(30))
                self.realNameTV.text = limitText
            }
        }
        
        updateBottomState()

    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let currentText = textView.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        if text == hhf {
            textView.resignFirstResponder()
            return false
        }
        
        if textView == nameTV {
            return  newText.count <= 30
        }
        
        if textView == emailTV {
            return  newText.count <= 100
        }
        
        if textView == realNameTV {
            return  newText.count <= 30
        }
        
        return true
    }
    
}
