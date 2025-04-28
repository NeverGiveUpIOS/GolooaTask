//
//  MsgSystemViewCell.swift
//  Golaa
//
//  Created by chenkaisong on 2024/5/17.
//

import UIKit

class MsgSystemViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        setupSubviews()
    }
    
    func setupSysData(_ msgModel: ChatMsgModel) {
        contentLab.text = msgModel.msg?.text
        contentLab.gt.setTextLineSpace(5)
        if let systemModel = msgModel.systemModel {
            if systemModel.color.count > 0 {
                contentLab.gt.setSpecificTextColor(systemModel.highlight, color: .hexStrToColor(systemModel.color))
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var contView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.gt.setCornerRadius(12)
        return view
    }()
    
    private lazy var contentLab: UILabel = {
        let label = UILabel()
        label.font = UIFontReg(14)
        label.textColor = .hexStrToColor("#000000")
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
}

extension MsgSystemViewCell {
    
    private func setupSubviews() {
        
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(contView)
        contView.addSubview(contentLab)
        
        contView.snp.makeConstraints { make in
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.bottom.equalTo(-7.5)
            make.top.equalTo(7.5)
        }
        
        contentLab.snp.makeConstraints { make in
            make.leading.top.equalTo(15)
            make.trailing.bottom.equalTo(-15)
            
        }
        
    }
    
}
