//
//  TaskStepCellT.swift
//  Golaa
//
//  Created by duke on 2024/5/16.
//

import UIKit

class TaskStepCell: TaskBaseStepCell {
    var placeholder = "editTaskImageAndTextInstructions".homeLocalizable()
    var tapEidtTitleBlock: ((TaskStepModel, String) -> Void)?
    var addImgBlock: ((UIImage) -> Void)?
    var clearImgBlock: ((TaskStepModel) -> Void)?
    var tapDeleteStepBlock: ((TaskStepModel) -> Void)?
    
    override func buildUI() {
        super.buildUI()
        
        contentView.addSubview(titleLab)
        contentView.addSubview(addImgView)
        contentView.addSubview(deleteLabel)
        contentView.addSubview(lineView)
        
        titleLab.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(stepLabel.snp.trailing).offset(18)
            make.trailing.equalTo(-15)
        }
        
        addImgView.snp.makeConstraints { make in
            make.leading.equalTo(titleLab.snp.leading)
            make.top.equalTo(titleLab.snp.bottom).offset(12)
            make.width.height.equalTo(120)
        }
        
        deleteLabel.snp.makeConstraints { make in
            make.trailing.equalTo(-15)
            make.bottom.equalTo(addImgView.snp.bottom).offset(-3)
            make.height.equalTo(15)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(stepLabel.snp.bottom)
            make.centerX.equalTo(stepLabel.snp.centerX)
            make.bottom.equalToSuperview()
            make.width.equalTo(1)
        }
    }
    
    override func bind(_ model: TaskStepModel) {
        super.bind(model)
        
        deleteLabel.isHidden = true
        lineView.isHidden = false
        titleLab.textColor = .black
        titleLab.backgroundColor = .clear
        switch model.type {
        case .edit:
            titleLab.backgroundColor = .xf2
            addImgView.isHidden = false
            deleteLabel.isHidden = !model.isShowDelete
            titleLab.text = model.explain.isEmpty ? placeholder : model.explain
            titleLab.textColor = model.explain.isEmpty ? .hexStrToColor("#999999") : .black
            addImgView.addIcon.isHidden = false
            addImgView.label.isHidden = false
            addImgView.imageView.isHidden = (model.image == nil && model.icon.isEmpty)
            addImgView.clear.isHidden = (model.image == nil && model.icon.isEmpty)
            if let image = model.image {
                addImgView.imageView.image = image
            } else if !model.icon.isEmpty {
                addImgView.imageView.normalImageUrl(model.icon)
            }
        case .step:
            addImgView.isHidden = model.icon.isEmpty
            addImgView.addIcon.isHidden = true
            addImgView.label.isHidden = true
            addImgView.imageView.isHidden = false
            addImgView.clear.isHidden = true
            titleLab.text = model.explain
            addImgView.imageView.normalImageUrl(model.icon)
        case .finish:
            lineView.isHidden = true
            addImgView.isHidden = true
            titleLab.text = "platformVerificationAndSettlement".homeLocalizable()
            titleLab.textColor = .hexStrToColor("#5B6FA3")
        default:
            break
        }
    }
    
    @objc private func tapEidtTitleAction(sender: UITapGestureRecognizer) {
        guard let model = model else { return }
        guard model.type == .edit else { return }
        var text = titleLab.text ?? ""
        if text == placeholder { text = "" }
        tapEidtTitleBlock?(model, text)
    }
    
    @objc private func tapDeleteStepAction(sender: UITapGestureRecognizer) {
        AlertPopView.show(titles: "tip".homeLocalizable(), contents: "confirmDeletionOfStep".homeLocalizable()) { [weak self] in
            guard let self = self else { return }
            guard let model = self.model else { return }
            self.tapDeleteStepBlock?(model)
        } cancelCompletion: {
        }
    }
    
    private lazy var titleLab: GTPaddingLabel = {
        let lab = GTPaddingLabel()
        lab.textColor = .hexStrToColor("#999999")
        lab.font = UIFontReg(13)
        lab.text = placeholder
        lab.numberOfLines = 0
        lab.paddingLeft = 10
        lab.paddingTop = 5
        lab.paddingRight = 10
        lab.paddingBottom = 5
        lab.preferredMaxLayoutWidth = screW - 74 - 15
        lab.gt.setCornerRadius(8)
        lab.isUserInteractionEnabled = true
        lab.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapEidtTitleAction)))
        return lab
    }()
    
    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .hexStrToColor("#5B6FA3")
        return view
    }()
    
    private lazy var addImgView: CommentUpdateImgView = {
        let view = CommentUpdateImgView()
        view.tapAddPhotoBlock = { [weak self] image in
            guard let self = self, let image = image as? UIImage else { return }
            self.addImgBlock?(image)
        }
        view.tapImageBlock = { [weak self] in
            guard let self = self else { return }
            if let image = self.model?.image {
                PhotoBroView.showWithImages(nil, images: [image])
            } else if let imageUrl = self.model?.icon {
                PhotoBroView.showWithImages([imageUrl], images: nil)
            }
        }
        view.clearBlock = { [weak self] in
            guard let self = self else { return }
            guard let model = model else { return }
            self.clearImgBlock?(model)
        }
        return view
    }()
    
    private lazy var deleteLabel: HomeListCeltagView = {
        let lab = HomeListCeltagView()
        lab.backgroundColor = .clear
        lab.gt.setCornerRadius(3.dbw)
        lab.isHidden = true
        lab.tipImg.image = .deleteStep
        lab.tagContent.color(.hexStrToColor("#F96464"))
        lab.tagContent.font(UIFontMedium(10))
        lab.tagContent.text = "\("deletionOfStep".homeLocalizable())"
        lab.isUserInteractionEnabled = true
        lab.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapDeleteStepAction)))
        return lab
    }()
}
