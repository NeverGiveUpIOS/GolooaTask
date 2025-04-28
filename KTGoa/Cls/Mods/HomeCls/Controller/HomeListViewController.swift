//
//  HomeListViewController.swift
//  Golaa
//
//  Created by duke on 2024/5/14.
//

import UIKit
import JXPagingView
import JXSegmentedView

enum HomeListType: Int {
    case all = 0
    case new = 1
}

class HomeListViewController: BasTableViewVC {
    
    var type: HomeListType
    lazy var dataList = [HomeListModel]()
    
    init(type: HomeListType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var didScrollBlock: ((UIScrollView) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildUI()
        mutateLoadListDataReuslt()
    }

    private func buildUI() {
        setupHeadRefresh()
        setupFootRefresh()
        tableView?.rowHeight = 115.dbw
        tableView?.gt.register(cellClass: HomeListCell.self)
        tableView?.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    
    override func loadListData() {
        super.loadListData()
        mutateLoadListDataReuslt()
    }
    
}

extension HomeListViewController {
    
    private func mutateLoadListDataReuslt() {
        var params: [String: Any] = [:]
        params["page.current"] = page
        params["page.size"] = size
        params["tab"] = type.rawValue
        NetAPI.HomeAPI.taskList.reqToListHandler(parameters: params, model: HomeListModel.self) { [weak self] list, _ in
            guard let self = self else { return }
            if page == 1 {
                self.dataList.removeAll()
            }
            self.dataList.append(contentsOf: list)
            self.setupEmptyView(self.dataList.count)
            self.endRefreshAndReloadData(list.count, self.dataList.count)
        } failed: { error in
            print("error: \(error)")
            self.setupEmptyView(0)
            self.endRefreshAndReloadData(0, 0)
        }
        
    }

}

extension HomeListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.gt.dequeueReusableCell(cellType: HomeListCell.self, cellForRowAt: indexPath)
        if dataList.count > 0 {
            cell.bind(dataList[indexPath.row])
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let model = dataList[indexPath.row]
        RoutinStore.push(.taskDesc, param: ["id": model.id, "source": TaskDescFromSource.home.rawValue])
        FlyerLibHelper.log(.taskClick, values: ["task_id": model.id])
    }
}

extension HomeListViewController: JXSegmentedListContainerViewListDelegate, JXPagingViewListViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        didScrollBlock?(scrollView)
    }
    
    func listScrollView() -> UIScrollView {
       return tableView ?? UITableView()
    }
    
    func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> Void) {
        didScrollBlock = callback
    }
    
    func listView() -> UIView {
        view
    }
}
