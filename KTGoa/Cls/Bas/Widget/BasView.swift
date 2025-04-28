//
//  BasView.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/7/23.
//

import UIKit

class BasView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addWeights()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addLayout()
    }
    
    func addWeights() {
        
    }
    
    func addLayout() {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
