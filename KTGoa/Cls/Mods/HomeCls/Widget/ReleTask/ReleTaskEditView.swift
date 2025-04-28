//
//  ReleTaskEditView.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/7/25.
//

import UIKit

class ReleTaskEditView: UIView, UITextViewDelegate, GTNibLoadable {

    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var placeHoldText: UILabel!
    
    var callResult: CallBackStringBlock?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let toolbar = UIToolbar()
          toolbar.sizeToFit()
          
          let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
          let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
          toolbar.items = [flexibleSpace, doneButton]
          
        textView.inputAccessoryView = toolbar
    }

    @objc func doneButtonTapped() {
        textView.resignFirstResponder()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let str = (textView.text as NSString).replacingCharacters(in: range, with: text)

        placeHoldText.isHidden = str.count > 0
        callResult?(str)
        return true
    }
}
