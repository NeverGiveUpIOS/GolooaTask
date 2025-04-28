//
//  BasNavBarView.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/7/23.
//

import UIKit

class BasNavBarView: BasView {

    var navTitle: UILabel?
    var backItem: UIButton?
    var rightItem: UIButton?

    override func addWeights() {
        super.addWeights()
        
        backItem = createButton(UIImage(named: ""))
        navTitle = createLab(.black, UIFontMedium(16), textAlignment: .center)
        rightItem = createButton(.black, UIFontReg(14))
        rightItem?.contentMode = .right
        rightItem?.isHidden = true
        gt.addSubviews([navTitle!, backItem!, rightItem!])
    }
    
    override func addLayout() {
        super.addLayout()
        
        backItem?.snp.makeConstraints { make in
            make.leading.equalTo(16)
            make.bottom.equalTo(-6)
            make.width.equalTo(50)
            make.height.equalTo(40)
        }
        rightItem?.snp.makeConstraints { make in
            make.centerY.equalTo(backItem!)
            make.trailing.equalTo(-16)
            make.height.equalTo(40)
        }
        
        navTitle?.snp.makeConstraints { make in
            make.centerY.equalTo(backItem!)
            make.centerX.equalToSuperview()
        }
    }
    
}
