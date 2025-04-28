//
//  BaseCollectionViewController.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/8/8.
//

import UIKit

class BaseCollectionViewController: BasClasVC {
    
    var page = 1
    var size = 20
    
    var emptyView: BasEmptyView?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func getFlowLayout() -> UICollectionViewFlowLayout {
        UICollectionViewFlowLayout()
    }
    
    func registCell(_ collection: UICollectionView) {
        
    }

    lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: self.getFlowLayout())
        collection.backgroundColor = .clear
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        // 修改指示器的缩进 - 强行解包是为了拿到一个必有的 inset
        if #available(iOS 11.0, *) {
            collection.contentInsetAdjustmentBehavior = .never
        }
        registCell(collection)
        return collection
    }()
    
    func needAddDefaultEmptyData() -> Bool { true }
    
    func setupEmptyView(_ count: NSInteger, img: UIImage = .dataEmpty, text: String = "dataEmpty".globalLocalizable()) {
        
        collectionView.footer?.isHidden = (count < size && page == 1)
        
        if count > 0 {
            emptyView?.removeFromSuperview()
            return
        }
        DispatchQueue.main.async {
            self.emptyView?.removeFromSuperview()
            self.emptyView = BasEmptyView()
            self.collectionView.addSubview(self.emptyView!)
            self.emptyView?.setupEmptyImg(img, text)
            self.emptyView?.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.width.lessThanOrEqualTo(screW)
                make.height.lessThanOrEqualTo(screH - 200)
            }
        }
    }
}

extension BaseCollectionViewController {
    
    /// 添加下拉刷新
    func setMJ_header() {
        collectionView.header = JRefreshStateHeader.headerWithRefreshingBlock({[weak self] in
            guard let `self` = self else {return}
            self.loadNewData()
        })
    }
    
    /// 添加上拉刷新
    func setMJ_footer() {
        collectionView.footer = GTRefreshAutoNormalFooter.footerWithRefreshingBlock({[weak self] in
            guard let `self` = self else {return}
            self.page += 1
            self.loadMoreData()
        })
    }
    
    /// 下拉加载新数据
    @objc  func loadNewData() {
        page = 1
        collectionView.header?.endRefreshing()
        loadListData()
    }
    
    /// 上啦加载更多数据
    @objc  func loadMoreData() {
        page += 1
        collectionView.footer?.endRefreshing()
        loadListData()
    }
    
    @objc func loadListData() {
       
    }
    
    func endRefresh() {
        collectionView.header?.endRefreshing()
        collectionView.footer?.endRefreshing()
    }
    
    func endRefreshingWithNoMoreData() {
        collectionView.footer?.endRefreshingWithNoMoreData()
    }
    
    /// 结束上下拉刷新
    /// count：请求回来的数据模型数组count,
    /// totals: 页面的总数据数组 用于没有数据时隐藏mj_footer
    func endRefreshAndReloadData(_ count: Int, _ totals: Int) {
        endRefresh()
        if count == 0 {
            collectionView.footer?.endRefreshingWithNoMoreData()
            collectionView.footer?.isHidden = false
        }
        if totals == 0 {
            collectionView.footer?.isHidden = true
        } else {
            collectionView.footer?.isHidden = false
        }
        collectionView.reloadData()
    }
}

