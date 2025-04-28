//
//  BasTableViewVC.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/7/23.
//

import UIKit

class BasTableViewVC: BasClasVC {
    
    var page = 1
    var size = 10
    
    var tableView: UITableView?
    var emptyView: BasEmptyView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupWidgetLayout() {
        super.setupWidgetLayout()
        
        tableView = UITableView(frame: .init(x: 0, y: naviH, width: screW, height: screH - naviH - tabBarH), style: .plain)
        tableView?.estimatedRowHeight = 1
        tableView?.estimatedSectionHeaderHeight = 0
        tableView?.estimatedSectionFooterHeight = 0
        tableView?.showsHorizontalScrollIndicator = false
        tableView?.showsVerticalScrollIndicator = false
        tableView?.dataSource = self
        tableView?.separatorStyle = .none
        tableView?.delegate = self
        tableView?.scrollIndicatorInsets = tableView?.contentInset ?? UIEdgeInsets.zero
        if #available(iOS 15.0, *) {
            tableView?.sectionHeaderTopPadding = 0
        }
        tableView?.contentInsetAdjustmentBehavior = .never
        
        view.addSubview(tableView!)
    }
    
    func setupEmptyView(_ count: NSInteger, img: UIImage = .emptyDataIcon, text: String = "dataEmpty".globalLocalizable()) {
        
        tableView?.footer?.isHidden = (count < size && page == 1)
        
        if count > 0 {
            emptyView?.removeFromSuperview()
            return
        }
        DispatchQueue.main.async {
            self.emptyView?.removeFromSuperview()
            self.emptyView = BasEmptyView()
            self.tableView?.addSubview(self.emptyView!)
            self.emptyView?.setupEmptyImg(img, text)
            self.emptyView?.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.width.lessThanOrEqualTo(screW)
                make.height.lessThanOrEqualTo(screH - 200)
            }
        }
    }
    
    func setupHeadRefresh() {
        tableView?.header = JRefreshStateHeader.headerWithRefreshingBlock({[weak self] in
            guard let `self` = self else {return}
            self.page = 1
            self.loadListData()
        })
    }
    
    func setupFootRefresh() {
        tableView?.footer = GTRefreshAutoNormalFooter.footerWithRefreshingBlock({[weak self] in
            guard let `self` = self else {return}
            self.page += 1
            self.loadListData()
        })
        tableView?.footer?.isHidden = true
    }
    
    /// 数据请求
    func loadListData() {
    }
    
    func endRefresh() {
        tableView?.footer?.endRefreshing()
        tableView?.header?.endRefreshing()
    }
    
    /// tabRegister
    func tabRegister(tabCell: UITableViewCell.Type) {
        tableView?.gt.register(cellClass: tabCell)
    }
    
    /// tabRegister
    func tabRegisterNib(tabCell: UITableViewCell.Type) {
        tableView?.gt.register(nibName: tabCell.className)
    }
    
    /// 结束上下拉刷新
    /// count：请求回来的数据模型数组count,
    /// totals: 页面的总数据数组 用于没有数据时隐藏
    func endRefreshAndReloadData(_ count: Int, _ totals: Int) {
        endRefresh()
        if count <= 0 && totals >= size {
            tableView?.footer?.endRefreshingWithNoMoreData()
            tableView?.footer?.isHidden = false
        } else {
            if totals <= size {
                tableView?.footer?.isHidden = true
            } else {
                tableView?.footer?.isHidden = false
            }
        }

        tableView?.reloadData()
    }
    
}

extension BasTableViewVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
