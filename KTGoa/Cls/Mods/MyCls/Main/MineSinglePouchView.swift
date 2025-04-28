//
//  MineSinglePouchView.swift
//  Golaa
//
//  Created by Cb on 2024/5/29.
//

import Foundation

class MineSinglePouchView: MinePouchView {
    
    override func configViews() {
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stackView.addArrangedSubview(rightView)
        rightView.snp.makeConstraints { make in
            make.height.equalToSuperview()
        }
    }

}
