//
//  HomeClasVC.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/7/23.
//

import UIKit

class HomeClasVC: BasTableViewVC {
    
    var maxTopViewHeight = CGFloat(175)
//    var list = 10
    
    lazy var dataList = [HomeListModel]()
    
    lazy var topView = HomeTopView(frame: .init(x: 0, y: 0, width: screW, height: maxTopViewHeight))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hiddenNavView(true)
        view.addSubview(topView)
        tabRegisterNib(tabCell: HomeClasCell.self)
        tableView?.gt.y = topView.gt.bottom
        tableView?.gt.height = screH - tabBarH - topView.gt.bottom
        tableView?.tableHeaderView = UIView(frame: .init(x: 0, y: 0, width: screW, height: 15))
        
        topView.callBlock = { [weak self] type in
            self?.getMyTaskList( type == .all ? 0 : 1)
        }
        
        getMyTaskList()
        // 默认进入全部任务列表
        FlyerLibHelper.log(.allTasksListClick)
        // 获取客服链接
        GlobalReq.comKufu { _ in }
        mm.imLogin()
    }
    
    private func getMyTaskList(_ type: NSInteger = 0) {
        HomeReq.getTaskData(["tab": type]) { [weak self] list in
            self?.dataList = list
            self?.tableView?.reloadData()
            self?.setupEmptyView(list.count)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.gt.dequeueReusableCell(cellType: HomeClasCell.self, cellForRowAt: indexPath)
        cell.model = dataList[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = HomeReleTaskClasVc()
        vc.type = .detail
        vc.taskListInfo = dataList[indexPath.row]
       getTopController().gt.pushViewController(vc)

    }

}
