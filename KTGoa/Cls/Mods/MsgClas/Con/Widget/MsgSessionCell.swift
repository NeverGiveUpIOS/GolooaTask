//
//  MsgSessionCell.swift
//  Golaa
//
//  Created by chenkaisong on 2024/5/8.
//

import UIKit

class MsgSessionCell: UITableViewCell {
    
    var message: MsgSessionModel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupSubviews()
    }
    
    func setupMsgData(_ msg: MsgSessionModel) {
        message = msg
        
        headImage.headerImageUrl(msg.avatar, placeholder: msg.sysMsgHead)
        namelab.text = msg.name
        unreadCount.setTitle(msg.unreadCount > 99 ?  "99+" : "\(msg.unreadCount)", for: .normal)
        timeLab.text = msg.showTime
        msgLab.text = msg.showMessage
        systemTip.isHidden = msg.sysMsgnumber != .sysNoti
        unreadCount.isHidden = msg.unreadCount == 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var headImage: UIImageView = {
        let imageView = UIImageView()
        imageView.gt.setCornerRadius(52/2)
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFill
//        imageView.gt.addGestureTap { [weak self] _ in
//            guard let msg = self?.message else { return }
//            let sessionId = msg.sessionId
//            
//            switch msg.sessionType {
//            case .singleChat:
//                if sessionId == YXSystemMsgnumber.sysNoti.notiId {
//                    RoutinStore.push(.msgSystem, param: sessionId)
//                    return
//                }
//                if sessionId == YXSystemMsgnumber.sysNoti.newFeiendId {
//                    RoutinStore.push(.newfriendList)
//                    return
//                }
//                if sessionId == YXSystemMsgnumber.sysNoti.customerId {
//                    RoutinStore.push(.singleChat, param: sessionId)
//                    FlyerLibHelper.log(.enterSingleTalkScreen, source: "1")
//                    return
//                }
//                RoutinStore.push(.ordinaryUserInfo, param: sessionId)
//            case .groupChat:
//                mm.getSeverGroupInfo(msg.group?.groupId ?? "") { groupInfo in
//                    RoutinStore.push(.groupInfo, param: groupInfo.severId)
//                }
//            default:
//                break
//            }
//        }
        
        return imageView
    }()
    
    lazy var unreadCount: UIButton = {
        let button = UIButton(type: .custom)
        button.contentHorizontalAlignment = .center
        button.backgroundColor = .red
        button.isHidden = true
        button.gt.setCornerRadius(10)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFontReg(9)
        button.setBoardLine(UIColorHex("#FFFFFF"), 1)
        button.contentEdgeInsets = .init(top: 2, left: 5, bottom: 2, right: 5)
        return button
    }()
    
    private lazy var namelab: UILabel = {
        let label = UILabel()
        label.font = UIFontSemibold(15)
        label.textColor = UIColorHex("#000000")
        label.textAlignment = .left
        return label
    }()
    
    private lazy var systemTip: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .msgNoticeTip
        imageView.isHidden = true
        return imageView
    }()
    
    private lazy var msgLab: UILabel = {
        let label = UILabel()
        label.font = UIFontReg(12)
        label.textColor = UIColorHex("#999999")
        label.textAlignment = .left
        return label
    }()
    
    private lazy var timeLab: UILabel = {
        let label = UILabel()
        label.font = UIFontReg(10)
        label.textColor = UIColorHex("#CBCBCB")
        label.textAlignment = .right
        return label
    }()
    
}

extension MsgSessionCell {
    
    private func setupSubviews() {
        
        contentView.gt.addSubviews([
            headImage,
            unreadCount,
            namelab,
            systemTip,
            timeLab,
            msgLab
        ])
        
        headImage.snp.makeConstraints { make in
            make.width.height.equalTo(52)
            make.leading.equalTo(16)
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
        }
        
        unreadCount.snp.makeConstraints { make in
            make.centerY.equalTo(headImage.snp.top).offset(5)
            make.centerX.equalTo(headImage.snp.trailing).offset(-5)
            make.height.equalTo(20)
            make.width.greaterThanOrEqualTo(20)
        }
        
        namelab.snp.makeConstraints { make in
            make.leading.equalTo(headImage.snp.trailing).offset(10)
            make.width.lessThanOrEqualTo(screW - (52 + 90))
            make.top.equalTo(headImage.snp.top).offset(3)
        }
        
        systemTip.snp.makeConstraints { make in
            make.centerY.equalTo(namelab)
            make.leading.equalTo(namelab.snp.trailing).offset(4)
        }
        
        timeLab.snp.makeConstraints { make in
            make.trailing.equalTo(-16)
            make.centerY.equalTo(namelab)
        }
        
        msgLab.snp.makeConstraints { make in
            make.leading.equalTo(namelab)
            make.width.lessThanOrEqualTo(screW - (52 + 90))
            make.top.equalTo(namelab.snp.bottom).offset(10)
        }
    }
    
}
