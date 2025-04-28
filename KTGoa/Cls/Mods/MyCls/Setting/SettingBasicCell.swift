//
//  MineBasicCell.swift
//  Golaa
//
//  Created by Cb on 2024/5/17.
//

import Foundation

class SettingBasicCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configViews()
        configActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configViews() {
        selectionStyle = .none
        contentView.backgroundColor = UIColor.xf2

        addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.top.bottom.equalToSuperview()
        }
        
        bgView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(15)
            make.centerY.equalToSuperview()
        }
        
        bgView.addSubview(rightBtn)
        rightBtn.snp.makeConstraints { make in
            make.trailing.equalTo(-15)
            make.centerY.equalToSuperview()
        }
    }
    
    func configActions() {
        
    }
    
    // MARK: - 属性
    
    let bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let titleLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = .hexStrToColor("#343740")
        lab.font = .boldSystemFont(ofSize: 14)
        return lab
    }()
    
    let rightBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(.settingRight, for: .normal)
        return btn
    }()
}
