//
//  MineViewController.swift
//  Golaa
//
//  Created by chenkaisong on 2024/5/5.
//

import UIKit

class MineViewController: BasClasVC {
    
    lazy var sections: [MineTableSession] = MineTableSession.caseList()
    lazy var balanceModel = HomeBalanceModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configViews()
        configActions()
        addNotiObserver(self, #selector(inEndGidRelay), "inEndGidRelay")
    }
    
    @objc private func inEndGidRelay() {
        self.tableView.reloadData()
    }
    
    deinit {
        removeNotiObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getBalance()
    }
    
    private func configViews() {
        hiddenNavView(true)
        view.backgroundColor = .hexStrToColor("#F2F2F2")
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configActions() {}
    
    override func onLanguageChange() {
        tableView.reloadData()
    }
    
    func getBalance() {
        NetAPI.HomeAPI.balance.reqToModelHandler(parameters: nil, model: HomeBalanceModel.self) { [weak self] model, _ in
            self?.balanceModel = model
            self?.tableView.reloadData()
        } failed: { error in
            
        }
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
        tab.register(MineContentCell.self, forCellReuseIdentifier: "MineContentCell")
        tab.register(MineHeaderCell.self, forCellReuseIdentifier: "MineHeaderCell")
        tab.separatorStyle = .none
        tab.delegate = self
        tab.dataSource = self
        return tab
    }()
    
}

extension MineViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = sections[indexPath.section]
        if section.isHeader {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MineHeaderCell", for: indexPath)
            if let cell = cell as? MineHeaderCell {
                let item = section.items[indexPath.row]
                cell.configList(item.moduleList)
                cell.configureItem(balanceModel)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MineContentCell", for: indexPath)
            if let cell = cell as? MineContentCell {
                let item = section.items[indexPath.row]
                cell.listView.configModule(item)
            }
            return cell
        }    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = sections[indexPath.section].items[indexPath.row]
        return row.itemHeight(section: indexPath.section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { 0 }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { 0 }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? { nil }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? { nil }
}
