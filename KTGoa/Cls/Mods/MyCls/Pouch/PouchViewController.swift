//
//  PouchViewController.swift
//  Golaa
//
//  Created by Cb on 2024/5/20.
//

import Foundation

class PouchViewController: BaseCollectionViewController {
    
    lazy var dataList = [PouchContentModel]()
    lazy var model = HomeBalanceModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configViews()
        configActions()
    }
    
    private func configViews() {
        navTitle("myWallet".meLocalizable())
        navBagColor(.xf2)
        view.backgroundColor = UIColor.xf2
        collectionView.backgroundColor = UIColor.xf2

        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(naviH)
            make.leading.bottom.trailing.equalToSuperview()
        }
    }
    
    func getBalance() {
        NetAPI.HomeAPI.balance.reqToModelHandler(parameters: nil, model: HomeBalanceModel.self) { [weak self] model, _ in
            self?.dataList = PouchContentType.caseModel(model)
            self?.model = model
            self?.collectionView.reloadData()
        } failed: { error in

        }
    }
    
    private func configActions() {
        setMJ_header()
    }
    
    // MARK: - 父类方法

    override func registCell(_ collection: UICollectionView) {
        collection.register(PouchMixHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "PouchMixHeader")
        collection.register(PouchHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "PouchHeader")
        collection.register(PouchContentCell.self, forCellWithReuseIdentifier: "PouchContentCell")
        collection.dataSource = self
        collection.delegate = self
        collection.alwaysBounceVertical = true
    }

    override func needAddDefaultEmptyData() -> Bool { false }
        
    private var dataSource: [PouchContentType] = PouchContentType.allCases
        
}

extension PouchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: screW, height: PouchMixHeader.contentMixHeight)
        }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (screW - 15 * 3.0)/2.0
        return CGSize(width: width, height: 84)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "PouchMixHeader", for: indexPath)
            if let cell = cell as? PouchMixHeader {
                cell.configModel(self.model)
            }
            return cell
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.dataList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PouchContentCell", for: indexPath)
        if let cell = cell as? PouchContentCell {
            cell.configModel(dataList[indexPath.row])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = dataSource[indexPath.row]
        if row == .ensure {
            RoutinStore.push(.pouchEnsure)
        } else if row == .task {
            RoutinStore.push(.choreBenefit)
        } else if row == .coin {
            RoutinStore.push(.pouchCoin)
        } else if row == .agent {
            RoutinStore.push(.webScene(.agentProfit))
        }
    }
}
