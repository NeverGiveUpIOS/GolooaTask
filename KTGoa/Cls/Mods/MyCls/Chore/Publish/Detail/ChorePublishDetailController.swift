//
//  ChorePublishDetailController.swift
//  Golaa
//
//  Created by Cb on 2024/5/24.
//

import Foundation

class ChorePublishDetailController: BaseCollectionViewController {
    
    private var choreId = 0
    
    lazy var list = [ChorePublishDetailModel]()
    lazy var model = HomeListModel()
    
    override func routerParam(param: Any?, router: RoutinRouter?) {
        if let choreId = param as? Int {
            self.choreId = choreId
        } else if let choreId = param as? String, let choreId = Int(choreId) {
            self.choreId = choreId
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configViews()
        configActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        publishDetail()
    }
    
    private func configViews() {
        navTitle("taskDataDetails".meLocalizable())
        //        setRightItem(imgs: "mine_top_appeal")
        navBagColor(.xf2)
        
        view.backgroundColor = UIColor.xf2
        collectionView.backgroundColor = UIColor.xf2
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(naviH)
            make.bottom.equalToSuperview()
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
        }
    }
    
    override func rightItemClick() {
        super.rightItemClick()
        
        if let model = list.filter({ $0.scene == .needCheck}).last {
            RoutinStore.push(.chorePublishAppeal, param: ["date": model.settleDateDesc, "taskId": choreId])
        }
        
    }
    
    
    private func configActions() {
        setMJ_header()
        setMJ_footer()
    }
    
    override func loadListData() {
        super.loadListData()
        publishDetail()
    }
    
    override func registCell(_ collection: UICollectionView) {
        collection.register(ChoreDetailEmptyFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "ChoreDetailEmptyFooter")
        collection.register(ChoreDetailHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ChoreDetailHeader")
        collection.register(ChorePublishHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ChorePublishHeaderCell")
        collection.register(ChoreDetailCell.self, forCellWithReuseIdentifier: "ChoreDetailCell")
        collection.dataSource = self
        collection.delegate = self
        collection.alwaysBounceVertical = true
    }
    
    override func needAddDefaultEmptyData() -> Bool { false }
    
    private var dataSource: [PouchContentType] = [.task]
    
}

extension ChorePublishDetailController {
    
    private func publishDetail() {
        
        MineReq.publishDetail(self.choreId, page: page, size: size, completion: { [weak self] list, model in
            guard let self = self else { return  }
            model?.configureContentSize(true)
            self.list = list
            self.model = model ?? HomeListModel()
            self.setupEmptyView(self.list.count)
            self.endRefreshAndReloadData(list.count, self.list.count)
            if list.filter({ $0.scene == .needCheck}).count > 0 {
                self.rightItem(.mineTopAppeal)
            }
        })
        
    }
    
    private func publishSettle(date: String) {
        MineReq.publishSettle(self.model.id, date: date, completion: { [weak self] isSuccess, message in
            if isSuccess {
                self?.publishDetail()
            }
            if !isSuccess, let msg = message {
                MakeupDepositAlert.show(taskId: self?.model.id ?? 0, date: date, content: msg)
            }
        })
    }
    
}

extension ChorePublishDetailController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 0, left: 0, bottom: 18, right: 0)
        }
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return model.contentSize
        }
        return CGSize(width: screW - 30, height: 46 + 58)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 1  && list.count == 0 {
            return CGSize(width: screW - 30, height: 230)
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
        CGSize(width: (screW - 15 * 2.0), height: 46)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            if indexPath.section == 0 {
                let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ChorePublishHeaderCell", for: indexPath)
                if let cell = cell as? ChorePublishHeaderCell {
                    cell.configModel(model)
                }
                return cell
            }
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ChoreDetailHeader", for: indexPath)
            if let cell = cell as? ChoreDetailHeader {
                cell.configListModel(model, type: .publishTitle)
            }
            return cell
        } else if kind == UICollectionView.elementKindSectionFooter {
            if indexPath.section == 1 && list.count == 0 {
                let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ChoreDetailEmptyFooter", for: indexPath)
                return cell
            }
        }
        return UICollectionReusableView()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 1 {
            return list.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChoreDetailCell", for: indexPath)
        if let cell = cell as? ChoreDetailCell {
            let style: CellRoundStyle = (list.count == 1 ? .bottom : (indexPath.row == list.count - 1 ? .bottom : .noRound))
            let model = list[indexPath.row]
            cell.didSelectClosure = { [weak self] _ in
                self?.cellDidSelect(model)
            }
            cell.configPublishModel(model, roundStyle: style)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}
    
    private func cellDidSelect(_ model: ChorePublishDetailModel) {
        //        let listModel = publishDetailReactor.currentState.model
        if model.scene == .needCheck {
            AlertPopView.show(titles: "tip".globalLocalizable(), contents: "afterTheDataIsVerifiedThe".meLocalizable(), sures: "verificationCompleted".meLocalizable(), completion: { [weak self] in
                guard let self = self else { return }
                self.publishSettle(date: model.settleDateDesc)
            })
        }
    }
}
