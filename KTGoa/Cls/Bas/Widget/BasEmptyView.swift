//
//  BasEmptyView.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/7/24.
//

import UIKit

class BasEmptyView: BasView {
    
    var emptyImage: UIImageView?
    var emptyLab: UILabel?
    
    override func addWeights() {
        super.addWeights()
        
        emptyImage = UIImageView(image: .emptyDataIcon)
        emptyLab = createLab(UIColorHex("#999999"), UIFontReg(12), text: "Os dados estão vazios", textAlignment: .center)
        emptyLab?.numberOfLines = 0
        
        gt.addSubviews([emptyImage!, emptyLab!])
    }
    
    func setupEmptyImg(_ img: UIImage = .emptyDataIcon, _ text: String = "dataEmpty".globalLocalizable()) {
        emptyImage?.image = img
        emptyLab?.text = text
        emptyImage?.sizeToFit()
    }
    
    override func addLayout() {
        super.addLayout()
        
        emptyImage?.snp.makeConstraints { make in
            make.leading.right.equalToSuperview()
            make.top.equalToSuperview()
        }
        emptyImage?.sizeToFit()
        
        emptyLab?.snp.makeConstraints({ make in
            make.top.equalTo(emptyImage!.snp.bottom).offset(10)
            make.leading.right.equalToSuperview()
            make.bottom.equalToSuperview()
        })
    }
    
}
