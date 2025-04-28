//
//  SelectTaskViewController.swift
//  Golaa
//
//  Created by duke on 2024/5/22.
//

import UIKit
import JXSegmentedView

class SelectTaskViewController: BasClasVC {
    
    let titles = ["participate".homeLocalizable(), "publish".homeLocalizable()]
    let totalItemWidth: CGFloat = 250.0
    var tapSendBlock: ((SelectTaskListModel) -> Void)?
    
    override func routerParam(param: Any?, router: RoutinRouter?) {
        if let tapSendBlock = param as? ((SelectTaskListModel) -> Void) {
            self.tapSendBlock = tapSendBlock
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
    }
    
    private func buildUI() {
        
        navTitle("selectTask".homeLocalizable())
        view.backgroundColor = .white
        view.addSubview(segmentView)
        view.addSubview(listContainerView)
        
        segmentView.snp.makeConstraints { make in
            make.top.equalTo(naviH)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        listContainerView.snp.makeConstraints { make in
            make.top.equalTo(segmentView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(-safeAreaBt)
        }
    }
    
    private lazy var titleSource: JXSegmentedTitleDataSource = {
        let titleSource = JXSegmentedTitleDataSource()
        titleSource.titles = titles
        titleSource.titleNormalColor = .hexStrToColor("#999999")
        titleSource.titleSelectedColor = .black
        titleSource.titleNormalFont = UIFontReg(15)
        titleSource.titleSelectedFont = UIFontSemibold(15)
        titleSource.itemWidth = totalItemWidth/CGFloat(titles.count)
        return titleSource
    }()
    
    private lazy var indicator: JXSegmentedIndicatorLineView = {
        let idView = JXSegmentedIndicatorLineView()
        idView.indicatorColor = .black
        idView.indicatorHeight = 3
        idView.indicatorWidth = 12
        idView.verticalOffset = 6
        return idView
    }()
    
    private lazy var listContainerView = JXSegmentedListContainerView(dataSource: self)
    
    private lazy var segmentView: JXSegmentedView = {
        let view = JXSegmentedView()
        view.backgroundColor = .white
        view.dataSource = titleSource
        view.listContainer = listContainerView
        view.indicators = [indicator]
        return view
    }()
}

extension SelectTaskViewController: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        titles.count
    }
    
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> any JXSegmentedListContainerViewListDelegate {
        let type = SelectTaskListType(rawValue: index) ?? .my
        return SelectTaskListViewController(type: type, tapSendBlock: { [weak self] model in
            self?.tapSendBlock?(model)
            self?.navigationController?.popViewController(animated: true)
        })
    }
}
