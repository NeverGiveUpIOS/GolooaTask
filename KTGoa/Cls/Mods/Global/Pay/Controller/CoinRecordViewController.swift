//
//  CoinRecordViewController.swift
//  Golaa
//
//  Created by duke on 2024/5/25.
//

import UIKit

class CoinRecordViewController: BasTableViewVC {

    lazy var dataList = [CoinRecordModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        mutateLoadListDataReuslt()
    }
    
    private func buildUI() {
        navTitle("coinRecords".globalLocalizable())
        setupHeadRefresh()
        setupFootRefresh()
        tableView?.register(CoinRecordCell.self, forCellReuseIdentifier: NSStringFromClass(CoinRecordCell.self))
        tableView?.estimatedRowHeight = 63
        if #available(iOS 13.0, *) {
            tableView?.automaticallyAdjustsScrollIndicatorInsets = true
        }
        tableView?.rowHeight = UITableView.automaticDimension
        tableView?.snp.remakeConstraints { make in
            make.top.equalTo(naviH)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(-safeAreaBt)
        }
    }
    
    override func loadListData() {
        super.loadListData()
        mutateLoadListDataReuslt()
    }
    
}

extension CoinRecordViewController {
    
    private func mutateLoadListDataReuslt() {

        var params: [String: Any] = [:]
            params["page.current"] = page
            params["page.size"] = size
        
            NetAPI.GlobalAPI.coinRecordList.reqToListHandler(parameters: params, model: CoinRecordModel.self) { [weak self] list, _ in
                guard let self = self else { return }
                
                if page == 1 {
                    self.dataList.removeAll()
                }
                self.dataList.append(contentsOf: list)
                
                self.setupEmptyView(self.dataList.count)
                self.endRefreshAndReloadData(list.count, self.dataList.count)
            } failed: { error in
                self.setupEmptyView(0)
                self.endRefreshAndReloadData(0,0)
            }
    }
    
}

extension CoinRecordViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(CoinRecordCell.self), for: indexPath) as? CoinRecordCell ?? CoinRecordCell()
        cell.bind(model: self.dataList[indexPath.row])
        return cell
    }
}
