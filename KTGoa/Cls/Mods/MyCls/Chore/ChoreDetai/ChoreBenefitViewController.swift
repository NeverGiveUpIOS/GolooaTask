//
//  ChoreBenefitViewController.swift
//  Golaa
//
//  Created by Cb on 2024/5/21.
//

import Foundation

class ChoreBenefitViewController: BaseCollectionViewController {
    
    lazy var dataList: [PouchDetailModel] = []
    lazy var accountModel = HomeBalanceAccount()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configViews()
        configActions()
        mutationLoadDataResult()
    }
    
    private func configViews() {
        navTitle("taskEarnings".meLocalizable())
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
    
    // MARK: - 父类方法

    override func registCell(_ collection: UICollectionView) {
        collection.register(PouchEmptyFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "PouchEmptyFooter")
        collection.register(ChoreBenefitHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ChoreBenefitHeader")
        collection.register(PouchEnsureCell.self, forCellWithReuseIdentifier: "PouchEnsureCell")
        collection.dataSource = self
        collection.delegate = self
        collection.alwaysBounceVertical = true
    }
    
    override func needAddDefaultEmptyData() -> Bool { false }
    
    private var dataSource: [PouchContentType] = PouchContentType.allCases
    
    override func loadListData() {
        super.loadListData()
        mutationLoadDataResult()
    }
    
    private func mutationLoadDataResult() {
        
        MineReq.tradeLogDetail(.chore, page: page, size: size) { [weak self]  list, model, isSuccess, errorMsg in
            if isSuccess {
                list.forEach { $0.configureContentSize() }
                self?.dataList = list
                self?.accountModel = model ?? HomeBalanceAccount()
                self?.collectionView.reloadData()
                self?.setupEmptyView(list.count)
            } else {
                self?.setupEmptyView(0)
            }
        }
    }
}

//extension ChoreBenefitViewController: View {
//    func bind(reactor: ChoreBenefitReactor) {
//        Observable.combineLatest(reactor.state.map({ $0.list }), reactor.state.map({ $0.accountModel })).subscribe(onNext: { [weak self] _, _ in
//            self?.collectionView.reloadData()
//        }).disposed(by: disposeBag)
//                
//        refreshPublish.asObservable().map({ [weak self] in
//            guard let self = self else {
//                return ChoreBenefitReactor.Action.loadData(1, 20)
//            }
//            return ChoreBenefitReactor.Action.loadData(self.page, self.size)
//        }).bind(to: reactor.action).disposed(by: disposeBag)
//
//        reactor.state.map({ $0.noMore }).subscribe(onNext: { [weak self] noMore in
//            guard let self = self else { return }
//            if noMore {
//                self.endRefreshingWithNoMoreData()
//            } else {
//                self.collectionView.mj_footer?.resetNoMoreData()
//            }
//        }).disposed(by: disposeBag)
//
//        refreshPublish.onNext(())
//    }
//}

extension ChoreBenefitViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: screW, height: PouchHeader.choreContentHeight)
        }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 0 && dataList.count == 0 {
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
        let width = (screW - 15 * 2.0)
        if dataList.count == 1 {
            return CGSize(width: width, height: 83)
        } else if indexPath.row == 0 {
            return CGSize(width: width, height: 73)
        } else if indexPath.row == dataList.count - 1 {
            return CGSize(width: width, height: 73)
        }
        return CGSize(width: width, height: 63)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ChoreBenefitHeader", for: indexPath)
            if let cell = cell as? ChoreBenefitHeader {
                cell.configureSubItem(accountModel)
            }
            return cell
        } else if kind == UICollectionView.elementKindSectionFooter && dataList.count == 0 {
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "PouchEmptyFooter", for: indexPath)
            return cell
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PouchEnsureCell", for: indexPath)
        if let cell = cell as? PouchEnsureCell {
            let style: CellRoundStyle = dataList.count == 1 ? .all : (indexPath.row == 0 ? .top : (indexPath.row == dataList.count - 1 ? .bottom : .noRound))
            let model = dataList[indexPath.row]
            cell.configModel(model, roundStyle: style)

        }
        return cell
    }
}
