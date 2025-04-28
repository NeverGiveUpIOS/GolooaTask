//
//  PublishTask_UI.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/8/6.
//

import UIKit

extension PublishTaskViewController {
    
    func buildUI() {
        navBagColor(.clear)
        view.insertSubview(scrollView, at: 0)
        scrollView.addSubview(bgView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(arcView)
        scrollView.addSubview(nameTitle)
        scrollView.addSubview(nameTV)
        if !GlobalHelper.shared.inEndGid {
            scrollView.addSubview(linkTitle)
            scrollView.addSubview(linkTV)
        }
        scrollView.addSubview(imageTitle)
        scrollView.addSubview(addImgView)
        if !GlobalHelper.shared.inEndGid {
            scrollView.addSubview(registTitle)
            scrollView.addSubview(registContent)
            registContent.addSubview(registTF)
        }
        scrollView.addSubview(explainTitle)
        scrollView.addSubview(explainTV)
        scrollView.addSubview(timeTitle)
        scrollView.addSubview(timeContent)
        
        timeContent.addSubview(timeStartBtn)
        timeContent.addSubview(timeSeparator)
        timeContent.addSubview(timeEndBtn)
        scrollView.addSubview(stepTitle)
        scrollView.addSubview(stepView)
        view.addSubview(bottomBtn)
        view.addSubview(maskBg)
        editToolView.frame = CGRect(x: 0, y: screH, width: screW, height: 54)
        view.addSubview(editToolView)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(25)
            make.top.equalTo(naviH + 8 + statusBarH)
        }
        
        maskBg.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(-naviH)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(-91 - safeAreaTp)
        }
        
        bgView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.width.equalTo(screW)
            make.height.equalTo(300)
        }
        
        arcView.snp.makeConstraints { make in
            make.top.equalTo(bgView.snp.bottom).offset(-33)
            make.leading.trailing.equalToSuperview()
            make.width.equalTo(screW)
            make.height.equalTo(33)
        }
        
        nameTitle.snp.makeConstraints { make in
            make.top.equalTo(arcView.snp.bottom)
            make.leading.equalTo(19)
        }
        
        nameTV.snp.makeConstraints { make in
            make.top.equalTo(nameTitle.snp.bottom).offset(7)
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.width.equalTo(screW - 30)
            make.height.equalTo(55)
        }
        
        if !GlobalHelper.shared.inEndGid {
            linkTitle.snp.makeConstraints { make in
                make.top.equalTo(nameTV.snp.bottom).offset(18)
                make.leading.equalTo(19)
            }
            
            linkTV.snp.makeConstraints { make in
                make.top.equalTo(linkTitle.snp.bottom).offset(7)
                make.leading.equalTo(15)
                make.trailing.equalTo(-15)
                make.width.equalTo(screW - 30)
                make.height.equalTo(55)
            }
            
            imageTitle.snp.makeConstraints { make in
                make.top.equalTo(linkTV.snp.bottom).offset(18)
                make.leading.equalTo(19)
            }
        } else {
            imageTitle.snp.makeConstraints { make in
                make.top.equalTo(nameTV.snp.bottom).offset(18)
                make.leading.equalTo(19)
            }
        }
        
        addImgView.snp.makeConstraints { make in
            make.top.equalTo(imageTitle.snp.bottom).offset(7)
            make.leading.equalTo(15)
            make.width.height.equalTo(120)
        }
        
        if !GlobalHelper.shared.inEndGid {
            registTitle.snp.makeConstraints { make in
                make.top.equalTo(addImgView.snp.bottom).offset(20)
                make.leading.equalTo(19)
            }
            
            registContent.snp.makeConstraints { make in
                make.top.equalTo(registTitle.snp.bottom).offset(7)
                make.leading.equalTo(15)
                make.trailing.equalTo(-15)
                make.width.equalTo(screW - 30)
                make.height.equalTo(55)
            }
            registTF.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            explainTitle.snp.makeConstraints { make in
                make.top.equalTo(registContent.snp.bottom).offset(18)
                make.leading.equalTo(19)
            }
        } else {
            explainTitle.snp.makeConstraints { make in
                make.top.equalTo(addImgView.snp.bottom).offset(18)
                make.leading.equalTo(19)
            }
        }
        
        explainTV.snp.makeConstraints { make in
            make.top.equalTo(explainTitle.snp.bottom).offset(7)
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.width.equalTo(screW - 30)
            make.height.equalTo(120)
        }
        
        timeTitle.snp.makeConstraints { make in
            make.top.equalTo(explainTV.snp.bottom).offset(18)
            make.leading.equalTo(19)
        }
        
        timeContent.snp.makeConstraints { make in
            make.top.equalTo(timeTitle.snp.bottom).offset(7)
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.width.equalTo(screW - 30)
            make.height.equalTo(55)
        }
        
        timeStartBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(timeSeparator.snp.leading)
        }
        
        timeSeparator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        timeEndBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(timeSeparator.snp.trailing)
        }
        
        stepTitle.snp.makeConstraints { make in
            make.top.equalTo(timeContent.snp.bottom).offset(26)
            make.leading.equalTo(19)
        }
        
        stepView.snp.makeConstraints { make in
            make.top.equalTo(stepTitle.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview()
            make.width.equalTo(screW)
            make.height.equalTo(0)
            make.bottom.equalTo(-70)
        }
        
        bottomBtn.snp.makeConstraints { make in
            make.bottom.equalTo(-39 - safeAreaTp)
            make.leading.equalTo(30)
            make.trailing.equalTo(-30)
            make.height.equalTo(52)
        }
    }
    
    func updateUI(_ descModel: TaskDescModel) {
        
        nameTV.text = descModel.name
        model.name = descModel.name
        
        linkTV.text = descModel.traLink
        model.link = descModel.traLink
        
        addImgView.imageView.normalImageUrl(descModel.img)
        addImgView.imageView.isHidden = descModel.img.isEmpty
        addImgView.clear.isHidden = descModel.img.isEmpty
        model.cover = descModel.img
        
        registTF.text = descModel.jiageDes
        model.price = "\(descModel.jiage)"
        
        explainTV.text = descModel.iro
        model.intro = descModel.iro
        
        if descModel.startDate > 0 {
            let formatter = DateFormatter(format: "yyyy-MM-dd")
            let startDate = Date(timeIntervalSince1970: TimeInterval(descModel.startDate/1000))
            let startTime = formatter.string(from: startDate)
            timeStartBtn.isSelected = true
            timeStartBtn.setTitle(startTime, for: .normal)
            model.startTime = startTime
        }
        
        if descModel.endDate > 0 {
            let formatter = DateFormatter(format: "yyyy-MM-dd")
            let endDate = Date(timeIntervalSince1970: TimeInterval(descModel.endDate/1000))
            let endTime = formatter.string(from: endDate)
            timeEndBtn.isSelected = true
            timeEndBtn.setTitle(endTime, for: .normal)
            model.endTime = endTime
        }
        
        if timeStartBtn.isSelected, timeEndBtn.isSelected {
            timeSeparator.textColor = .black
        }
        
        descModel.steps.forEach { model in
            model.type = .edit
            model.isShowDelete = true
        }
        stepView.dataSource = descModel.steps
        if descModel.steps.count >= 3 {
            let finish = TaskStepModel()
            finish.type = .addLast
            stepView.dataSource.append(finish)
        } else {
            let finish = TaskStepModel()
            finish.type = .add
            stepView.dataSource.append(finish)
        }
        stepView.reloadData()
        model.stepArr = stepView.dataSource
        
        updateBottomBtnState()
    }
}

extension PublishTaskViewController {
    
    func subViewsHandle() {
        
        stepView.tapEidtTitleBlock = { [weak self] item, text in
            self?.isEditStep = true
            self?.editToolTF.becomeFirstResponder()
            self?.editToolTF.text = text
            self?.currentStep = item
        }
        
        stepView.updateLayoutBlock = { [weak self] height in
            guard let self = self else { return }
            self.stepView.snp.updateConstraints { make in
                make.height.equalTo(height)
            }
        }
        
        stepView.didFinishBlock = { [weak self] in
            guard let self = self else { return }
            self.updateBottomBtnState()
        }
    }
    
    func updateBottomBtnState() {
        guard !nameTV.text.isEmpty else {
            bottomBtn.isSelected = false
            return
        }
        
        if !GlobalHelper.shared.inEndGid {
            guard !linkTV.text.isEmpty else {
                bottomBtn.isSelected = false
                return
            }
        }
        
        if model.logo == nil, model.cover.isEmpty {
            bottomBtn.isSelected = false
            return
        }
        
        if !GlobalHelper.shared.inEndGid {
            guard registTF.text != nil, !registTF.text!.isEmpty else {
                bottomBtn.isSelected = false
                return
            }
        }
        
        guard !explainTV.text.isEmpty else {
            bottomBtn.isSelected = false
            return
        }
        guard !model.startTime.isEmpty, !model.endTime.isEmpty else {
            bottomBtn.isSelected = false
            return
        }
        guard stepView.isEditFinish else {
            bottomBtn.isSelected = false
            return
        }
        bottomBtn.isSelected = true
    }
    
}
