//
//  Router.swift
//  Golaa
//
//  Created by Cb on 2024/5/15.
//

import Foundation

typealias RoutinRouter = RoutinStore.Router

extension RoutinStore {
    
    enum Router: Equatable {
        
        case emailLogin
        case phoneLogin
        case language
        case publish                                            // 发布任务
        case publishAgain                                       // 发布任务
        case payDeposit
        case publishComple                                      // 发布任务完成
        case taskDesc                                           // 任务详情
        case setting                                            // 设置中心
        case broadcast                                          // 通知设置
        case denyList                                           // 黑名单
        case fillCode                                           // 邀请码
        case publisher                                          // 发布者信息
        case about                                              // 关于我们
        case contact                                            // 联系我们
        case writeOff                                           // 账号注销
        case individualInfo                                     // 个人信息
        case pouch                                              // 我的钱包
        case pouchEnsure                                        // 保证金
        case pouchCoin                                          // 金币
        case choreRecord                                        // 任务记录
        case choreDetail                                        // 任务详情
        case choreBenefit                                       // 任务收益
        case chorePublishManager                                // 任务发布管理
        case chorePublishDetail                                 // 任务发布详情
        case chorePublishAppeal                                 // 任务发布申诉
        case chorePublishAppealSuc                              // 任务发布申诉完成
        case agentCooperation                                   // 代理合作
        case webScene(WebContentScene)                          // webView
        case auth                                               // 认证
        case authComplete                                       // 认证完成
        case getTask                                            // 领取任务
        case receiveComple                                      // 领取任务完成页面
        case groupChat                                          // 群聊
        case singleChat                                         // 单聊
        case msgSystem                                          // 系统通知
        case msgAddfriend                                       // 添加好友
        case searchUg                                           // 搜索好友和群组
        case createGroup                                        // 创建群聊
        case ordinaryUserInfo                                   // 普通用户资料
        case newfriendList                                      // 新好友列表
        case publisherDesc                                      // 发布者详情
        case searchTask                                         // 搜索任务
        case selectTask                                         // 选择任务
        case shareTask                                          // 分享任务
        case groupInfo
        case groupApply
        case groupAdd
        case groupMember
        case groupEditName
        case makeupDeposit                                      // 补交保证金
        case buyCoin                                            // 充值金币
        case coinRecord                                         // 金币记录
        case shareTaskPoster                                    // 分享任务海报
        case accuse                                             // 投诉
        
        static var urlPathCases: [Self] = [.taskDesc, .chorePublishDetail, .choreDetail, .publish, .publishAgain, .auth, .publisherDesc, .ordinaryUserInfo]
        
        var urlPath: String? {
            switch self {
            case .taskDesc:                                  // 任务详情
                return "/task/view"
            case .chorePublishDetail:                          // 查看任务发布数据详情
                return "/task/publish/view"
            case .choreDetail:                                // 查看任务领取数据详情
                return "/task/receive/view"
            case .publishAgain:                                // 重新发布任务（根据任务ID调用任务详情接口获取之前的任务数据）
                return "/task/again/add"
            case .publish:                                    // 发布任务
                return "/task/add"
            case .auth:                                       // 发布者认证
                return "/task/publish/auth"
            case .publisherDesc:                                // 发布者首页
                return "/publish/index"
            case .ordinaryUserInfo:                             // 用户主页
                return "/user/view"
            default:
                return nil
            }
        }
        
        var vcType: Routinable.Type? {
            switch self {
            case .emailLogin:
                return LoginEmailVC.self
            case .phoneLogin:
                return LoginPhoneVC.self
            case .setting:
                return SettingViewController.self
            case .language:
                return LanguageViewController.self
            case .publish:
                return PublishTaskViewController.self
            case .publishAgain:
                return PublishTaskViewController.self
            case .payDeposit:
                return PayDepositViewController.self
            case .publishComple:
                return PublishCompleViewController.self
            case .broadcast:
                return BroadcastViewController.self
            case .denyList:
                return DenyListViewController.self
            case .fillCode:
                return FillCodeViewController.self
            case .about:
                return AboutViewController.self
            case .contact:
                return AboutContactViewController.self
            case .writeOff:
                return WriteOffViewController.self
            case .individualInfo:
                return IndividualInfoViewController.self
            case .taskDesc:
                return TaskDescViewController.self
            case .pouch:
                return PouchViewController.self
            case .pouchEnsure:
                return PouchEnsureViewController.self
            case .pouchCoin:
                return PouchCoinViewController.self
            case .choreRecord:
                return ChoreRecordViewController.self
            case .choreDetail:
                return ChoreDetailViewController.self
            case .choreBenefit:
                return ChoreBenefitViewController.self
            case .chorePublishManager:
                return ChorePublishManagerController.self
            case .chorePublishDetail:
                return ChorePublishDetailController.self
            case .chorePublishAppeal:
                return ChorePublishAppealController.self
            case .chorePublishAppealSuc:
                return ChorePublishAppealSucController.self
            case .agentCooperation:
                return AgentCooperationViewController.self
            case .webScene:
                return WebContentViewContrller.self
            case .auth:
                return ReadyAuthViewController.self
            case .getTask:
                return GetTaskViewController.self
            case .receiveComple:
                return ReceiveCompleViewController.self
            case .groupChat:
                return GroupChatViewController.self
            case .singleChat:
                return SingleChatViewController.self
            case .msgSystem:
                return MsgSystemViewController.self
            case .msgAddfriend:
                return AddFriendViewController.self
            case .createGroup:
                return CreateGroupViewController.self
            case .ordinaryUserInfo:
                return OrdinaryUserInfoController.self
            case .newfriendList:
                return NewFriendListController.self
            case .publisherDesc:
                return PublisherDescViewController.self
            case .searchTask:
                return SearchTaskViewController.self
            case .selectTask:
                return SelectTaskViewController.self
            case .shareTask:
                return ShareSearchViewController.self
            case .searchUg:
                return SearchSegUserController.self
            case .groupInfo:
                return GroupInfoViewController.self
            case .groupAdd:
                return GroupAddMemberController.self
            case .groupApply:
                return GroupApplyListController.self
            case .groupMember:
                return GroupMemberViewController.self
            case .groupEditName:
                return GroupEditNameController.self
            case .makeupDeposit:
                return MakeupDepositViewController.self
            case .buyCoin:
                return BuyCoinViewController.self
            case .coinRecord:
                return CoinRecordViewController.self
            case .shareTaskPoster:
                return ShareTaskPosterController.self
            case .accuse:
                return AccuseViewController.self
            case .publisher:
                return PublisherInfoController.self
            case .authComplete:
                return AuthCompleteViewController.self
            default:
                return NewFriendListController.self
            }
        }
        
        public static func == (lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
            case (.emailLogin, .emailLogin):
                return true
            case (.phoneLogin, .phoneLogin):
                return true
            case (.setting, .setting):
                return true
            case (.language, .language):
                return true
            case (.publish, .publish):
                return true
            case (.publishAgain, .publishAgain):
                return true
            case (.payDeposit, .payDeposit):
                return true
            case (.publishComple, .publishComple):
                return true
            case (.broadcast, .broadcast):
                return true
            case (.denyList, .denyList):
                return true
            case (.fillCode, .fillCode):
                return true
            case (.about, .about):
                return true
            case (.contact, .contact):
                return true
            case (.writeOff, .writeOff):
                return true
            case (.individualInfo, .individualInfo):
                return true
            case (.taskDesc, .taskDesc):
                return true
            case (.pouch, .pouch):
                return true
            case (.pouchEnsure, .pouchEnsure):
                return true
            case (.pouchCoin, .pouchCoin):
                return true
            case (.choreRecord, .choreRecord):
                return true
            case (.choreDetail, .choreDetail):
                return true
            case (.choreBenefit, .choreBenefit):
                return true
            case (.chorePublishManager, .chorePublishManager):
                return true
            case (.chorePublishDetail, .chorePublishDetail):
                return true
            case (.chorePublishAppeal, .chorePublishAppeal):
                return true
            case (.chorePublishAppealSuc, .chorePublishAppealSuc):
                return true
            case (.agentCooperation, .agentCooperation):
                return true
            case (.webScene, .webScene):
                return true
            case (.auth, .auth):
                return true
            case (.getTask, .getTask):
                return true
            case (.receiveComple, .receiveComple):
                return true
            case (.groupChat, .groupChat):
                return true
            case (.singleChat, .singleChat):
                return true
            case (.msgSystem, .msgSystem):
                return true
            case (.msgAddfriend, .msgAddfriend):
                return true
            case (.createGroup, .createGroup):
                return true
            case (.ordinaryUserInfo, .ordinaryUserInfo):
                return true
            case (.newfriendList, .newfriendList):
                return true
            case (.publisherDesc, .publisherDesc):
                return true
            case (.searchTask, .searchTask):
                return true
            case (.selectTask, .selectTask):
                return true
            case (.shareTask, .shareTask):
                return true
            case (.searchUg, .searchUg):
                return true
            case (.makeupDeposit, .makeupDeposit):
                return true
            case (.buyCoin, .buyCoin):
                return true
            case (.coinRecord, .coinRecord):
                return true
            case (.shareTaskPoster, .shareTaskPoster):
                return true
            case (.accuse, .accuse):
                return true
            case (.publisher, .publisher):
                return true
            default:
                return false
            }
        }
    }
    
}
