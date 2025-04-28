//
//  GroupMemberViewController.swift
//  Golaa
//
//  Created by xiaoxuhui on 2024/5/24.
//

import UIKit
class GroupMemberViewController: BasTableViewVC {
    
    var groupId: String = ""
    lazy var dataList = [GroupMemberModel]()
    
    override func routerParam(param: Any?, router: RoutinRouter?) {
        if let id = param as? String {
            self.groupId = id
        } else if let param = param as? [String: Any], let id = param["groupId"] as? String {
            self.groupId = id
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navTitle("groupMembers".msgLocalizable())
        setupHeadRefresh()
        setupFootRefresh()
        tableView?.rowHeight = 80
        tableView?.gt.register(cellClass: GroupMemberCell.self)
        tableView?.snp.makeConstraints { make in
            make.top.equalTo(naviH)
            make.left.bottom.right.equalToSuperview()
        }
        
        mutateLoadMembersList()
    }
    
    override func loadListData() {
        super.loadListData()
        mutateLoadMembersList()
    }
    
}

extension GroupMemberViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.gt.dequeueReusableCell(cellType: GroupMemberCell.self, cellForRowAt: indexPath)
        if dataList.count > 0 {
            cell.bind(model: dataList[indexPath.row])
        }
        cell.kickBlock = { [weak self] model in
            guard let self = self else { return }
            self.mutationKickUser(userId: model.userId)
        }
        
        cell.muteBlock = { [weak self] model in
            guard let self = self else { return }
            self.mutationMuteUser(userId: model.userId, mute: !model.mute)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        RoutinStore.push(.ordinaryUserInfo, param: dataList[indexPath.row].userId)
    }
}

extension GroupMemberViewController {
    
    private func mutateLoadMembersList() {
        var params: [String: Any] = [:]
        params["groupId"] = groupId
        params["page.size"] = size
        params["page.current"] = page
        NetAPI.GroupAPI.memberList.reqToListHandler(parameters: params, model: GroupMemberModel.self) { [weak self] list, _  in
            guard let self = self else { return }
            
            if page == 1 {
                self.dataList.removeAll()
            }
            
            self.dataList.appends(list)
            self.setupEmptyView(self.dataList.count)
            self.endRefreshAndReloadData(list.count, self.dataList.count)

        } failed: { [weak self] _ in
            self?.setupEmptyView(0)
            self?.endRefreshAndReloadData(0, 0)
        }
    }
    
    private func mutationKickUser(userId: String) {
        AlertPopView.show(titles: "tip".globalLocalizable(),
                          contents: "removeUserAreYouSureYouWant".msgLocalizable(),
                          completion: { [weak self] in
            GroupReq.removeUser(self?.groupId ?? "", userId: userId) { [weak self] error in
                if let _ = error {
                } else {
                    self?.dataList.removeAll(where: {$0.userId == userId})
                    self?.tableView?.reloadData()
                }
            }
        })
    }
    
    private func mutationMuteUser(userId: String, mute: Bool) {
        GroupReq.muteUser(groupId, userId: userId, mute: mute) { [weak self] error in
            if let _ = error {
            } else {
                self?.dataList.forEach { model in
                    if model.userId == userId {
                        model.mute = !model.mute
                    }
                }
            }
            self?.tableView?.reloadData()
        }
    }
    
}
