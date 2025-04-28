//
//  AboutViewController.swift
//  Golaa
//
//  Created by Cb on 2024/5/17.
//

import Foundation

class AboutViewController: BasClasVC {
    
    var dataList: [AboutSectionType] = [.section(items: AboutType.modulues)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configViews()
        configActions()
    }
    
    private func configViews() {
        navTitle("aboutUs".meLocalizable())
        view.backgroundColor = .hexStrToColor("#F2F2F2")
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(naviH)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func configActions() {}
    
    override func onLanguageChange() {
        navTitle("aboutUs".meLocalizable())
        tableView.reloadData()
    }
    
    
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        if #available(iOS 11.0, *) {
            view.contentInsetAdjustmentBehavior = .never
        }
        view.estimatedRowHeight = 0.01
        view.estimatedSectionFooterHeight = 0.01
        view.estimatedSectionHeaderHeight = 0.01
        view.backgroundColor = .hexStrToColor("#F2F2F2")
        view.register(AboutCell.self, forCellReuseIdentifier: "AboutCell")
        view.separatorInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        view.separatorColor = .hexStrToColor("#F2F2F2")
        view.rowHeight = 51
        view.tableFooterView = UIView(frame: .zero)
        view.delegate = self
        view.dataSource = self
        view.tableHeaderView = headerView
        return view
    }()
    
    private let headerView = AboutHeader(frame: CGRect(x: 0, y: 0, width: screW, height: 180))
}

extension AboutViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AboutCell", for: indexPath)
        if let cell = cell as? AboutCell {
            cell.configItem(dataList[indexPath.section].items[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = dataList[indexPath.section]
        let item = section.items[indexPath.row]
        item.push()
    }
}

extension AboutViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { 0 }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { 0 }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? { nil }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? { nil }
}
