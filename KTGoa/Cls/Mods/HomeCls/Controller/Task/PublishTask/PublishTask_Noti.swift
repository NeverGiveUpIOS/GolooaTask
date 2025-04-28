//
//  PublishTask_Noti.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/8/6.
//

import Foundation

extension PublishTaskViewController {
    
    func addTaskNoti() {
        // 监听键盘出现和隐藏的通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notice: Notification) {
        guard isEditStep else { return }
        guard let keyboardFrame = (notice.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return  }
        maskBg.isHidden = false
        UIView.animate(withDuration: 0.25) {
            self.editToolView.frame.origin.y = keyboardFrame.origin.y - self.editToolView.frame.size.height
        }
    }
    
    @objc private func keyboardWillHide(_ notice: Notification) {
        // 格式化任务单价
        if var text = registTF.text?.trimmingCharacters(in: .whitespaces), !text.isEmpty {
            if text.contains("$") {
                text = text.replacingOccurrences(of: "$", with: "")
            }
            self.model.price = String(format: "%.2f", Double(text) ?? 0)
            self.registTF.text = String(format: "$%.2f", Double(text) ?? 0)
        }
        
        guard isEditStep else { return }
        UIView.animate(withDuration: 0.25, delay: 0, animations: {
            self.editToolView.frame.origin.y = screH
        }, completion: { _ in
            self.maskBg.isHidden = true
        })
        self.isEditStep = false
    }
    
}
