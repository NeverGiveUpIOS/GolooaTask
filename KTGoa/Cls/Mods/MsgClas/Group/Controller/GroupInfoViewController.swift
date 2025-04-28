//
//  GroupInfoViewController.swift
//  Golaa
//
//  Created by duke on 2024/5/11.
//

import UIKit

enum GroupInfoType {
    case normal
    case owner
}

class GroupInfoViewController: BasClasVC {
    
    var groupId: String = ""
    var groupMarkDes = ""
    
    lazy var groupInfo = NIMGroupModel()
    lazy var groupMemberList = [GroupMemberModel]()
    
    override func routerParam(param: Any?, router: RoutinRouter?) {
        if let id = param as? String {
            self.groupId = id
        } else if let param = param as? [String: Any], let id = param["groupId"] as? String {
            self.groupId = id
        }
    }
    
    var headCell = GroupTableHeadCell()
    var nameCell = GroupTableNameCell()
    var introCell = GroupTableIntroCell()
    var memberCell = GroupTableMemberCell()
    var emptyView = BasEmptyView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mutationGroupInfoResult()
        mutationGroupInfoResult()
    }
    
    func setNav() {
        navTitle("groupChatInformation".msgLocalizable())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNav()
        initState()
        setupCoder()
        setupAction()
    }
    
    func initState() {
        introCell.isHidden = true
        memberCell.isHidden = true
        nameCell.titleLabel.text = "groupName".msgLocalizable()
        headCell.titleLabel.text = "groupCover".msgLocalizable()
        introCell.titleLabel.text = "applicationExplanation".msgLocalizable()
    }
    
    func setupAction() {
        
        headCell.avatar.gt.addActionClosure {[weak self] _, _, _ in
            self?.showPicker()
        }
        
        nameCell.editNameBtn.gt.handleClick { [weak self] _ in
            guard let self = self else {return}
            let vc = GroupEditNameController()
            vc.groupId = self.groupId
            vc.nameDes = self.groupInfo.name
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        memberCell.memberNext.gt.handleClick { [weak self] _ in
            guard let self = self else { return }
            RoutinStore.push(.groupMember, param: self.groupId)
        }
        
        introCell.limitText.callBlock = { [weak self] text in
            self?.groupMarkDes = text
        }
    }
    
    func setupCoder() {
        
        view.addSubview(headCell)
        view.addSubview(nameCell)
        view.addSubview(introCell)
        view.addSubview(memberCell)
        view.addSubview(bottomBtn)
        view.addSubview(emptyView)

        headCell.snp.makeConstraints { make in
            make.height.equalTo(160)
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.top.equalTo(naviH + 15)
        }
        
        nameCell.snp.makeConstraints { make in
            make.height.equalTo(110)
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.top.equalTo(headCell.snp.bottom)
        }
        
        introCell.snp.makeConstraints { make in
            make.height.equalTo(190)
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.top.equalTo(nameCell.snp.bottom)
        }
        
        memberCell.snp.makeConstraints { make in
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.top.equalTo(nameCell.snp.bottom)
            make.bottom.equalTo(bottomBtn.snp.top).offset(-20)
        }
        
        bottomBtn.snp.makeConstraints { make in
            make.height.equalTo(52)
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.bottom.equalTo(-safeAreaBt-10)
        }
        
        emptyView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    override func rightItemClick() {
        super.rightItemClick()
        if groupInfo.status == .owner {
            RoutinStore.push(.groupApply, param: groupId)
        } else {
            RoutinStore.push(.accuse, param: ["type": 1, "toUserId": groupId])
        }
        
    }
    
    // MARK: -
    
    private lazy var bottomBtn: UIButton = {
        let btn = UIButton()
        btn.gt.setCornerRadius(8)
        btn.font(UIFontSemibold(15))
        btn.backgroundColor = .appColor
        btn.gt.handleClick { button in
            self.mutationDisbandGroup()
        }
        return btn
    }()
    
    /// 图片上传
    func showPicker() {
        PictureTl.shared.showAlertPic()
        PictureTl.shared.callImgBlock = { [weak self] img in
            AliyunOSSHelper.shared.update(images: [img]) { result, paths in
                if result, let groupId = self?.groupId {
                    GroupReq.updateGroup(groupId, icon: paths[0]) { error in
                        if error == nil {
                            self?.mutationGroupInfoResult()
                        }
                    }
                }
            }
        }
    }
}

extension GroupInfoViewController {
    
    /// 获取群组信息
    private func mutationGroupInfoResult() {
        var params: [String: Any] = [:]
        params["groupId"] = groupId
        NetAPI.GroupAPI.info.reqToModelHandler(parameters: params, model: NIMGroupModel.self) { [weak self] model, _ in
            self?.groupInfo = model
            self?.bind(model)
        } failed: { [weak self] error in
            self?.emptyView.isHidden = false
        }
    }
    
    /// 获取群成员列表
    private func mutationGroupMembersResult(){
        var params: [String: Any] = [:]
        params["groupId"] = groupId
        params["page.current"] = 1
        params["page.size"] = 1000
        NetAPI.GroupAPI.memberList.reqToListHandler(parameters: params, model: GroupMemberModel.self) { [weak self] list, _ in
            var list = list
            let add = GroupMemberModel()
            add.isAdd = true
            list.append(add)
            self?.groupMemberList = list
            self?.bindMemberList(list)
        } failed: { error in
        }
    }
}

extension GroupInfoViewController {
    
    private func bindMemberList(_ list: [GroupMemberModel]) {
        memberCell.members = list
    }
        
    private func bind(_ model: NIMGroupModel) {
        
        rightItem(model.status == .owner ? .groupApply : .groupReport)
        
        // 有申请入群消息数
        let isRemind = (model.isOwner && model.applyCount > 0)
        
        // 群id
        headCell.idLabel.text =  "\("groupId".msgLocalizable()) \(model.teamId)"
        // 群头像
        headCell.avatar.headerImageUrl(model.avatar)
        
        // 群昵称
        nameCell.nameLabel.text = model.name
        
        // 群成员数量
        memberCell.titleLabel.text = "\("groupMembers".msgLocalizable())（\(model.memberCount)/\(model.maxCount)）"
        memberCell.groupId = groupId
        
        var bottomDes: String = ""
        var bottomColor: UIColor = .appColor
        if model.status == .owner {
            bottomDes = "解散群聊"
            bottomDes = "dismissGroupChat".msgLocalizable()
           bottomColor = .hexStrToColor("#F96464")
        } else {
            if model.isJoined {
                bottomDes = "退出群聊"
                bottomDes = "exitGroupChat".msgLocalizable()
                bottomColor = .hexStrToColor("#F96464")
            } else if model.isApply {
                bottomDes = "等待群主同意"
                bottomDes = "waitingForGroupOwnersApproval".msgLocalizable()
                bottomColor = .appColor.alpha(0.4)
            } else {
                bottomDes = "发送申请"
                bottomDes = "sendApplication".msgLocalizable()
                bottomColor = .appColor
            }
        }
        bottomBtn.title(bottomDes)
        bottomBtn.backgroundColor = bottomColor
        
        nameCell.editNameBtn.isHidden = !model.isAdmin
        headCell.avatarCamera.isHidden = !model.isAdmin
        memberCell.isHidden = !model.isJoined
        introCell.isHidden = model.isJoined
        emptyView.isHidden = true
        introCell.limitText.isUserInteractionEnabled = !model.isApply
        headCell.avatar.isUserInteractionEnabled = model.isAdmin

    }
}

extension GroupInfoViewController {
    
    /// 群操作
    private func mutationDisbandGroup() {
        if groupInfo.status == .owner {
            AlertPopView.show(titles: "tip".globalLocalizable(),
                              contents: "removeGroupAreYouSureYouWant".msgLocalizable(),
                              completion: {
                GroupReq.disbandGroup(self.groupId) { error in
                    if error == nil {
                        RoutinStore.navigator?.popViewController(animated: true)
                    }
                }
            })

        } else {
            
            if groupInfo.isJoined {
                AlertPopView.show(titles: "tip".globalLocalizable(),
                                  contents: "exitGroupAreYouSureYouWant".msgLocalizable(),
                                  completion: {
                    GroupReq.exitGroup(self.groupId) { error in
                        if error == nil {
                            RoutinStore.navigator?.popViewController(animated: true)
                        }
                    }
                })

            } else if groupInfo.isApply {
                
            } else {
                let des = self.groupMarkDes
                GroupReq.applyGroup(groupId, remark: des) { error in
                    if error == nil {
                        RoutinStore.navigator?.popViewController(animated: true)
                    }
                }
            }
        }
    }
}
