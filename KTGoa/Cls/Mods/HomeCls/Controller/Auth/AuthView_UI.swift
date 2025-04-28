//
//  AuthView_UI.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/8/7.
//

import Foundation

extension AuthViewController {
    
    func buildUI() {
        hiddenNavView(true)
        view.addSubview(scrollView)
        scrollView.addSubview(bgView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(arcView)
        scrollView.addSubview(nameTitle)
        scrollView.addSubview(nameTV)
        scrollView.addSubview(emailTitle)
        scrollView.addSubview(emailTV)
        scrollView.addSubview(realNameTitle)
        scrollView.addSubview(realNameTV)
        scrollView.addSubview(imageTitle)
        scrollView.addSubview(addPhoto1View)
        scrollView.addSubview(addPhoto2View)
        view.addSubview(bottomBtn)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(25)
            make.top.equalTo(naviH + 8)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(-naviH)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(-105 - safeAreaBt)
        }
        
        bgView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.width.equalTo(screW)
            make.height.equalTo(244)
        }
        
        arcView.snp.makeConstraints { make in
            make.top.equalTo(bgView.snp.bottom).offset(-33)
            make.leading.trailing.equalToSuperview()
            make.width.equalTo(screW)
            make.height.equalTo(53)
        }
        
        nameTitle.snp.makeConstraints { make in
            make.bottom.equalTo(arcView.snp.bottom)
            make.leading.equalTo(19)
        }
        
        nameTV.snp.makeConstraints { make in
            make.top.equalTo(nameTitle.snp.bottom).offset(7)
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.width.equalTo(screW - 30)
            make.height.equalTo(55)
        }
        
        emailTitle.snp.makeConstraints { make in
            make.top.equalTo(nameTV.snp.bottom).offset(18)
            make.leading.equalTo(19)
        }
        
        emailTV.snp.makeConstraints { make in
            make.top.equalTo(emailTitle.snp.bottom).offset(7)
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.width.equalTo(screW - 30)
            make.height.equalTo(55)
        }
        
        realNameTitle.snp.makeConstraints { make in
            make.top.equalTo(emailTV.snp.bottom).offset(18)
            make.leading.equalTo(19)
        }
        
        realNameTV.snp.makeConstraints { make in
            make.top.equalTo(realNameTitle.snp.bottom).offset(7)
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.width.equalTo(screW - 30)
            make.height.equalTo(55)
        }
        
        imageTitle.snp.makeConstraints { make in
            make.top.equalTo(realNameTV.snp.bottom).offset(18)
            make.leading.equalTo(19)
            make.width.equalTo(screW - 38)
        }
        
        addPhoto1View.snp.makeConstraints { make in
            make.top.equalTo(imageTitle.snp.bottom).offset(38)
            make.leading.equalTo(66)
            make.width.equalTo(screW - 132)
            make.height.equalTo(140)
        }
        
        addPhoto2View.snp.makeConstraints { make in
            make.top.equalTo(addPhoto1View.snp.bottom).offset(40)
            make.leading.equalTo(66)
            make.width.equalTo(screW - 132)
            make.height.equalTo(140)
            make.bottom.equalTo(-40)
        }
        
        bottomBtn.snp.makeConstraints { make in
            make.bottom.equalTo(-53 - safeAreaBt)
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.height.equalTo(52)
        }
    }
    
    func updateBottomState() {
       guard !(nameTV.text ?? "").isEmpty else {
           bottomBtn.isSelected = false
           return
       }
       
       guard !(emailTV.text ?? "").isEmpty else {
           bottomBtn.isSelected = false
           return
       }
       
       guard !(realNameTV.text ?? "").isEmpty else {
           bottomBtn.isSelected = false
           return
       }
       
       guard image1 != nil, image2 != nil else {
           bottomBtn.isSelected = false
           return
       }
       
       bottomBtn.isSelected = true
   }
}
