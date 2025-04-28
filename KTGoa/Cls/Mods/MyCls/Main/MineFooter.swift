//
//  MineFooter.swift
//  Golaa
//
//  Created by Cb on 2024/5/13.
//

import Foundation

class MineFooter: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configViews()
        configActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configViews() {
        backgroundColor = .white
    }
    
    private func configActions() {}
    
    // MARK: - 属性
}
