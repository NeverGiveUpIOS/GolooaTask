//
//  BroadcastViewController.swift
//  Golaa
//
//  Created by Cb on 2024/5/16.
//

import Foundation

class BroadcastViewController: BasClasVC {
    
    lazy var dataList: [BroadcastSectionType] = [.section(items: BroadcastType.caseModels)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configViews()
        configActions()
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkNoteState), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func checkNoteState() {
        let list = dataList.first?.items ?? BroadcastType.caseModels
        UIApplication.gt.checkPushNotification { [weak self] authorized in
            self?.dataList = [.section(items: BroadcastType.caseNoteState(authorized, list: list))]
            self?.tableView.reloadData()
        }
    }
    
    private func configViews() {
        navTitle("notificationSettings".meLocalizable())
        view.backgroundColor = .hexStrToColor("#F2F2F2")
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(naviH)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func configActions() {}
    
    override func onLanguageChange() {
        navTitle("notificationSettings".meLocalizable())
        tableView.reloadData()
    }
    
    private lazy var tableView: UITableView = {
        let tab = UITableView(frame: .zero, style: .grouped)
        if #available(iOS 11.0, *) {
            tab.contentInsetAdjustmentBehavior = .never
        }
        tab.estimatedRowHeight = 0.01
        tab.estimatedSectionFooterHeight = 0.01
        tab.estimatedSectionHeaderHeight = 0.01
        tab.backgroundColor = .hexStrToColor("#F2F2F2")
        tab.register(BroadcastCell.self, forCellReuseIdentifier: "SettingCell")
        tab.separatorInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        tab.separatorColor = .hexStrToColor("#F2F2F2")
        tab.rowHeight = 51
        tab.tableFooterView = UIView(frame: .zero)
        tab.delegate = self
        tab.dataSource = self
        return tab
    }()
    
}

extension BroadcastViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath)
        if let cell = cell as? BroadcastCell {
            cell.configItem(dataList[indexPath.section].items[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { 15 }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { 0 }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? { nil }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? { nil }
}
