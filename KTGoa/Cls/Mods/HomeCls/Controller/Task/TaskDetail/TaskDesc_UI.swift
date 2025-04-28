//
//  TaskDesc_UI.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/8/7.
//

import Foundation

extension TaskDescViewController {
    
    func buildUI() {
        
        navBagColor(.xf2)
        
        navTitle("taskDetails".homeLocalizable())
        view.backgroundColor = .xf2
        view.addSubview(scrollView)
        scrollView.addSubview(logoView)
        scrollView.addSubview(nameLabel)
        if !GlobalHelper.shared.inEndGid {
            scrollView.addSubview(priceLabel)
        }
        scrollView.addSubview(numLabel)
        scrollView.addSubview(danbaoLabel)
        scrollView.addSubview(pubUserView)
        scrollView.addSubview(chatBtn)
        scrollView.addSubview(arcView)
        scrollView.addSubview(introTitle)
        scrollView.addSubview(idLabel)
        scrollView.addSubview(idCopyBtn)
        scrollView.addSubview(introLabel)
        if !GlobalHelper.shared.inEndGid {
            scrollView.addSubview(linkTitle)
            scrollView.addSubview(linkContent)
            linkContent.addSubview(linkLabel)
            linkContent.addSubview(linkCopyBtn)
        }
        scrollView.addSubview(stepTitle)
        scrollView.addSubview(stepView)
        view.addSubview(bottomView)
        bottomView.addSubview(bottomBtn)
        bottomView.addSubview(bottomDescBtn)
        
        stepView.updateLayoutBlock = { [weak self] height in
            guard let self = self else { return }
            self.stepView.snp.updateConstraints { make in
                make.height.equalTo(height)
            }
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(naviH)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(-55 - 52 - safeAreaTp)
        }
        
        logoView.snp.makeConstraints { make in
            make.top.equalTo(35)
            make.leading.equalTo(15)
            make.width.height.equalTo(80)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(39)
            make.leading.equalTo(logoView.snp.trailing).offset(15)
            make.width.equalTo(screW - 110 - 15)
        }
        if !GlobalHelper.shared.inEndGid {
            priceLabel.snp.makeConstraints { make in
                make.top.equalTo(nameLabel.snp.bottom).offset(5)
                make.leading.equalTo(logoView.snp.trailing).offset(15)
            }
        }
        numLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.trailing.equalTo(-15)
        }
        
        danbaoLabel.snp.makeConstraints { make in
            make.leading.equalTo(15)
            make.top.equalTo(logoView.snp.bottom).offset(23.5)
            make.height.equalTo(14)
        }
        
        pubUserView.snp.makeConstraints { make in
            make.centerY.equalTo(danbaoLabel.snp.centerY)
            make.leading.equalTo(danbaoLabel.snp.trailing).offset(10)
            make.trailing.lessThanOrEqualTo(chatBtn.snp.leading).offset(-10)
        }
        
        chatBtn.snp.makeConstraints { make in
            make.centerY.equalTo(danbaoLabel.snp.centerY)
            make.trailing.equalTo(-15)
            make.width.height.equalTo(25)
        }
        
        arcView.snp.makeConstraints { make in
            make.top.equalTo(danbaoLabel.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview()
            make.width.equalTo(screW)
            make.bottom.equalTo(500)
        }
        
        introTitle.snp.makeConstraints { make in
            make.top.equalTo(danbaoLabel.snp.bottom).offset(65)
            make.leading.equalTo(15)
        }
        
        idLabel.snp.makeConstraints { make in
            make.centerY.equalTo(introTitle.snp.centerY)
            make.trailing.equalTo(idCopyBtn.snp.leading).offset(-3)
        }
        
        idCopyBtn.snp.makeConstraints { make in
            make.centerY.equalTo(idLabel.snp.centerY)
            make.trailing.equalTo(-12)
            make.width.height.equalTo(15)
        }
        
        introLabel.snp.makeConstraints { make in
            make.top.equalTo(introTitle.snp.bottom).offset(10)
            make.leading.equalTo(15)
            make.width.equalTo(screW - 30)
        }
        
        if !GlobalHelper.shared.inEndGid {
            linkTitle.snp.makeConstraints { make in
                make.top.equalTo(introLabel.snp.bottom).offset(25)
                make.leading.equalTo(15)
            }
            
            linkContent.snp.makeConstraints { make in
                make.top.equalTo(linkTitle.snp.bottom).offset(11.5)
                make.leading.equalTo(15)
                make.trailing.equalTo(-15)
                make.width.equalTo(screW - 30)
                make.height.greaterThanOrEqualTo(55)
            }
            
            linkLabel.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.leading.equalTo(15)
                make.trailing.equalTo(linkCopyBtn.snp.leading).offset(-10)
                make.top.greaterThanOrEqualTo(5)
                make.bottom.lessThanOrEqualTo(-5)
            }
            
            linkCopyBtn.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.trailing.equalTo(-15)
                make.width.height.equalTo(15)
            }
            
            stepTitle.snp.makeConstraints { make in
                make.top.equalTo(linkContent.snp.bottom).offset(32.5)
                make.leading.equalTo(15)
            }
        } else {
            stepTitle.snp.makeConstraints { make in
                make.top.equalTo(introLabel.snp.bottom).offset(25)
                make.leading.equalTo(15)
            }
        }
        
        stepView.snp.makeConstraints { make in
            make.top.equalTo(stepTitle.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview()
            make.width.equalTo(screW)
            make.height.equalTo(0)
            make.bottom.equalTo(-70)
        }
        
        bottomView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(55.66 + 52 + safeAreaTp)
        }
        
        bottomBtn.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(30)
            make.trailing.equalTo(-30)
            make.height.equalTo(52)
        }
        
        bottomDescBtn.snp.makeConstraints { make in
            make.top.equalTo(bottomBtn.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    func bind(_ model: TaskDescModel) {
        self.model = model
        logoView.normalImageUrl(model.img)
        nameLabel.text = model.name
        priceLabel.text = model.jiageDes
        numLabel.text = String(format: "%@ %d/%d", "joined".homeLocalizable(), model.recCount, model.num)
        danbaoLabel.isHidden = !model.isSecity
        (pubUserView.viewWithTag(100) as? UIImageView)?.headerImageUrl(model.user.avatar)
        (pubUserView.viewWithTag(101) as? UILabel)?.text = !model.user.pubName.isEmpty ? model.user.pubName : model.user.name
        chatBtn.isHidden = model.isOwr
        idLabel.text = String(format: "%@ %d", "taskId".homeLocalizable(), model.id)
        introLabel.text = model.iro
        linkLabel.text = model.traLink
        stepView.dataSource = model.steps
        let finish = TaskStepModel()
        finish.type = .finish
        stepView.dataSource.append(finish)
        stepView.reloadData()
        linkTitle.isHidden = model.traLink.isEmpty
        linkContent.isHidden = model.traLink.isEmpty
        bottomBtn.isHidden = false
        bottomBtn.isSelected = false
        bottomDescBtn.isEnabled = false
        bottomDescBtn.isHidden = false
        
        rightItem(.taskShare)
        
        bottomDescBtn.setTitleColor(.hexStrToColor("#999999"), for: .normal)
        
        if model.isStart, model.status == 2 { // 进行中
            if model.isOwr { // b
                startTimer()
                bottomBtn.setTitle("viewTaskDataDetails".homeLocalizable(), for: .normal)
                bottomDescBtn.setTitle(String(format: "%@：%@", "taskCountdown".homeLocalizable(), model.surTime), for: .normal)
                bottomDescBtn.setTitleColor(.hexStrToColor("#FF5722"), for: .normal)
            } else { // c
                if model.recStatus == .canRec { // 可领取
                    linkTitle.isHidden = true
                    linkContent.isHidden = true
                    bottomDescBtn.isHidden = true
                    bottomBtn.setTitle("claimTask".homeLocalizable(), for: .normal)
                } else if model.recStatus == .unrec { // 已抢光
                    linkTitle.isHidden = true
                    linkContent.isHidden = true
                    bottomDescBtn.isHidden = true
                    bottomBtn.setTitle("claimTask".homeLocalizable(), for: .normal)
                    bottomBtn.isSelected = true
                } else { // 已领取
                    startTimer()
                    bottomBtn.setTitle("viewTaskDataDetails".homeLocalizable(), for: .normal)
                    bottomDescBtn.setTitle(String(format: "%@：%@", "taskCountdown".homeLocalizable(), model.surTime), for: .normal)
                    bottomDescBtn.setTitleColor(.hexStrToColor("#FF5722"), for: .normal)
                }
            }
        } else if model.status == 3 { // 已结束
            stopTimer()
            if model.isOwr { // b
                bottomBtn.setTitle("viewTaskDataDetails".homeLocalizable(), for: .normal)
                bottomDescBtn.setTitle("taskCompleted".homeLocalizable(), for: .normal)
            } else { // c
                if model.recStatus == .reced {
                    bottomBtn.setTitle("viewTaskDataDetails".homeLocalizable(), for: .normal)
                } else {
                    bottomBtn.isHidden = true
                }
                bottomDescBtn.setTitle("taskCompleted".homeLocalizable(), for: .normal)
            }
        } else if !model.isStart { // 未开始
            if model.isOwr { // b
                bottomBtn.setTitle("viewTaskDataDetails".homeLocalizable(), for: .normal)
                bottomDescBtn.setTitle("taskNotStarted".homeLocalizable(), for: .normal)
            } else { // c
                bottomBtn.isHidden = true
                bottomDescBtn.setTitle("taskNotStarted".homeLocalizable(), for: .normal)
            }
        }
        
        if linkTitle.isHidden || linkContent.isHidden {
            stepTitle.snp.remakeConstraints { make in
                make.top.equalTo(introLabel.snp.bottom).offset(25)
                make.leading.equalTo(15)
            }
        } else {
            if GlobalHelper.shared.inEndGid {
                stepTitle.snp.remakeConstraints { make in
                    make.top.equalTo(introLabel.snp.bottom).offset(25)
                    make.leading.equalTo(15)
                }
            } else {
                stepTitle.snp.remakeConstraints { make in
                    make.top.equalTo(linkContent.snp.bottom).offset(32.5)
                    make.leading.equalTo(15)
                }
            }
        }
    }
    
}
