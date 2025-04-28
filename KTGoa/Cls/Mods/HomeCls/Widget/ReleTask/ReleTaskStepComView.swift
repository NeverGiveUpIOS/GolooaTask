//
//  ReleTaskStepComView.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/7/25.
//

import UIKit

class ReleTaskStepComView: UIView, GTNibLoadable {
    
    @IBOutlet weak var stepLab: UILabel!
    @IBOutlet weak var jxAddStep: UIButton!
    @IBOutlet weak var comStep: UIButton!
    @IBOutlet weak var comLeading: NSLayoutConstraint!
    @IBOutlet weak var pthsLab: UILabel!
    
    var callJXBlock: CallBackVoidBlock?
    var isComBool = false
    var callResult: CallBackBoolBlock?

    override func layoutSubviews() {
        super.layoutSubviews()
        jxAddStep.setDashedBorder(color: UIColorHex("#999999"), lineWidth: 1, space: 4)
        stepLab.layer.cornerRadius = 6
        stepLab.clipsToBounds = true;
    }
    
    
    @IBAction func jxAddStepClick(_ sender: Any) {
       getTopController().view.gt.keyboardEnd()
        callJXBlock?()
    }
    
    @IBAction func comStepClick(_ sender: Any) {
       getTopController().view.gt.keyboardEnd()
        jxAddStep.isHidden = true
        comStep.isHidden = true
        pthsLab.isHidden = false
        isComBool = true
        callResult?(isComBool)
    }
    
    func setStepNumber(_ number: Int) {
        jxAddStep.isHidden = (number == 3 || isComBool)
        comLeading.constant = number == 3 ? 15 : 172
        stepLab.text = "No.\(number + 1)"
    }

}
