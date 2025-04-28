//
//  ChatTaskMsgView.swift
//  Golaa
//
//  Created by chenkaisong on 2024/5/16.
//

import UIKit

class ChatTaskMsgView: ChatBaseMsgView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        contentView.addSubview(taskIcon)
        contentView.addSubview(taskName)
        if !GlobalHelper.shared.inEndGid {
            contentView.addSubview(taskPrice)
        }
        contentView.addSubview(coverButton)
        contentView.gt.setCornerRadius(20)
        contentView.backgroundColor = .hexStrToColor("#FFFFFF")

        setupRect()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupMsgModel(_ msg: ChatMsgModel) {
                
        guard let taskInfo = msg.taskAttachMent?.msg else { return  }
        
        taskName.text = taskInfo.title
        taskPrice.text = "\(taskInfo.content)"
        taskIcon.normalImageUrl(taskInfo.cover)
        
        statusView.isHidden = true
    }

    private lazy var taskName: UILabel = {
        let label = UILabel()
        label.font = UIFontMedium(14)
        return label
    }()
    
    private lazy var taskPrice: UILabel = {
        let label = UILabel()
        label.font = UIFontSemibold(16)
        label.textColor = .hexStrToColor("#FF5722")
        return label
    }()
    
    private lazy var taskIcon: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.gt.setCornerRadius(8)
        return view
    }()
    
    lazy var coverButton: UIButton = {
        let button = UIButton(type: .custom)
        button.gt.handleClick { [weak self] _ in
            self?.tapActionBlock?()
        }
        return button
    }()
}

extension ChatTaskMsgView {
    
    private func setupRect() {
        
        contentView.snp.makeConstraints { make in
            make.trailing.leading.top.bottom.equalToSuperview()
            make.width.equalTo(screW - 166)
            make.height.equalTo(70)
        }
        
        taskIcon.snp.makeConstraints { make in
            make.width.height.equalTo(44)
            make.bottom.equalTo(-13)
            make.leading.top.equalTo(13)
        }
        
        taskName.snp.makeConstraints { make in
            make.top.equalTo(12)
            make.leading.equalTo(taskIcon.snp.trailing).offset(10)
            make.trailing.equalTo(-10)
        }
        
        if !GlobalHelper.shared.inEndGid {
            taskPrice.snp.makeConstraints { make in
                make.bottom.equalTo(-12)
                make.leading.trailing.equalTo(taskName)
            }
        }
        
        coverButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
}
