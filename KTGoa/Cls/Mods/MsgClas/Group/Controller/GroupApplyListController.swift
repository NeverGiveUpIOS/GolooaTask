//
//  GroupApplyListController.swift
//  Golaa
//
//  Created by xiaoxuhui on 2024/5/24.
//

import UIKit

class GroupApplyListController: BasTableViewVC {
    
    var groupId: String = ""
    lazy var dataList = [GroupApplyModel]()
    
    override func routerParam(param: Any?, router: RoutinRouter?) {
        if let id = param as? String {
            self.groupId = id
        } else if let param = param as? [String: Any], let id = param["groupId"] as? String {
            self.groupId = id
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNav()
        setupHeadRefresh()
        setupFootRefresh()
        tableView?.rowHeight = 80
        tableView?.gt.register(cellClass: GroupMemberApplyCell.self)
        tableView?.snp.makeConstraints { make in
            make.top.equalTo(naviH)
            make.left.bottom.right.equalToSuperview()
        }
        getApplyList()
    }
    
    private func setNav() {
        navTitle("applicationList".msgLocalizable())
    }
    
    
    override func loadListData() {
        super.loadListData()
        getApplyList()
    }
}

extension GroupApplyListController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.gt.dequeueReusableCell(cellType: GroupMemberApplyCell.self, cellForRowAt: indexPath)
        if dataList.count > 0 {
            cell.bind(model: dataList[indexPath.row])
        }
        cell.nextCompleted = { [weak self] status, model in
            self?.mutateJoinVerify(model.id, status: status)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        RoutinStore.push(.ordinaryUserInfo, param: dataList[indexPath.row].toId)
    }
}

extension GroupApplyListController {
    
    private func getApplyList() {
        var params: [String: Any] = [:]
        params["groupId"] = groupId
        params["page.size"] = size
        params["page.current"] = page
        NetAPI.GroupAPI.applyList.reqToListHandler(parameters: params, model: GroupApplyModel.self) { [weak self] list, _  in
            guard let self = self else { return }
            
            if page == 1 {
                self.dataList.removeAll()
            }
            
            self.dataList.appends(list)
            self.setupEmptyView(self.dataList.count)
            self.endRefreshAndReloadData(list.count, self.dataList.count)

        } failed: { [weak self] _ in
            self?.setupEmptyView(0, img: .chatSearchEmpty)
            self?.endRefreshAndReloadData(0, 0)
        }
    }
    
    private func mutateJoinVerify(_ id: Int, status: Int) {
        GroupReq.joinVerify(id, status: status) { [weak self] error in
            if let self = self {
                if  error == nil {
                    self.dataList.forEach { model in
                        if model.id == id { model.status = status }
                    }
                }
            }
            self?.tableView?.reloadData()
        }
    }
    
}
