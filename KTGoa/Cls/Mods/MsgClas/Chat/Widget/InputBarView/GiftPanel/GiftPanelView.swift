//
//  GiftPanelView.swift
//  Golaa
//
//  Created by chenkaisong on 2024/5/23.
//

import UIKit

class GiftPanelView: UIView {
    
    var callSendGiftBlock: CallBackAnyBlock?
 
    /// 数据源
    var data: [GiftItemModel]? {
        didSet {
            if let data = data {
                
                collecView.reloadData()
                
                let tCount = flowLayout.row * flowLayout.column
                let pageNum =  ceil(Double(data.count) / Double(tCount))
                
                pageControl.numberOfPages = Int(pageNum)
                pageControl.currentPage = 0
                pageControl.isHidden = pageNum <= 1
                
                collecView.isScrollEnabled = pageNum > 1
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    lazy var flowLayout = GiftPanelItemLayout()
    
    private lazy var collecView: UICollectionView = {
        let collecView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collecView.bounces = false
        collecView.dataSource = self
        collecView.delegate = self
        collecView.isPagingEnabled = true
        collecView.backgroundColor = .clear
        collecView.showsHorizontalScrollIndicator = false
        collecView.register(GiftPanelItemCell.self, forCellWithReuseIdentifier: GiftPanelItemCell.className)
        return collecView
    }()
    
    private let pageControl = GiftItemIndexView()
    
}

private extension GiftPanelView {
    func setupUI() {
        addSubview(collecView)
        addSubview(pageControl)
        
        collecView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(-15)
        }
        
        pageControl.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(10)
        }
    }
}

// MARK: - UICollectionViewDataSource  UICollectionViewDelegate
extension GiftPanelView: UICollectionViewDataSource, UICollectionViewDelegate {
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GiftPanelItemCell.className, for: indexPath) as? GiftPanelItemCell
        let model = data?[indexPath.item]
        cell?.model = model
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let sModel = data?[indexPath.row] {
            callSendGiftBlock?(sModel)
            for (index, value) in (data ?? []).enumerated() {
                let tValue = value
                tValue.isSelected = index == indexPath.row
                data?[index] = tValue
            }
            self.collecView.reloadData()
        }
    }
    
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let num = (collecView.contentOffset.x / frame.width) + 0.5
         pageControl.currentPage = Int(num)
    }
}
