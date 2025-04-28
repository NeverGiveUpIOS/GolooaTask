//
//  TaskStepAddCell.swift
//  Golaa
//
//  Created by duke on 2024/5/16.
//

import UIKit

class TaskStepAddCell: TaskBaseStepCell {
    
    var clickAddSetpBlock: ((TaskStepModel) -> Void)?
    var clickFinishBlock: ((TaskStepModel) -> Void)?
    
    override func buildUI() {
        super.buildUI()
        
        contentView.addSubview(addBtn)
        contentView.addSubview(finishBtn)
        
        stepLabel.snp.remakeConstraints { make in
            make.leading.equalTo(19)
            make.top.equalTo(5)
            make.width.equalTo(40)
            make.height.equalTo(23)
        }
        
        addBtn.snp.makeConstraints { make in
            make.leading.equalTo(stepLabel.snp.trailing).offset(15)
            make.centerY.equalToSuperview()
            make.width.equalTo(153)
            make.height.equalTo(33)
        }
        
        finishBtn.snp.makeConstraints { make in
            make.leading.equalTo(addBtn.snp.trailing).offset(14)
            make.centerY.equalToSuperview()
            make.width.equalTo(83)
            make.height.equalTo(33)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addBtn.setDashedBorder(color: UIColorHex("#999999"), lineWidth: 1)
    }
    
    override func bind(_ model: TaskStepModel) {
        super.bind(model)
        
        if model.type == .add {
            addBtn.isHidden = false
            finishBtn.snp.remakeConstraints { make in
                make.leading.equalTo(addBtn.snp.trailing).offset(14)
                make.centerY.equalToSuperview()
                make.width.equalTo(83)
                make.height.equalTo(33)
            }
        } else if model.type == .addLast {
            addBtn.isHidden = true
            finishBtn.snp.remakeConstraints { make in
                make.leading.equalTo(stepLabel.snp.trailing).offset(15)
                make.centerY.equalToSuperview()
                make.width.equalTo(83)
                make.height.equalTo(33)
            }
        }
    }
    
    @objc private func clickAddSetpBtn(sender: UIButton) {
        guard let model = model else { return }
        clickAddSetpBlock?(model)
    }
    
    @objc private func clickFinishBtn(sender: UIButton) {
        guard let model = model else { return }
        clickFinishBlock?(model)
    }
    
    private lazy var addBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.image(.addStep)
        btn.setTitle(" \("continueToAdd".homeLocalizable())", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFontReg(12)
        btn.gt.setCornerRadius(6)
        btn.addTarget(self, action: #selector(clickAddSetpBtn), for: .touchUpInside)
        return btn
    }()
    
    private lazy var finishBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("complete".homeLocalizable(), for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFontSemibold(12)
        btn.backgroundColor = .appColor
        btn.layer.cornerRadius = 6
        btn.addTarget(self, action: #selector(clickFinishBtn), for: .touchUpInside)
        return btn
    }()
}
