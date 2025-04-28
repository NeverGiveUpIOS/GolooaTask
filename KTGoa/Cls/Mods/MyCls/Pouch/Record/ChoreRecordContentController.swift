//
//  ChoreRecordContentController.swift
//  Golaa
//
//  Created by Cb on 2024/5/20.
//

import Foundation

class ChoreRecordContentController: BaseCollectionViewController {
    
    let scene: ChoreRecordScene
    lazy var dataList: [HomeListModel] = []
    
    init(scene: ChoreRecordScene) {
        self.scene = scene
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configViews()
        configActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadListData()
    }
    
    private func configViews() {
        view.backgroundColor = UIColor.xf2
        collectionView.backgroundColor = UIColor.xf2

        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configActions() {
        setMJ_header()
        setMJ_footer()
    }
    
    // MARK: - 父类方法
    
    override func registCell(_ collection: UICollectionView) {
        collection.register(ChoreRecordCell.self, forCellWithReuseIdentifier: "ChoreRecordCell")
        collection.dataSource = self
        collection.delegate = self
        collection.alwaysBounceVertical = true
    }
    
    private var dataSource: [PouchContentType] = PouchContentType.allCases
    
    override func loadListData() {
        super.loadListData()
        MineReq.choreRecord(self.scene, page: page, size: size, completion: { [weak self] list in
            guard let self = self else { return  }
            if self.page == 1 {
                self.dataList.removeAll()
            }
            self.dataList.appends(list)
            self.collectionView.reloadData()
            self.setupEmptyView(list.count)
            self.endRefreshAndReloadData(list.count, self.dataList.count)
        })
    }

}

extension ChoreRecordContentController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 10, left: 0, bottom: 15, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (screW - 15 * 2.0), height: 177)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChoreRecordCell", for: indexPath)
        if let cell = cell as? ChoreRecordCell {
            let model = dataList[indexPath.row]
            cell.configListModel(model)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = dataList[indexPath.row]
        RoutinStore.push(.choreDetail, param: model.id)
    }
}

extension ChoreRecordContentController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        view
    }
}
