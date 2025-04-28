//
//  PublishTask_Edit.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/8/6.
//

import UIKit

extension PublishTaskViewController: UITextFieldDelegate {
    
    func endEditTextField(_ textField: UITextField) {
        textField.resignFirstResponder()
        textField.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditTextField(textField)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        guard string != hhf else { return true }
   
        if textField == editToolTF {
            let text = newText.trimmingCharacters(in: .whitespaces)
            keyboardReturn(text)
            return newText.count <= 200
        }
        
        if textField == registTF { // 注册单价输入
            // 如果replacementString为空，且range的长度大于0，则表示用户正在删除文本
            if string.isEmpty && range.length > 0 {
                // 处理删除操作
                return true // 允许删除
            }
            
            // 拼接当前文本和要替换的字符串
            let currentText = (textField.text ?? "") as NSString
            let proposedText = currentText.replacingCharacters(in: range, with: string)
              
            // 使用正则表达式来匹配只允许的数字和最多两位小数的格式
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            numberFormatter.maximumFractionDigits = 2 // 最多两位小数
            numberFormatter.maximum = 999999.99
            // 尝试将 proposedText 转换为数字
            let isNumber = numberFormatter.number(from: proposedText) != nil
              
            // 还可以添加额外的逻辑来确保输入时小数点的位置是正确的
            // ...
            var text = newText.trimmingCharacters(in: .whitespaces)
            if text.contains("$") {
                text = text.replacingOccurrences(of: "$", with: "")
            }
            model.price = String(format: "%.2f", Double(text) ?? 0)
            // 如果 proposedText 符合格式，就允许更改
            return isNumber
        }
        return true
    }
}

extension PublishTaskViewController: UITextViewDelegate {
        
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: text)
        if text == hhf {
            textView.resignFirstResponder()
            return false
        }
        
        if textView == nameTV { // 昵称输入
            model.name = newText
            updateBottomBtnState()
            return newText.count <= 68
        }
        
        if textView == linkTV { // 链接输入
            model.link = newText
            updateBottomBtnState()
        }
        
        if textView == explainTV { // 任务说明
            model.intro = newText
            updateBottomBtnState()
            return newText.count <= 200
        }
        
        return true
    }
}
