//
//  SelectTaskListViewController.swift
//  Golaa
//
//  Created by duke on 2024/5/22.
//

import UIKit

enum SelectTaskListType: Int {
    case my = 0
    case pub = 1
}

class SelectTaskListViewController: BasTableViewVC {
    
    var type: SelectTaskListType
    var tapSendBlock: ((SelectTaskListModel) -> Void)?
    lazy var dataList = [SelectTaskListModel]()
    
    init(type: SelectTaskListType, tapSendBlock: ((SelectTaskListModel) -> Void)?) {
        self.type = type
        self.tapSendBlock = tapSendBlock
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        mutateLoadListDataReuslt(type)
    }
    
    
    private func buildUI() {
        basNavbView?.isHidden = true
        view.backgroundColor = .clear
        setupFootRefresh()
        setupHeadRefresh()
        tableView?.rowHeight = 100
        tableView?.gt.register(cellClass: SelectTaskListCell.self)
        tableView?.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func loadListData() {
        super.loadListData()
        mutateLoadListDataReuslt(type)
    }
}

extension SelectTaskListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.gt.dequeueReusableCell(cellType: SelectTaskListCell.self, cellForRowAt: indexPath)
        if dataList.count > 0 {
            cell.bind(model: dataList[indexPath.row])
            cell.tapSendBlock = self.tapSendBlock
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataList[indexPath.row]
        RoutinStore.push(.taskDesc, param: ["id": model.id, "source": TaskDescFromSource.other.rawValue])
    }
}


extension SelectTaskListViewController {
    
    private func mutateLoadListDataReuslt(_ type: SelectTaskListType) {
        
        var params: [String: Any] = [:]
        params["page.current"] = page
        params["page.size"] = size
        params["tab"] = type.rawValue
        NetAPI.HomeAPI.myTaskList.reqToListHandler(parameters: params, model: SelectTaskListModel.self) { [weak self] list, _ in
            guard let self = self else { return }
            if page == 1 {
                self.dataList.removeAll()
            }
            self.dataList.append(contentsOf: list)
            self.setupEmptyView(self.dataList.count)
            self.endRefreshAndReloadData(list.count, self.dataList.count)
        } failed: { [weak self] error in
            self?.setupEmptyView(0)
            self?.endRefreshAndReloadData(0, 0)
            print("error: \(error)")
        }
    }

}

extension SelectTaskListViewController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        view
    }
}
