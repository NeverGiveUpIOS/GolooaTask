//
//  DenyListViewController.swift
//  Golaa
//
//  Created by Cb on 2024/5/17.
//

import Foundation

class DenyListViewController: BasTableViewVC {
    
    lazy var dataList = [DenyListModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configViews()
        configActions()
        obserDenyList()
    }
    
    override func loadListData() {
        super.loadListData()
        obserDenyList()
    }
    
    private func configViews() {
        navTitle("blacklist".meLocalizable())
        view.backgroundColor = .hexStrToColor("#FFFFFF")
        
        tableView?.estimatedRowHeight = 0.01
        tableView?.estimatedSectionFooterHeight = 0.01
        tableView?.estimatedSectionHeaderHeight = 0.01
        tableView?.backgroundColor = .hexStrToColor("#F2F2F2")
        tableView?.register(DenyListCell.self, forCellReuseIdentifier: "DenyListCell")
        tableView?.separatorInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        tableView?.separatorColor = .hexStrToColor("#F2F2F2")
        tableView?.rowHeight = 76
        tableView?.tableFooterView = UIView(frame: .zero)
        tableView?.delegate = self
        tableView?.snp.makeConstraints { make in
            make.top.equalTo(naviH)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func configActions() {
        logoutBtn.gt.handleClick { _ in
            LoginTl.shared.logout()
        }
        
        setupHeadRefresh()
        setupFootRefresh()
    }
    
    override func onLanguageChange() {
        navTitle("blacklist".meLocalizable())
        tableView?.reloadData()
    }
    
    private let logoutBtn: UIButton = {
        let btn = UIButton()
        btn.gt.setCornerRadius(25)
        btn.backgroundColor = .white
        btn.setTitle("logOut".meLocalizable(), for: .normal)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 18)
        btn.setTitleColor(UIColor.hexStrToColor("#F96464"), for: .normal)
        return btn
    }()
    
}

extension DenyListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DenyListCell", for: indexPath)
        if let cell = cell as? DenyListCell {
            cell.configItem(dataList[indexPath.row])
            cell.onRemoveClosure = { [weak self] in
                if let self = self {
                    self.userFriendBlock(self.dataList[indexPath.row])
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { 0 }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { 0 }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? { nil }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? { nil }
}

extension DenyListViewController {
    
    private  func obserDenyList() {
        MineReq.denyList(page, size: size) { [weak self] list in
            guard let self = self else {
                return
            }
            if self.page == 1 {
                self.dataList.removeAll()
            }
            self.dataList.appends(list)
            
            self.setupEmptyView(self.dataList.count)
            self.endRefreshAndReloadData(list.count, self.dataList.count)
        }
    }
    
    private func userFriendBlock(_ model: DenyListModel) {
        
        NetAPI.MessageAPI.userFriendBlock.reqToJsonHandler(parameters: ["toUserId": model.user.userId, "status": 0]) { originalData in
            if let msg = originalData.json["msg"] as? String {
                ToastHud.showToastAction(message: msg)
            }
            self.obserDenyList()
        } failed: { error in
            ToastHud.showToastAction(message: error.localizedDescription)
        }
    }
    
}
