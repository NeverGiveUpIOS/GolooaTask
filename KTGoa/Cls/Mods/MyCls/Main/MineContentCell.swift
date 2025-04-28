//
//  MineContentCell.swift
//  Golaa
//
//  Created by Cb on 2024/5/13.
//

import Foundation

class MineContentCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configViews()
        configActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configViews() {
        selectionStyle = .none
        backgroundColor = .hexStrToColor("#F2F2F2")
        contentView.backgroundColor = .hexStrToColor("#F2F2F2")
        
        bgView.layer.cornerRadius = 14.0
        bgView.clipsToBounds = true
        bgView.backgroundColor = .white
        contentView.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(MineLayout.padingLeading)
            make.trailing.equalTo(-MineLayout.padingLeading)
            make.bottom.equalTo(-MineLayout.padingLeading)
        }
            
        bgView.addSubview(listView)
        listView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(MineLayout.leadingMargin)
            make.trailing.equalTo(-MineLayout.leadingMargin)
        }
    }
    
    private func configActions() {
        
    }
    
    // MARK: - 属性
    private let titleLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = .black
        lab.font = .systemFont(ofSize: 16)
        return lab
    }()
    
    private lazy var bgView = UIView()
    lazy var listView = MineCollectionView()
}
