//
//  ChoreDetailViewController.swift
//  Golaa
//
//  Created by Cb on 2024/5/20.
//

import Foundation

class ChoreDetailViewController: BaseCollectionViewController {
    
    private var choreId = 0
    
    lazy var dataList: [ChoreRecordModel] = []
    lazy var model = HomeListModel()

    
    override func routerParam(param: Any?, router: RoutinRouter?) {
        if let choreId = param as? Int {
            self.choreId = choreId
        } else if let choreId = param as? String {
            self.choreId = Int(choreId) ?? 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configViews()
        configActions()
        navBagColor(.xf2)

        myChoreDetail()
    }
    
    private func configViews() {
        navTitle("taskDataDetails".meLocalizable())
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
    
    private func configActions() {
        setMJ_header()
    }

    // MARK: - 父类方法

    override func registCell(_ collection: UICollectionView) {
        collection.register(ChoreDetailEmptyFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "ChoreDetailEmptyFooter")
        collection.register(ChoreDetailHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ChoreDetailHeader")
        collection.register(ChoreRecordCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ChoreRecordCell")
        collection.register(ChoreDetailCell.self, forCellWithReuseIdentifier: "ChoreDetailCell")
        collection.dataSource = self
        collection.delegate = self
        collection.alwaysBounceVertical = true
    }
    
    override func needAddDefaultEmptyData() -> Bool { false }
    
    // MARK: - 属性        
    private var dataSource: [PouchContentType] = [.task]

    private func myChoreDetail() {
        MineReq.myChoreDetail(self.choreId, page: page, size: size, completion: { [weak self] list, model in
            self?.dataList = list
            self?.model = model ?? HomeListModel()
            self?.collectionView.reloadData()
        })
    }
    
    override func loadNewData() {
        super.loadNewData()
        myChoreDetail()
    }
}

extension ChoreDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 0, left: 0, bottom: 18, right: 0)
        }
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: screW - 30, height: 177)
        }
        return CGSize(width: screW - 30, height: 46 + 58)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 1  && dataList.count == 0 {
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
                let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ChoreRecordCell", for: indexPath)
                if let cell = cell as? ChoreRecordCell {
                    cell.configListModel(model)
                }
                return cell
            }
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ChoreDetailHeader", for: indexPath)
            if let cell = cell as? ChoreDetailHeader {
                cell.configListModel(model, type: .recordTitle)
            }
            return cell
        } else if kind == UICollectionView.elementKindSectionFooter {
            if indexPath.section == 1 && dataList.count == 0 {
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
            return dataList.count
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChoreDetailCell", for: indexPath)
        if let cell = cell as? ChoreDetailCell {
            let style: CellRoundStyle = (dataList.count == 1 ? .bottom : (indexPath.row == dataList.count - 1 ? .bottom : .noRound))
            let model = dataList[indexPath.row]
            cell.configRecordModel(model, roundStyle: style)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}
}
