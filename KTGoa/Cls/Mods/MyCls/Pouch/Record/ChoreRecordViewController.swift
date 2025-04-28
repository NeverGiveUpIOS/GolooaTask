//
//  ChoreRecordViewController.swift
//  Golaa
//
//  Created by Cb on 2024/5/20.
//

import Foundation

class ChoreRecordViewController: BasClasVC {
    
    private var defaultIndex = 0
    
    override func routerParam(param: Any?, router: RoutinRouter?) {
        if let scene = param as? ChoreRecordScene {
            defaultIndex = scene.index
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configViews()
        configActions()
        configData()
    }
    
    private func configViews() {
        navTitle("taskRecords".meLocalizable())
        navBagColor(.xf2)
        view.addSubview(segmentView)
        segmentView.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(naviH)
        }
        
        view.addSubview(listContainer)
        listContainer.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.top.equalTo(segmentView.snp.bottom)
        }
    }
    
    private func configActions() {
        segmentView.listContainer?.contentScrollView().panGestureRecognizer.require(toFail: navigationController!.interactivePopGestureRecognizer!)
    }
    
    private func configData() {
        dataSource.titles = list.map({ $0.title })
        segmentView.defaultSelectedIndex = defaultIndex
        segmentView.reloadData()
    }
    
    // MARK: - 属性
    
    private var list: [ChoreRecordScene] = ChoreRecordScene.allCases
    
    private lazy var listVCs = list.map({ $0.controller })

    private lazy var segmentView: JXSegmentedView = {
        let view = JXSegmentedView()
        view.dataSource = dataSource
        view.listContainer = listContainer
        view.backgroundColor = UIColor.xf2
        view.indicators = indicators
        return view
    }()
    
    private lazy var listContainer: JXSegmentedListContainerView = {
        let container = JXSegmentedListContainerView(dataSource: self)
        return container
    }()
    
    private lazy var dataSource: JXSegmentedTitleDataSource = {
        let dataSource = JXSegmentedTitleDataSource()
        dataSource.titleNormalFont = .systemFont(ofSize: 15)
        dataSource.titleSelectedFont = .boldSystemFont(ofSize: 15)
        dataSource.titleNormalColor = UIColor.hexStrToColor("#999999")
        dataSource.titleSelectedColor = UIColor.hexStrToColor("#000000")
        return dataSource
    }()
    
    private lazy var indicators: [JXSegmentedIndicatorLineView] = {
        let indicators = list.map({ _ -> JXSegmentedIndicatorLineView in
            let model = JXSegmentedIndicatorLineView()
            model.indicatorWidth = 12
            model.indicatorColor = UIColor.hexStrToColor("#000000")
            model.indicatorCornerRadius = 2
            return model
        })
        return indicators
    }()
        
}

extension ChoreRecordViewController: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        listVCs.count
    }
    
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        listVCs[index]
    }
}
