//
//  PouchCoinViewController.swift
//  Golaa
//
//  Created by Cb on 2024/5/25.
//

import Foundation

class PouchCoinViewController: BaseCollectionViewController {
    
   lazy var list = [PouchDetailModel]()
    lazy var accountModel = HomeBalanceAccount()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configViews()
        configActions()
        tradeLogDetail()
    }
    
    private func configViews() {
        navTitle(PouchContentType.coin.rawValue)
        navBagColor(.xf2)
        view.backgroundColor = UIColor.xf2
        collectionView.backgroundColor = UIColor.xf2

        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(naviH)
            make.leading.bottom.trailing.equalToSuperview()
        }
    }
    
    private func configActions() {
        setMJ_header()
        setMJ_footer()
    }
    
    override func loadListData() {
        super.loadListData()
        tradeLogDetail()
    }
    // MARK: - 父类方法

    override func registCell(_ collection: UICollectionView) {
        collection.register(PouchEmptyFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "PouchEmptyFooter")
        collection.register(PouchCoinHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "PouchCoinHeader")
        collection.register(PouchEnsureCell.self, forCellWithReuseIdentifier: "PouchEnsureCell")
        collection.dataSource = self
        collection.delegate = self
        collection.alwaysBounceVertical = true
    }
    
    override func needAddDefaultEmptyData() -> Bool { false }
    
    private var dataSource: [PouchContentType] = PouchContentType.allCases // [.task]

}

extension PouchCoinViewController {
    
    func tradeLogDetail() {
        
        MineReq.tradeLogDetail(.coin, page: page, size: size) { list, model, isSuccess, errorMsg in
            if isSuccess {
                if self.page > 1 {
                    self.list += list
                } else {
                    self.list = list
                    self.accountModel = model ?? HomeBalanceAccount()
                }
                self.configureHeight()
                self.setupEmptyView(self.list.count)
                self.endRefreshAndReloadData(list.count, self.list.count)
            } else {
                self.setupEmptyView(0)
                self.endRefreshAndReloadData(0, 0)
            }
        }
        
    }
    
    // 手动计算高度Cell高度
    private func configureHeight() {
        list.forEach { $0.configureContentSize() }
    }
}

extension PouchCoinViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: screW, height: PouchHeader.coinContentHeight)
        }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 0 && list.count == 0 {
            return CGSize(width: screW, height: PouchEmptyFooter.contenHeight)
        }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       list[indexPath.row].getDisplayContentSize(row: indexPath.row, total: list.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "PouchCoinHeader", for: indexPath)
            if let cell = cell as? PouchCoinHeader {
                cell.configureSubItem(accountModel)
            }
            return cell
        } else if kind == UICollectionView.elementKindSectionFooter && list.count == 0 {
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "PouchEmptyFooter", for: indexPath)
            return cell
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PouchEnsureCell", for: indexPath)
        if let cell = cell as? PouchEnsureCell {
            let style: CellRoundStyle = list.count == 1 ? .all : (indexPath.row == 0 ? .top : (indexPath.row == list.count - 1 ? .bottom : .noRound))
            let model = list[indexPath.row]
            cell.configModel(model, roundStyle: style)
        }
        return cell
    }
}
