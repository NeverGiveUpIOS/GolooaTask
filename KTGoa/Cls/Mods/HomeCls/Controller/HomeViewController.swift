//
//  HomeViewController.swift
//  Golaa
//
//  Created by chenkaisong on 2024/5/5.
//

import UIKit
import JXPagingView
import JXSegmentedView

extension JXPagingListContainerView: JXSegmentedViewListContainer {}

class HomeViewController: BasClasVC {
    
    private var titles = ["all".homeLocalizable(), "new".homeLocalizable()]
    
    lazy var taskData = HomeTaskDataModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildUI()
        mm.imLogin()
        // 默认进入全部任务列表
        FlyerLibHelper.log(.allTasksListClick)
        // 获取客服链接
        GlobalReq.comKufu { _ in }
        addNotiObserver(self, #selector(inEndGidRelay), "inEndGidRelay")
    }
    
    @objc private func inEndGidRelay() {
        self.paingView.reloadData()
        self.headerView.setupContents()
    }
    
    deinit {
        removeNotiObserver(self)
    }
    
    private func buildUI() {
        navTitle("")
        hiddenNavView(true)
        view.backgroundColor = .xf2
        view.addSubview(paingView)
        paingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mutateLoadTaskData()
    }
    
    
    override func onLanguageChange() {
        titles = ["all".homeLocalizable(), "new".homeLocalizable()]
        titleSource.titles = titles
        segmentView.reloadData()
        paingView.listContainerView.reloadData()
        headerView.bind(taskData)
    }
    
    @objc private func clickSearchView(sender: UITapGestureRecognizer) {
        RoutinStore.push(.searchTask)
        FlyerLibHelper.log(.searchClick)
    }
    
    private lazy var paingView: JXPagingListRefreshView = {
        let view = JXPagingListRefreshView(delegate: self)
        view.pinSectionHeaderVerticalOffset = Int(safeAreaTp)
        view.backgroundColor = .clear
        view.mainTableView.backgroundColor = .clear
        return view
    }()
    
    private lazy var headerView = HomeHeaderView()
    private lazy var eptView = UIView()
    
    private lazy var searchView: UIView = {
        let view = UIView()
        view.backgroundColor = .xf2
        view.gt.setCornerRadius(17.5.dbw)
        let icon = UIImageView()
        icon.image = .homeSearch
        view.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(15.dbw)
        }
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickSearchView)))
        return view
    }()
    
    private lazy var segmentView: JXSegmentedView = {
        let view = JXSegmentedView()
        view.backgroundColor = .white
        view.dataSource = titleSource
        view.listContainer = paingView.listContainerView
        view.gt.setCustomCoRadius([.layerMinXMinYCorner, .layerMaxXMinYCorner], cornerRadius: 18)
        view.addSubview(searchView)
        view.delegate = self
        searchView.snp.makeConstraints { make in
            make.top.equalTo(15.dbw)
            make.trailing.equalTo(-15.dbw)
            make.width.equalTo(60.dbw)
            make.height.equalTo(35.dbw)
        }
        return view
    }()
    
    private lazy var titleSource: JXSegmentedTitleDataSource = {
        let titleSource = JXSegmentedTitleDataSource()
        titleSource.titles = titles
        titleSource.titleNormalColor = .hexStrToColor("#999999")
        titleSource.titleSelectedColor = .black
        titleSource.titleNormalFont = UIFontReg(18.dbw)
        titleSource.titleSelectedFont = UIFontSemibold(18.dbw)
        titleSource.itemSpacing = 15.dbw
        titleSource.isItemSpacingAverageEnabled = false
        return titleSource
    }()
}

extension HomeViewController {
    
    func  mutateLoadTaskData() {
        NetAPI.HomeAPI.taskData.reqToModelHandler(parameters: nil, model: HomeTaskDataModel.self) { [weak self] model, _ in
            self?.taskData = model
            self?.headerView.bind(model)
        } failed: { error in
            print("error: \(error)")
        }
    }
    
}

extension HomeViewController: JXPagingViewDelegate {
    static let kHomeSegHeaderHeight: CGFloat = 208.dbw + safeAreaTp
    
    func mainTableViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY >= Self.kHomeSegHeaderHeight - safeAreaTp {
            headerView.isHidden = true
            view.backgroundColor = .white
        } else {
            headerView.isHidden = false
            view.backgroundColor = .xf2
        }
    }
    
    func pagingView(_ pagingView: JXPagingView, initListAtIndex index: Int) -> any JXPagingViewListViewDelegate {
        let type = HomeListType(rawValue: index) ?? .all
        return HomeListViewController(type: type)
    }
    
    func tableHeaderViewHeight(in pagingView: JXPagingView) -> Int {
        return GlobalHelper.shared.inEndGid ? Int(120.dbw + safeAreaTp) : Int(Self.kHomeSegHeaderHeight)
    }
    
    func tableHeaderView(in pagingView: JXPagingView) -> UIView {
        return headerView
    }
    
    func heightForPinSectionHeader(in pagingView: JXPagingView) -> Int {
        return Int(65.dbw)
    }
    
    func viewForPinSectionHeader(in pagingView: JXPagingView) -> UIView {
        return segmentView
    }
    
    func numberOfLists(in pagingView: JXPagingView) -> Int {
        return titles.count
    }
}

extension HomeViewController: JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        FlyerLibHelper.log(index == 0 ? .allTasksListClick : .latestPublishListClick)
    }
}
