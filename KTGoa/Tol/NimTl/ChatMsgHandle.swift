//
//  ChatMsgHandle.swift
//  Golaa
//
//  Created by chenkaisong on 2024/5/16.
//

import UIKit

class ChatMsgHandle: NSObject {
    
}

// MARK: - 构建消息
extension ChatMsgHandle {
    
    static func buildMessage(_ message: NIMMessage, _ userInfo: GUsrInfo?) -> ChatMsgModel {
        let msgModel = ChatMsgModel()
        msgModel.msg = message
        
        // 消息发送方向
        msgModel.msgDirection = message.isOutgoingMsg ? .sender : .reciver
        // 用户信息
        msgModel.userInfo = userInfo
        // 消息id
        msgModel.msgId = message.messageId
        // 消息发送者
        msgModel.msgFrome = message.from ?? ""
        /// 消息时间
        msgModel.msgTime = message.timestamp
        
        // 系统消息扩展内容
        if let remoteExt = message.remoteExt as? [String: Any],
           let data = remoteExt["data"] as? [Any],
           let json = data.first as? [String: Any] {
            debugPrint("remoteExt:\(json) text:\(message.text ?? "")")
            if let model = ChatSystemModel.deserialize(from: json) {
                msgModel.systemModel = model
            }
        }
        
        // 消息回调
        let callbackExt = message.callbackExt
        if callbackExt.count > 0 {
            if let model = ChatCallbackExtModel.deserialize(from: callbackExt) {
                msgModel.callbackModel = model
            }
        }
        
        if let callbackModel = msgModel.callbackModel {
            if callbackModel.code == .other {
                // 消息发送状态
                switch message.deliveryState {
                case .delivering:
                    msgModel.msgStatus = (reqMagger.networkStatus == .notReachable ? .fail : .sending)
                case .deliveried:
                    msgModel.msgStatus = .success
                default:
                    msgModel.msgStatus = .fail
                }
            } else {
                msgModel.msgStatus = .fail
            }
        } else {
            // 消息发送状态
            switch message.deliveryState {
            case .delivering:
                msgModel.msgStatus = (reqMagger.networkStatus == .notReachable ? .fail : .sending)
            case .deliveried:
                msgModel.msgStatus = .success
            default:
                msgModel.msgStatus = .fail
            }
        }
        
        // 消息已读状态
        switch message.session?.sessionType {
        case .P2P:
            // 单聊
            msgModel.msgReadStatue = message.isRemoteRead ? .read : .unRead
            msgModel.sessionType = .singleChat
        case .team:
            // 群聊
            msgModel.msgReadStatue = .other
            msgModel.sessionType = .groupChat
        default:
            // 其他
            msgModel.msgReadStatue = .other
            msgModel.sessionType = .other
        }
        
        // print("messageType====: \(message.messageType) =====: \(message)")
        
        // 消息类型
        switch message.messageType {
        case .text:
            msgModel.msgType = .text
        case .image:
            msgModel.msgType = .picture
            if let imgM = message.messageObject as? NIMImageObject {
                msgModel.imageObject = imgM
            } else {
                msgModel.imageObject = nil
            }
            msgModel.sendbubbleImg = ""
            msgModel.recivebubbleImg = ""
        case .audio:
            msgModel.msgType = .voice
            if let audioM = message.messageObject as? NIMAudioObject {
                msgModel.audioObject = audioM
                // msgModel.audioDuration = audioM.duration / 1000
                if let localExt = message.localExt as? [String: Any] {
                    let sudioM = ChatAudioStatue.deserialize(from: localExt)
                    msgModel.audioStatue = sudioM
                }
            } else {
                msgModel.audioObject = nil
            }
        case .video:
            msgModel.msgType = .video
        case .custom:
            if let customObject = message.messageObject as? NIMCustomObject {
                if let taskAttachMent = customObject.attachment as? TaskCustomAttachMent {
                    msgModel.taskAttachMent = taskAttachMent
                    msgModel.msgType = .task
                    msgModel.sendbubbleImg = "chat_bubble_rightw"
                }
                
                if let giftAttachMent = customObject.attachment as? GiftCustomAttachMent {
                    msgModel.giftAttachMent = giftAttachMent
                    msgModel.msgType = .gift
                    msgModel.sendbubbleImg = "chat_bubble_rightw"
                }
            }
        case .tip:
            if let tipObject = message.messageObject as? NIMTipObject {
                
                // print("tipObject====== : \(tipObject.attach ?? "") callbackExt: \(tipObject.callbackExt ?? "") text====: \(message.text ?? "") remoteExt: \(message.remoteExt ?? [:]) rawAttachContent: \(message.rawAttachContent ?? "")")
                
                msgModel.msgType = .tip
                msgModel.sendbubbleImg = ""
                msgModel.recivebubbleImg = ""
                msgModel.isShowTime = false
                msgModel.isShowUserHead = false
                msgModel.isLongPress = false
            }
        case .notification:
            if let notiObject = message.messageObject as? NIMNotificationObject,
               let content = notiObject.content as?  NIMTeamNotificationContent {
                
                // print("rawAttachContent: \((message.rawAttachContent ?? "").gt.jsonStringToDictionary() ?? [:])")
                
                guard let rawAttachContent = message.rawAttachContent,
                      let dict = rawAttachContent.jsonStringToDictionary(),
                      let  data = dict["data"] as? [String: Any],
                      let model = ChatTeamNotiMsgModel.deserialize(from: data) else { break  }
                msgModel.teamInviteModel = model
                
                switch content.operationType {
                case .invite:
                    msgModel.msgType = .teamInviteNoti
                case .mute:
                    msgModel.msgType = .teamMuteNoti
                case .dismiss:
                    msgModel.msgType = .teamDisbandment
                case .kick:
                    msgModel.msgType = .teamKick
                default:
                    msgModel.msgType = .other
                }
                
                msgModel.sendbubbleImg = ""
                msgModel.recivebubbleImg = ""
                msgModel.isShowTime = false
                msgModel.isShowUserHead = false
                msgModel.isLongPress = false
            }
        default:
            msgModel.msgType = .other
            
            msgModel.sendbubbleImg = ""
            msgModel.recivebubbleImg = ""
            msgModel.isShowTime = false
            msgModel.isShowUserHead = false
            msgModel.isLongPress = false
        }
        return msgModel
    }
}

// MARK: - 构建会话数据
extension ChatMsgHandle {
    
    static func buildSessionModel(session: NIMRecentSession,
                                  userInfo: GUsrInfo? = nil,
                                  group: MsgGroupInfoModel? = nil) -> MsgSessionModel {
        
        let sessModel = MsgSessionModel()
        
        sessModel.curSession = session
        
        sessModel.sessionId = session.session?.sessionId ?? ""
        
        // 未读数
        sessModel.unreadCount = session.unreadCount
        
        // 消息ID
        sessModel.messageId = session.lastMessage?.messageId ?? ""
        
        // 最后一条消息
        sessModel.lastMessage = session.lastMessage
        
        // 消息发送者id
        sessModel.msgFrom = session.lastMessage?.from ?? ""
        
        // 消息时间
        let timestamp = session.lastMessage?.timestamp ?? 0
        sessModel.timestamp = timestamp
        let date = Date(timeIntervalSince1970: timestamp)
        sessModel.showTime = date.chatSessionShowTime()
        
        // 会话类型
        switch session.session?.sessionType {
        case .P2P:
            sessModel.sessionType = .singleChat
        case .team:
            sessModel.sessionType = .groupChat
        default:
            sessModel.sessionType = .other
        }
        
        if sessModel.sessionType == .singleChat { // 单聊
            // 获取用户资料
            if let userInfo = userInfo {
                
                sessModel.user = userInfo
                
                switch  sessModel.sysMsgnumber {
                case .sysNoti:
                    sessModel.name = "notifications".msgLocalizable()
                    sessModel.avatar = ""
                case .onleCustomer:
                    sessModel.name = "customerService".msgLocalizable()
                    sessModel.avatar = ""
                case .newFeiend:
                    sessModel.name = "newFriends".msgLocalizable()
                    sessModel.avatar = ""
                default:
                    sessModel.name = userInfo.showName
                    sessModel.avatar = userInfo.avatar
                }
                
            } else {
                sessModel.name = session.session?.sessionId ?? ""
                sessModel.avatar = ""
            }
        }
        
        if sessModel.sessionType == .groupChat { // 群聊
            if let group = group {
                sessModel.group = group
                sessModel.name = group.groupName
                sessModel.avatar = group.groupAvatar
            } else {
                sessModel.name = session.session?.sessionId ?? ""
                sessModel.avatar = ""
            }
        }
        
        // 消息显示内容
        switch session.lastMessage?.messageType {
        case .text:
            sessModel.showMessage = session.lastMessage?.text ?? "noNewMMsg".msgLocalizable()
        case .audio:
            sessModel.showMessage = "voice".msgLocalizable()
        case .video:
            sessModel.showMessage = "video".msgLocalizable()
        case .image:
            sessModel.showMessage = "image".msgLocalizable()
        case .custom:
            if let customObject = session.lastMessage?.messageObject as? NIMCustomObject {
                
                if let _ = customObject.attachment as? TaskCustomAttachMent {
                    sessModel.showMessage = "task".msgLocalizable()
                }
                if let _ = customObject.attachment as? GiftCustomAttachMent {
                    sessModel.showMessage = "[\("gift".msgLocalizable())]"
                }
            }
        case .tip:
            sessModel.showMessage = session.lastMessage?.text ?? "noNewMMsg".msgLocalizable()
        case .notification:
            
            if let notiObject = session.lastMessage?.messageObject as? NIMNotificationObject,
               let content = notiObject.content as?  NIMTeamNotificationContent {
                
                print("content====== : \(String(describing: content.notifyExt)) callbackExt: \(String(describing: content.attachment)) remoteExt: \(session.lastMessage?.remoteExt ?? [:]) rawAttachContent: \(session.lastMessage?.rawAttachContent ?? "") operationType: \(content.operationType)")
                
                // 获取操作者昵称
                let manName = mm.getLocauserInfo(content.sourceID ?? "")?.nickname ?? ""
                
                // 获取被操作者信息
                let userNames = content.targetIDs?.map({
                    mm.getLocauserInfo($0)
                }).map({
                    $0?.showName ?? "noNewMMsg".msgLocalizable()
                }) ?? []
                
                // 当前消息用户昵称
                let msgUserName = mm.getLocauserInfo(sessModel.msgFrom)?.showName ?? ""
                
                // 被操作者昵称
                let inviteName = userNames.toStrinig(separator: ",")
                
                switch content.operationType {
                case .invite: // 邀请
                    if let notifyExt = content.notifyExt {
                        if notifyExt.contains(ChatTeamNotiAttachType.invite.rawValue) {
                            // 他人邀请
                            sessModel.showMessage = "xxInvitedXxToJoinThe".msgLocalizable(manName, inviteName)
                        } else {
                            // 主动进群
                            sessModel.showMessage = "xxJoinedTheGroupChat".msgLocalizable(inviteName)
                        }
                    }
                case .mute: // 禁言,解禁
                    if let mute = content.attachment as? NIMMuteTeamMemberAttachment {
                        if mute.flag {
                            sessModel.showMessage = "xxHasBeenMuted".msgLocalizable(inviteName)
                        } else {
                            sessModel.showMessage = "xxHasBeenUnmuted".msgLocalizable(inviteName)
                        }
                    }
                case .dismiss: // 解散群
                    sessModel.showMessage = msgUserName + "disbandTheGroup".msgLocalizable()
                case .kick: // 移除群
                    if let ids = content.targetIDs {
                        let isSelf = ids.contains(LoginTl.shared.usrId)
                        let showText = isSelf ? "ustedHaRevg".msgLocalizable() : "\(inviteName)被移除群聊"
                        sessModel.showMessage = showText
                    }
                default:
                    sessModel.showMessage = ""
                }
            }
            
        default:
            sessModel.showMessage = ""
        }
        
        return sessModel
    }
    
    /// 会话数据排序
    static func sortAllRecentSessions(_ list: [MsgSessionModel]) -> [MsgSessionModel] {
        
        var allSessions = [MsgSessionModel]()
        
        /// 获取系统通知
        if let sysNotis = list.filter({$0.sessionId == YXSystemMsgnumber.sysNoti.notiId}).first {
            allSessions.append(sysNotis)
        } else {
            let sessModel = MsgSessionModel()
            sessModel.sessionId = YXSystemMsgnumber.sysNoti.notiId
            sessModel.sessionType = .singleChat
            sessModel.name = "notifications".msgLocalizable()
            sessModel.avatar = ""
            sessModel.showMessage = "noNewMMsg".msgLocalizable()
            allSessions.append(sessModel)
        }
        
        /// 获取在线客服
        if  let onleCustomers = list.filter({$0.sessionId == YXSystemMsgnumber.onleCustomer.customerId}).first {
            allSessions.append(onleCustomers)
        }
        
        let tList = list.filter({
            $0.sessionId != YXSystemMsgnumber.sysNoti.notiId
        }).filter({
            $0.sessionId != YXSystemMsgnumber.onleCustomer.customerId
        })
        
        let sortList = tList.sorted(by: { $0.timestamp >= $1.timestamp })
        allSessions.appends(sortList.filterDuplicates({$0.sessionId}))
        return allSessions
    }
}

// MARK: - 语音处理
extension ChatMsgHandle {
    
    static func playAudio(msg: ChatMsgModel, dataList: [ChatMsgModel]) {
        
        if  msg.msgType != .voice { return }
        
        guard let path = msg.audioObject?.path,
              let message = msg.msg,
              let session = msg.msg?.session else { return  }
        
        // 判断列表是否有正在播放的语音
        if let playingMsg = dataList.filter({$0.audioStatue?.statue == .palyIng}).first?.msg {
            ChatMsgHandle.normalAudioUpdate(message: playingMsg, session: session)
        }
        
        if let audioStatue = msg.audioStatue {
            // 存在本地扩展
            if audioStatue.statue == .palyIng {
                // 1. 判断当前语音消息是否在播放中 如果是暂停播放 更新消息状态
                ChatMsgHandle.normalAudioUpdate(message: message, session: session)
                return
            }
            
            ChatMsgHandle.playingAudioUpdate(path: path,
                                             message: message,
                                             session: session,
                                             isplayNext: false)
            
        } else {
            ChatMsgHandle.playingAudioUpdate(path: path,
                                             message: message,
                                             session: session,
                                             isplayNext: true)
        }
        
    }
    
    /// 更新语音播放中的状态
    static func playingAudioUpdate(path: String,
                                   message: NIMMessage,
                                   session: NIMSession,
                                   isplayNext: Bool) {
        
        NIMSDK.shared().mediaManager.stopPlay()
        NIMSDK.shared().mediaManager.play(path)
        NIMSDK.shared().mediaManager.setNeedProximityMonitor(true)
        // 更新消息为播放中
        message.localExt = ["statue": IMMsgAudioStatue.palyIng.rawValue,
                            "isplayNext": isplayNext]
        mm.updateMessage(msg: message, session: session)
        
    }
    
    /// 更新语音为默认的状态
    static func normalAudioUpdate(message: NIMMessage,
                                  session: NIMSession) {
        
        NIMSDK.shared().mediaManager.stopPlay()
        // 更新消息为播放中
        message.localExt = ["statue": IMMsgAudioStatue.normal.rawValue,
                            "isplayNext": false]
        mm.updateMessage(msg: message, session: session)
        
    }
}

// MARK: - 图片预览
extension ChatMsgHandle {
    
    static func openPhotoBrowserDown(msgs: [ChatMsgModel], curmsg: ChatMsgModel) {
        
        if  curmsg.msgType != .picture { return }
        
        let pictureImgs = msgs.filter({
            $0.msgType == .picture
        })
        
        let imgs = pictureImgs.map({
            $0.imageObject?.url ?? ""
        })
        
        if let index = pictureImgs.firstIndex(where: { $0.msgId == curmsg.msgId }) {
            PhotoBroView.showWithImages(imgs, images: nil, curIndex: index)
        }
    }
}

// MARK: - 消息发送,插入
extension ChatMsgHandle {
    
    /// 发送任务消息
    static func sendTaskMsg(session: NIMSession?) {
        guard let session = session else { return }
        let tapSendBlock: ((SelectTaskListModel) -> Void) = { model in
            var params: [String: Any] = [:]
            params["taskId"] = model.id
            if session.sessionType == .P2P {
                params["toUserIds"] = session.sessionId
            } else if session.sessionType == .team {
                let group = mm.getLocaGroupInfo(session.sessionId)
                params["groupIds"] = group?.severId
            }
            
            NetAPI.HomeAPI.shareTask.reqToJsonHandler(parameters: params) { _ in
                FlyerLibHelper.log(.sendMessageClick)
            } failed: { error in
                print("error: \(error)")
            }
        }
        RoutinStore.push(.selectTask, param: tapSendBlock) // 跳转发布任务
    }
    
    /// 发送礼物消息
    static func sendGiftMsg(model: GiftCustomAttachMent) {
        guard let session = mm.curSession else { return }
        let object = NIMCustomObject()
        object.attachment = model
        let msg = NIMMessage()
        msg.messageObject = object
        msg.from = LoginTl.shared.usrId
        msg.apnsContent = "gift".msgLocalizable()
        mm.sendMessage(msg: msg, session: session)
    }
    
    /// 发送语音消息
    static func sendAudioMsg(duration: Int, path: String, session: NIMSession?) {
        guard let session = session else { return }
        let object = NIMAudioObject(sourcePath: path)
        object.duration = duration * 1000
        
        let msg = NIMMessage()
        msg.messageObject = object
        msg.from = LoginTl.shared.usrId
        msg.apnsContent = "voice".msgLocalizable()
        mm.sendMessage(msg: msg, session: session)
    }
    
    /// 发送图片消息
    static func sendPictureMsg(_ imgs: [UIImage], session: NIMSession?) {
        imgs.forEach { image in
            autoreleasepool {
                guard let session = session else { return }
                
                let object = NIMImageObject(image: image)
                
                let msg = NIMMessage()
                msg.messageObject = object
                msg.from = LoginTl.shared.usrId
                msg.apnsContent = "image".msgLocalizable()
                mm.sendMessage(msg: msg, session: session)
            }
        }
    }
    
    /// 发送文本消息
    static  func sendTextMsg(text: String, session: NIMSession?) {
        guard let session = session else { return }
        let msg = NIMMessage()
        msg.text = text
        msg.from = LoginTl.shared.usrId
        mm.sendMessage(msg: msg, session: session)
    }
    
    /// 消息重发
    static func resendMessage(msg: ChatMsgModel) {
        guard let message = msg.msg, let session = msg.sesstion else { return }
        /// 先删除消息 再重新构建消息发送
        NIMSDK.shared().conversationManager.delete(message)
        
        switch msg.msgType {
        case .text:
            if let msgText = msg.msg?.text {
                ChatMsgHandle.sendTextMsg(text: msgText, session: session)
            }
        case .voice:
            if let audioObj = msg.audioObject {
                ChatMsgHandle.sendAudioMsg(duration: audioObj.duration / 1000, path: audioObj.path ?? "", session: session)
            }
        case .picture:
            if let audioObj = msg.imageObject {
                if let image = UIImage(contentsOfFile: audioObj.path ?? "") {
                    ChatMsgHandle.sendPictureMsg([image], session: session)
                }
            }
        default:
            break
        }
    }
    
    /// 撤回一条信息
    static func recvRevokeMessage(msg: ChatMsgModel) {
        guard let session = msg.msg?.session else { return }
        let object = NIMTipObject()
        let message = NIMMessage()
        message.messageObject = object
        message.text = "recvRevokeMsg".msgLocalizable()
        message.from = msg.msgFrome
        mm.insertMessage(msg: message, session: session)
    }
    
    /// 配置发送内容验证签
    static func configureRemote(_ message: NIMMessage) -> [AnyHashable: Any] {
        
        var remoteExt = [AnyHashable: Any]()
        if let remote: [AnyHashable: Any] = message.remoteExt {
            remoteExt = remote
        }
        remoteExt["appId"] = "Golaa/iOS/\(Bundle.gt.appVersion)/main"
        
        let timeInterval = Date().timeIntervalSince1970 * 1000
        let times = Int64(timeInterval) | 0x15
        let timeString = "\(Int64(times))"
        remoteExt["ts"] = timeString
        let tString = times ^ 0x7fffffff
        let tCode = abs(tString)
        
        var fileSting = ""
        if message.messageType == .text, let text = message.text {
            fileSting = text
        } else if message.messageType == .image ||  message.messageType == .audio {
            fileSting = timeString
        }
        
        let userId = LoginTl.shared.usrId
        
        let salt = "PzzW—iH—YefWFeo_kFOrl/lolGrjdFjD5S"
        let formatStr = "\(userId)|\(fileSting)|\(tCode)|\(salt)"
        let md5Str = formatStr.md5()
        remoteExt["sign"] = md5Str
        
        return remoteExt
    }
}

// MARK: - 消息长按操作
extension ChatMsgHandle {
    
    static func messagelongPress(msg: ChatMsgModel,
                                 baseView: UIView,
                                 timeView: UIView,
                                 completion: @escaping (_ msg: ChatMsgModel) -> Void) {
        
        var items = [String]()
        
        // 判断消息时间与当前时间 超过三分钟不显示撤回
        let timestamp = msg.msg?.timestamp ?? 0
        let msgDate = Date(timeIntervalSince1970: timestamp)
        // 时间差 分钟
        let spaceMin = Date().gt.numberOfMinutes(from: msgDate) ?? 0
        
        switch msg.sessionType {
        case .groupChat:
            if msg.msgType != .text {
                return
            }
            items.appends(["copy".homeLocalizable()])
        default:
            if msg.msgType == .text {
                if spaceMin <= 3 {
                    msg.msgDirection == .sender ? items.appends(["copy".homeLocalizable(), "recall".msgLocalizable()]): items.appends(["copy".homeLocalizable()])
                } else {
                    items.appends(["copy".homeLocalizable()])
                }
            } else {
                if msg.msgDirection == .reciver {
                    return
                }
                if spaceMin > 3 {
                    return
                }
                items.appends(["recall".msgLocalizable()])
            }
        }
        
        let keyWindow = getKeyWindow()
        let bubbleRect = baseView.convert(baseView.frame, to: keyWindow)
        // 头像所占空间
        let headMargin = CGFloat(66)
        let marginX = CGFloat(20)
        var centerX = 0
        
        let longPressView = ChatLongPressView(items: items, frame: ScreB)
        keyWindow.addSubview(longPressView)
        
        if msg.userInfo?.id == LoginTl.shared.usrId {
            centerX = Int(screW - headMargin - bubbleRect.size.width/2.0)
        } else {
            centerX = Int(headMargin + bubbleRect.size.width/2.0)
        }
        var originX = CGFloat(centerX - Int(longPressView.viewSize.width/2.0))
        
        let originY = bubbleRect.minY
        
        let safeMargin = (longPressView.viewSize.width + marginX)
        
        if originY <= naviH + longPressView.viewSize.height {
            
            // 显示在下面
            longPressView.isDownArrow = false
            
            if originX > screW - safeMargin {
                originX = screW - safeMargin
            } else if originX < marginX {
                originX = marginX
            }
            
            longPressView.backView.frame = CGRect(origin: CGPoint(x: originX, y: bubbleRect.maxY - 3), size: longPressView.viewSize)
            
        } else {
            
            // 显示在上面
            longPressView.isDownArrow = true
            
            if originX > screW - safeMargin {
                originX = screW - safeMargin
            } else if originX < marginX {
                originX = marginX
            }
            
            longPressView.backView.frame = CGRect(origin: CGPoint(x: originX, y: originY - longPressView.viewSize.height + 3), size: longPressView.viewSize)
        }
        
        longPressView.clickBlock = {  text in
            
            if let message = msg.msg {
                if text == "copy".homeLocalizable() {
                    "\(message.text ?? "")".copy()
                    ToastHud.showToastAction(message: "copySuccessful".msgLocalizable())
                }
                
                if text == "recall".msgLocalizable() {
                    ToastHud.showToastAction()
                    NIMSDK.shared().chatManager.revokeMessage(message, apnsContent: nil, apnsPayload: nil, shouldBeCounted: false) { error in
                        ToastHud.hiddenToastAction()
                        if error != nil {
                            ToastHud.showToastAction(message: error?.localizedDescription ?? "")
                            return
                        }
                        completion(msg)
                    }
                }
            }
        }
    }
}
