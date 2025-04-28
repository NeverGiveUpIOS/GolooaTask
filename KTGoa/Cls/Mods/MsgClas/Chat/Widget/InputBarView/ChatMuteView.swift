//
//  ChatMuteView.swift
//  Golaa
//
//  Created by chenkaisong on 2024/5/25.
//

import UIKit

class ChatMuteView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(muteTitle)
        addSubview(addButton)
        
        muteTitle.snp.makeConstraints { make in
            make.leading.equalTo(15)
            make.height.equalTo(38)
            make.trailing.equalTo(-54)
            make.centerY.equalToSuperview()
        }
        
        addButton.snp.makeConstraints { make in
            make.centerY.equalTo(muteTitle)
            make.trailing.equalTo(-15)
            make.width.height.equalTo(24)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var addButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "chat_open_more"), for: .normal)
        return button
    }()
    
    private lazy var muteTitle: UILabel = {
        let label = UILabel()
        label.font = UIFontReg(12)
        label.textColor = .hexStrToColor("#999999")
        label.textAlignment = .center
        label.backgroundColor = .xf2
        label.gt.setCornerRadius(8)
        label.text = "muted".msgLocalizable()
        return label
    }()
}
