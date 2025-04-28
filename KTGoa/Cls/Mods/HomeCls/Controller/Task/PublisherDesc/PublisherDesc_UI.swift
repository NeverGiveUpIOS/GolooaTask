//
//  PublisherDesc_UI.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/8/7.
//

import Foundation

extension PublisherDescViewController {
    
    func buildUI() {
        
        navBagColor(.clear)

        view.insertSubview(bgView, at: 0)
        view.addSubview(arcView)
        view.addSubview(avatarView)
        view.addSubview(nameLabel)
        view.addSubview(idLabel)
        view.addSubview(chatBtn)
        view.addSubview(editBtn)
        view.addSubview(rzIcon)
        view.addSubview(pubNameLabel)
        view.addSubview(introIcon)
        view.addSubview(introLabel)
        view.addSubview(titleLabel)
        setupHeadRefresh()
        setupFootRefresh()
        tableView?.rowHeight = 120
        tableView?.gt.register(cellClass: HomeListCell.self)
        view.addSubview(pubBtn)
        
        bgView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(200)
        }
        
        arcView.snp.makeConstraints { make in
            make.top.equalTo(bgView.snp.bottom).offset(-33)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(33)
        }
        
        avatarView.snp.makeConstraints { make in
            make.top.equalTo(arcView.snp.top).offset(-34)
            make.leading.equalTo(15)
            make.width.height.equalTo(100)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarView.snp.trailing).offset(7)
            make.trailing.equalTo(-10)
            make.top.equalTo(arcView.snp.top).offset(13)
        }
        
        idLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(13)
            make.leading.equalTo(nameLabel)
        }
        
        chatBtn.snp.makeConstraints { make in
            make.centerY.equalTo(idLabel.snp.centerY)
            make.trailing.equalTo(-15)
            make.width.height.equalTo(25)
        }
        
        editBtn.snp.makeConstraints { make in
            make.centerY.equalTo(idLabel.snp.centerY)
            make.trailing.equalTo(-23.5)
            make.width.height.equalTo(25)
        }
        
        rzIcon.snp.makeConstraints { make in
            make.top.equalTo(avatarView.snp.bottom).offset(32)
            make.leading.equalTo(20)
            make.width.height.equalTo(15)
        }
        
        pubNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(rzIcon.snp.centerY)
            make.leading.equalTo(rzIcon.snp.trailing).offset(8.5)
            make.trailing.equalTo(-15)
        }
        
        introIcon.snp.makeConstraints { make in
            make.top.equalTo(rzIcon.snp.bottom).offset(14.5)
            make.leading.equalTo(rzIcon)
            make.width.height.equalTo(15)
        }
        
        introLabel.snp.makeConstraints { make in
            make.centerY.equalTo(introIcon.snp.centerY)
            make.leading.equalTo(introIcon.snp.trailing).offset(8.5)
            make.trailing.equalTo(-15)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(introIcon.snp.bottom).offset(32)
            make.leading.equalTo(19)
        }
        
        pubBtn.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.trailing.equalTo(-12.5)
            make.width.height.equalTo(47)
        }
        
        tableView?.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(1)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(-safeAreaBt)
        }
    }
    
    func bind(model: PublisherDescModel) {
        self.model = model
        
        avatarView.headerImageUrl(model.extra.user.avatar)
        nameLabel.text = model.extra.user.name
        idLabel.text = "ID \(model.extra.user.id)"
        chatBtn.isHidden = model.extra.user.isSelf
        editBtn.isHidden = !model.extra.user.isSelf
        pubBtn.isHidden = !model.extra.user.isSelf
        pubNameLabel.text = model.extra.user.publishName
        introLabel.text = model.extra.user.slogan
        titleLabel.text = "\("postedTasks".homeLocalizable()) (\(model.list.count))"
    }
    
}
