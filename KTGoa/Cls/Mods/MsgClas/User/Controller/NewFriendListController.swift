//
//  NewFriendListController.swift
//  Golaa
//
//  Created by chenkaisong on 2024/5/20.
//

import UIKit

class NewFriendListController: BasTableViewVC {
    
    lazy var dataList = [NewFriendListModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navTitle(("newFriends".msgLocalizable()))
        setupSubviews()
        setupHeadRefresh()
        setupFootRefresh()
    }
    
    private func setupSubviews() {
        tableView?.tableHeaderView = UIView(frame: .init(x: 0, y: 0, width: 10, height: 10))
        tableView?.gt.register(cellClass: NewFriendListCell.self)
        tableView?.gt.height = screH - naviH
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadListData()
    }
    
    override func loadListData() {
        super.loadListData()
        addFriendLogList()
    }
    
}

// MARK: - ReqData
extension NewFriendListController {
    
    func addFriendLogList() {
        
        MessageReq.addFriendLogList(page: page, size: size) { [weak self] list in
            guard let self = self else { return }
                        
            if page == 1 {
                self.dataList.removeAll()
            }
            
            self.dataList.appends(list)
            self.setupEmptyView(self.dataList.count)
            self.endRefreshAndReloadData(list.count, self.dataList.count)

        }
    }
    
}

extension NewFriendListController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.gt.dequeueReusableCell(cellType: NewFriendListCell.self, cellForRowAt: indexPath)
        if dataList.count > 0 {
            cell.info = dataList[indexPath.row]
        }
        cell.callChangeBlock = { [weak self] _ in
            self?.loadListData()
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = dataList[indexPath.row]
        
        if model.toUser?.isPublish == true {
            RoutinStore.push(.publisherDesc, param: model.toUser?.id ?? "")
        } else {
            RoutinStore.push(.ordinaryUserInfo, param: model.toUser?.id ?? "")
        }
    }
}
