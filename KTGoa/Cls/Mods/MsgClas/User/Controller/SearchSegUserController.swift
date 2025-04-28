//
//  SearchSegUserController.swift
//  Golaa
//
//  Created by chenkaisong on 2024/5/22.
//

import UIKit

class SearchSegUserController: BasClasVC {
    
    let titles = ["user".msgLocalizable(), "groupChat".msgLocalizable()]
    var curIndex = 0
    var searctText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rightItem(.msgSearchBlack)
        
        buildUI()
        bind()
        segmentView.listContainer?.contentScrollView().panGestureRecognizer.require(toFail: navigationController!.interactivePopGestureRecognizer!)
    }
    
    override func rightItemClick() {
        searchView.endEditTextField()
        if searctText.count > 0 {
            searchReq(searctText)
        }
    }

    private func buildUI() {
        
        view.addSubview(segmentView)
        view.addSubview(listContainerView)
        basNavbView?.addSubview(searchView)
        segmentView.snp.makeConstraints { make in
            make.top.equalTo(naviH)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        listContainerView.snp.makeConstraints { make in
            make.top.equalTo(segmentView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(0)
        }
        
        searchView.snp.makeConstraints { make in
            make.bottom.equalTo(-3)
            make.leading.equalTo(60)
            make.trailing.equalTo(-60)
        }

    }
    
    private lazy var titleSource: JXSegmentedTitleDataSource = {
        let titleSource = JXSegmentedTitleDataSource()
        titleSource.titles = titles
        titleSource.titleNormalColor = UIColorHex("#999999")
        titleSource.titleSelectedColor = .black
        titleSource.titleNormalFont = UIFontReg(15)
        titleSource.titleSelectedFont = UIFontSemibold(15)
        return titleSource
    }()
    
    private lazy var indicator: JXSegmentedIndicatorLineView = {
        let indv = JXSegmentedIndicatorLineView()
        indv.indicatorColor = .black
        indv.indicatorHeight = 3
        indv.indicatorWidth = 12
        indv.verticalOffset = 6
        indv.gt.setCornerRadius(1)
        return indv
    }()
    
    private lazy var listContainerView = JXSegmentedListContainerView(dataSource: self)
    
    private lazy var segmentView: JXSegmentedView = {
        let segView = JXSegmentedView()
        segView.backgroundColor = .clear
        segView.dataSource = titleSource
        segView.listContainer = listContainerView
        segView.indicators = [indicator]
        segView.delegate = self
        return segView
    }()
    
    private lazy var searchView: MsgAddFriendSearchView = {
        let view = MsgAddFriendSearchView()
        view.setupPlacehold("searchUserG".msgLocalizable())
        view.textField.gt.setCornerRadius(17)
        view.setupClearImage(nil)
        return view
    }()
    
    private func searchReq(_ text: String) {
        searctText = text
        segmentView.reloadData()
    }
}

extension SearchSegUserController {
    
    private func bind() {
        searchView.callBlock = { [weak self] text, isClear in
            self?.searchReq(text)
        }
    }
    
}

extension SearchSegUserController: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        titles.count
    }
    
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> any JXSegmentedListContainerViewListDelegate {
        let vc = AddFriendViewController()
        vc.type = index == 0 ? .singleChat : .groupChat
        if index == curIndex {
            vc.searchReq(searctText)
        }
        return vc
    }
}

extension SearchSegUserController: JXSegmentedViewDelegate {
    
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        curIndex = index
    }
}
