//
//  SettingViewController.swift
//  Golaa
//
//  Created by Cb on 2024/5/15.
//

import UIKit

class SettingViewController: BasClasVC {
    
    var dataList: [SettingSectionType] = [.section(items: SettingType.modulues)]

    override func viewDidLoad() {
        super.viewDidLoad()
        configViews()
        configActions()
    }
    
    private func configViews() {
        navTitle("settingsCenter".meLocalizable())
        view.backgroundColor = .hexStrToColor("#F2F2F2")
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(naviH)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        view.addSubview(logoutBtn)
        logoutBtn.snp.makeConstraints { make in
            make.bottom.equalTo(-safeAreaBt - 20)
            make.leading.equalTo(38)
            make.trailing.equalTo(-38)
            make.height.equalTo(50)
        }
    }
    
    private func configActions() {
        logoutBtn.gt.handleClick { [weak self] _ in
            guard let self = self else { return }
            AlertPopView.show(titles: "logOut".meLocalizable(), contents: "areYouSureYouWantToLogout".meLocalizable(), completion: { [weak self] in
                self?.toLogout()
            })
        }
    }
    
    override func onLanguageChange() {
        super.onLanguageChange()
        
        navTitle("settingsCenter".meLocalizable())
        logoutBtn.setTitle("logOut".meLocalizable(), for: .normal)
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
        tab.register(SettingCell.self, forCellReuseIdentifier: "SettingCell")
        tab.separatorInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        tab.separatorColor = .hexStrToColor("#F2F2F2")
        tab.rowHeight = 51
        tab.tableFooterView = UIView(frame: .zero)
        tab.delegate = self
        tab.dataSource = self
        return tab
    }()
    
    private let logoutBtn: UIButton = {
        let btn = UIButton()
        btn.gt.setCornerRadius(25)
        btn.backgroundColor = .white
        btn.setTitle("logOut".meLocalizable(), for: .normal)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 18)
        btn.setTitleColor(.hexStrToColor("#F96464"), for: .normal)
        return btn
    }()
}

//extension SettingViewController: View {
//
//    func bind(reactor: SettingReactor) {
//
//        // 坑不要试图把cell获取挪出到方法获取，会引入引用问题导致持有控制器不释放
//        reactor.state.map({ $0.list }).asDriver(onErrorJustReturn: []).drive(tableView.rx.items(dataSource: RxTableViewSectionedReloadDataSource<SettingSectionType>(configureCell: { _, tableView, indexPath, item -> UITableViewCell in
//            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath)
//            if let cell = cell as? SettingCell {
//                cell.configItem(item)
//            }
//            return cell
//        }))).disposed(by: disposeBag)
//
//        // 信号组合
//        Observable.combineLatest(tableView.rx.itemSelected, reactor.state.map({ $0.list })).bind(to: rx.itemSelected).disposed(by: disposeBag)
//
//        let loadPublish = PublishSubject<Void>()
//        loadPublish.asObservable().map({ SettingReactor.Action.loadData }).bind(to: reactor.action).disposed(by: disposeBag)
//        loadPublish.onNext(())
//
//        // 登出
//        reactor.pulse(\.$result).subscribe(onNext: { result in
//            if result {
//                LoginHelper.shared.logout()
//            }
//            FlyerLibHelper.log(.logoutClick, result: result)
//        }).disposed(by: disposeBag)
//    }
//}

extension SettingViewController {
    
    private func toLogout() {
        LoginReq.toLogout(completion: { isSuccess in
            LoginTl.shared.logout()
            FlyerLibHelper.log(.logoutClick, result: true)
        })
    }
}

extension SettingViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath)
        if let cell = cell as? SettingCell {
            cell.configItem(dataList[indexPath.section].items[indexPath.row])
        }
        return cell    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList[section].items.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = dataList[indexPath.section]
        let row = section.items[indexPath.row]
        row.push()
    }
    
}

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { 15 }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { 0 }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? { nil }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? { nil }
}
