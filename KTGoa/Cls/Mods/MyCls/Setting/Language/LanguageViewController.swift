//
//  LanguageViewController.swift
//  Golaa
//
//  Created by Cb on 2024/5/16.
//

import UIKit

class LanguageViewController: BasClasVC {
    
    lazy var dataList: [LanguageSectionType] = [.section(items: LanguageType.caseModels)]
    
    var selectItem: LanguageModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        configViews()
        configActions()
    }
    
    private func configViews() {
        navTitle("languageSettings".meLocalizable())
        view.backgroundColor = .hexStrToColor("#F2F2F2")

        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(naviH)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        view.addSubview(saveBtn)
        saveBtn.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.bottom.equalTo(-safeAreaBt-20)
            make.height.equalTo(52)
        }
    }
    
    private func configActions() {
        
        saveBtn.gt.handleClick { [weak self] _ in
            guard let self = self else { return }
            guard let model = self.selectItem, model.isSelect else { return }
            
            var param = [String: Any]()
            param["language"] = model.type.netValue
            
            LoginTl.shared.editUsr(param) { info in
                if info != nil {
                    LanguageTl.shared.changeLanguage(language: model.type)
                    RoutinStore.dismiss()
                }
            }
        }
        
    }

    override func onLanguageChange() {
        navTitle("languageSettings".meLocalizable())
        saveBtn.setTitle("save".meLocalizable(), for: .normal)
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
        tab.register(LanguageCell.self, forCellReuseIdentifier: "LanguageCell")
        tab.separatorInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        tab.separatorColor = .hexStrToColor("#F2F2F2")
        tab.rowHeight = 51
        tab.tableFooterView = UIView(frame: .zero)
        tab.delegate = self
        tab.dataSource = self
        return tab
    }()
    
    private lazy var saveBtn: UIButton = {
        let btn = UIButton()
        btn.gt.setCornerRadius(8)
        btn.backgroundColor = UIColor.appColor
        btn.setTitle("save".meLocalizable(), for: .normal)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 16)
        btn.setTitleColor(UIColor.hexStrToColor("#000000"), for: .normal)
        return btn
    }()
    
}


extension LanguageViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageCell", for: indexPath)
        if let cell = cell as? LanguageCell {
            cell.configItem(dataList[indexPath.section].items[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var model = dataList[indexPath.section].items[indexPath.row]
        model.isSelect = true
        self.selectItem = model

        let section = dataList[indexPath.section]
        var items = section.items
        for index in items.indices {
            if index == indexPath.row {
                items[index].resetSelect(true)
            } else {
                items[index].resetSelect()
            }
        }
        
        dataList = [.section(items: items)]
        
        self.tableView.reloadData()
    }
    
}

extension LanguageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { 15 }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { 0 }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? { nil }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? { nil }
}
