//
//  ChatTeamNotiMsgView.swift
//  Golaa
//
//  Created by chenkaisong on 2024/5/21.
//

import UIKit

class ChatTeamNotiMsgView: ChatBaseMsgView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        contentView.addSubview(textMsg)
        contentView.backgroundColor = .clear
        
        textMsg.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(screW - 112)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupMsgModel(_ msg: ChatMsgModel) {
        guard let model = msg.teamInviteModel else { return }
        
        // 获取出群主外的用户昵称
        let teamListName = model.userList?.filter({
            $0.userId != model.teamInfo?.id
        }).map({
            mm.getLocauserInfo($0.userId)?.showName ?? ""
        }) ?? []
        let allUsersName = teamListName.toStrinig(separator: ",")
        
        // 获取被操作用户的昵称
        let invitesName = model.ids?.filter({
            $0 != model.teamInfo?.id
        }).map({
            mm.getLocauserInfo($0)?.showName ?? ""
        }) ?? []
        let idsName = invitesName.toStrinig(separator: ",")
        
        // 群主昵称
        let username = mm.getLocauserInfo(model.teamInfo?.id ?? "")?.showName ?? ""
        
        // 消息发送者信息
        let msgUserInfo = mm.getLocauserInfo(msg.msgFrome)
        
        switch msg.msgType {
        case .teamInviteNoti:
            // 群邀请
            if model.attachModel?.joinType == .invite {
                // 他人邀请
                textMsg.text = "xxInvitedXxToJoinThe".msgLocalizable(username, idsName)
                textMsg.gt.setSpecificTextColor(username, color: .hexStrToColor("#2697FF"))
                textMsg.gt.setSpecificTextColor(allUsersName, color: .hexStrToColor("#2697FF"))
            } else {
                // 主动申请
                textMsg.text = "xxJoinedTheGroupChat".msgLocalizable(idsName)
                textMsg.gt.setSpecificTextColor(allUsersName, color: .hexStrToColor("#2697FF"))
            }
        case .teamMuteNoti:
            // 群禁言
            textMsg.text =  model.mute == "1"  ? "xxHasBeenMuted".msgLocalizable(allUsersName) : "xxHasBeenUnmuted".msgLocalizable(allUsersName)
            textMsg.gt.setSpecificTextColor(allUsersName, color: .hexStrToColor("#2697FF"))
        case .teamDisbandment:
            // 群解散
            textMsg.text = (msgUserInfo?.showName ?? "") + "disbandTheGroup".msgLocalizable()
            textMsg.gt.setSpecificTextColor((msgUserInfo?.showName ?? ""), color: .hexStrToColor("#2697FF"))
        case .teamKick:
            // 群成员删除
            if let ids = model.ids {
                let isSelf = ids.contains(LoginTl.shared.usrId)
                let showText = isSelf ? "ustedHaRevg".msgLocalizable() : "\(allUsersName)被移除群聊"
                textMsg.text = showText
                textMsg.gt.setSpecificTextColor(allUsersName, color: .hexStrToColor("#2697FF"))
            }
        default:
            textMsg.text = ""
        }
    }
    
    private lazy var textMsg: UILabel = {
        let label = UILabel()
        label.font = UIFontReg(12)
        label.textColor = .hexStrToColor("#999999")
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
}
