//
//  WebContentScriptType.swift
//  Golaa
//
//  Created by duke on 2024/5/25.
//

import UIKit

enum WebContentScriptMethod: String, CaseIterable {
    case getUserInfo = "iOSgetUserInfo" // 获取用户信息
    case pushPage = "jumpiOSPage" // 跳转内部页
    case back = "backApp" // 返回
    case invShare = "getInviteData" // 新加的的邀请
    case invFriShare = "inviteFriendShare" // 老的邀请
    case userLiao = "toUserChat"  // 去用户聊天
    case refresh = "jsNotifyAppRefresh" // 刷新
    case updateEvent = "updateEvent" // 刷新
    case openNewWos = "openWebViewUrl" // 打开新窗口网页
}

enum WebContentScriptJump: String, CaseIterable {
    case payLianCustomer = "rechargeContactCustomer" // 充值遇到困难联系客服
    case lianCustomer = "contactCustomer" // 联系客服
    case avarAuth = "avatarAuth" // 头像认证
    case userEdit = "completeMaterial" // 资料页
    case pay = "recharge" // 充值页
    case payGold = "recharge_gold" // 金币充值
    case payCoinRecord = "rechargeRecordForm_gold" // 金币流水
    case appStore = "appMarket" // h5跳app应用市场
    case homeLiaoList = "home_chat_list" // 首页聊天页
    case userDes = "user_detail" // 用户详情
    case message = "privateMessageChat" // 去聊天
    case back = "backApp" // 返回
}
