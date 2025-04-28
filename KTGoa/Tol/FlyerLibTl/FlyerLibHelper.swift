//
//  FlyerLibHelper.swift
//  Golaa
//
//  Created by xiaoxuhui on 2024/5/17.
//

import UIKit
import AppsFlyerLib

enum FlyerLogEvent {
    
    // MARK: -
    // MARK: 第三方登录
    case googleLogin
    case facebookLogin
    case appleLogin
    // MARK: -
    // MARK: 手机登录
    case phoneCodeClick
    case phoneCodeSendResult
    case phoneCodeLogin
    // MARK: -
    // MARK: 邮箱登录 
    case emailCodeClick
    case emailCodeSendResult
    case emailCodeLogin
    // MARK: -
    // MARK: 完善资料
    case perfectDataClick
    // MARK: -
    // MARK: 首页
    case homeTabClick
    case allTasksListClick
    case latestPublishListClick
    case toPublishClick
    case incomeWithdrawalClick
    case searchClick
    case taskClick
    // MARK: -
    // MARK: 任务详情
    case enterTaskDetailScreen
    case shareTaskClick
    case consultClick
    case getTaskClick
    case enterGetTaskSuccessResult
    // MARK: -
    // MARK: 分享
    case shareToTarget
    case shareCancelClick
    // MARK: -
    // MARK: 消息
    case messageTabClick
    case createGroupClick
    case addFriendClick
    case enterSingleTalkScreen
    case enterGroupTalkScreen
    case sendMessageClick
    case sendMessageSuccessResult
    case talkShareMyTaskClick
    case systemNoteClick
    case systemNoteLinkClick
    // MARK: -
    // MARK: 我的
    case mineTabClick
    case logoutClick
    case cancelAccountResult
    case taskIncomeWithdrawalClick
    case agentIncomeWithdrawalClick
    case agentInviteShareClick
    
    // MARK: -
    // MARK: 【充值相关的枚举值】🔽
    
    // MARK: -
    // MARK: 支付保证金
    case enterPayDepositScreen
    case payDepositClick
    case payDepositBackClick
    case payDepositResult
  
    // MARK: -
    // MARK: 充值金币
    case enterRechargeCoinScreen
    case rechargeCoinClick
    case rechargeCoinBackClick
    case rechargeCoinResult
  
    // MARK: -
    // MARK: 半屏充值金币
    case enterHalfRechargeScreen
    case halfRechargeCoinClick
    case halfRechargeCoinBackClick
    case halfRechargeCoinResult
  
    // 计算属性，返回下划线命名法的字符串表示
    var name: String {
        switch self {
        case .googleLogin: return "google_login"
        case .facebookLogin: return "facebook_login"
        case .appleLogin: return "apple_login"
        case .phoneCodeClick: return "phone_code_click"
        case .phoneCodeSendResult: return "phone_code_send_result"
        case .phoneCodeLogin: return "phone_code_login"
        case .emailCodeClick: return "email_code_click"
        case .emailCodeSendResult: return "email_code_send_result"
        case .emailCodeLogin: return "email_code_login"
        case .perfectDataClick: return "perfect_data_click"
        case .homeTabClick: return "home_tab_click"
        case .allTasksListClick: return "all_tasks_list_click"
        case .latestPublishListClick: return "latest_publish_list_click"
        case .toPublishClick: return "to_publish_click"
        case .incomeWithdrawalClick: return "income_withdrawal_click"
        case .searchClick: return "search_click"
        case .taskClick: return "task_click"
        case .enterTaskDetailScreen: return "enter_task_detail_screen"
        case .shareTaskClick: return "share_task_click"
        case .consultClick: return "consult_click"
        case .getTaskClick: return "get_task_click"
        case .enterGetTaskSuccessResult: return "enter_get_task_success_result"
        case .shareToTarget: return "share_to_target"
        case .shareCancelClick: return "share_cancel_click"
        case .messageTabClick: return "message_tab_click"
        case .createGroupClick: return "create_group_click"
        case .addFriendClick: return "add_friend_click"
        case .enterSingleTalkScreen: return "enter_single_talk_screen"
        case .enterGroupTalkScreen: return "enter_group_talk_screen"
        case .sendMessageClick: return "send_message_click"
        case .sendMessageSuccessResult: return "send_message_success_result"
        case .talkShareMyTaskClick: return "talk_share_my_task_click"
        case .systemNoteClick: return "system_note_click"
        case .systemNoteLinkClick: return "system_note_link_click"
        case .mineTabClick: return "mine_tab_click"
        case .logoutClick: return "logout_click"
        case .cancelAccountResult: return "cancel_account_result"
        case .taskIncomeWithdrawalClick: return "task_income_withdrawal_click"
        case .agentIncomeWithdrawalClick: return "agent_income_withdrawal_click"
        case .agentInviteShareClick: return "agent_invite_share_click"
            
        // 充值相关的字符串表示
        case .enterPayDepositScreen: return "enter_pay_deposit_screen"
        case .payDepositClick: return "pay_deposit_click"
        case .payDepositBackClick: return "pay_deposit_back_click"
        case .payDepositResult: return "pay_deposit_result"
  
        case .enterRechargeCoinScreen: return "enter_recharge_coin_screen"
        case .rechargeCoinClick: return "recharge_coin_click"
        case .rechargeCoinBackClick: return "recharge_coin_back_click"
        case .rechargeCoinResult: return "recharge_coin_result"
  
        case .enterHalfRechargeScreen: return "enter_half_recharge_screen"
        case .halfRechargeCoinClick: return "half_recharge_coin_click"
        case .halfRechargeCoinBackClick: return "half_recharge_coin_back_click"
        case .halfRechargeCoinResult: return "half_recharge_coin_result"

        @unknown default:
            fatalError("Unhandled case")
        }
    }
}

class FlyerLibHelper: NSObject {
    
    static let shared = FlyerLibHelper()
    
    func setup() {
        AppsFlyerLib.shared().appleAppID = "6504396977"//"6502326773"
        AppsFlyerLib.shared().appsFlyerDevKey = "RMp9xMEprozNhNnCy6aVp6"
        //"8Y2zBeJR5GfwToxFqnWYnn"
        // 正式
        // 6504396977
        // RMp9xMEprozNhNnCy6aVp6
    }
    
    func start() {
        AppsFlyerLib.shared().waitForATTUserAuthorization(timeoutInterval: 60)
        AppsFlyerLib.shared().start()
        AppsFlyerLib.shared().customerUserID = LoginTl.shared.usrId
    }
    
    /// 参数
    static func log(_ event: FlyerLogEvent, values: [String: Any]? = nil) {
        AppsFlyerLib.shared().logEvent(event.name, withValues: values)
    }
    
    /// 结果
    static func log(_ event: FlyerLogEvent, result: Bool) {
        let values = ["result": result ? "1" : "2"]
        AppsFlyerLib.shared().logEvent(event.name, withValues: values)
    }
    
    /// 来源
    static func log(_ event: FlyerLogEvent, source: Any) {
        let values = ["source": source]
        AppsFlyerLib.shared().logEvent(event.name, withValues: values)
    }
    
    /// 参数
    static func log(_ name: String, values: [String: Any]? = nil) {
        AppsFlyerLib.shared().logEvent(name, withValues: values)
    }
}
 
