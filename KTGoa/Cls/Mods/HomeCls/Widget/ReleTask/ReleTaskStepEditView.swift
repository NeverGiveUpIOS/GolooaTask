//
//  ReleTaskStepEditView.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/7/26.
//

import UIKit

class ReleTaskStepEditView: UIView, UITextViewDelegate, GTNibLoadable {

    @IBOutlet weak var cnoView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var clearBtn: UIButton!
    
    var callEditText: CallBackStringBlock?
    
    var editText = ""

    override func layoutSubviews() {
        super.layoutSubviews()
        cnoView.gt.addCorner(conrners: [.topLeft, .topRight], radius: 6)
    }
    
    @IBAction func sureClick(_ sender: Any) {
        textView.resignFirstResponder()
        callEditText?(editText)
    }
    
    @IBAction func clearClick(_ sender: Any) {
        textView.text = ""
        clearBtn.isHidden = true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let str = (textView.text as NSString).replacingCharacters(in: range, with: text)
        clearBtn.isHidden = !(str.count > 0)
        editText = str
        return true
    }
    
}
