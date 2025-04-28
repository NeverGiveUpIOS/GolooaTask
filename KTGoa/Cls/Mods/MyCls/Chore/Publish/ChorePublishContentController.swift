//
//  ChorePublishContentController.swift
//  Golaa
//
//  Created by Cb on 2024/5/21.
//

import Foundation

class ChorePublishContentController: BaseCollectionViewController {

    let scene: ChorePublishScene
    
    lazy var dataList: [HomeListModel] = []
    
    init(scene: ChorePublishScene) {
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
        collection.register(ChorePublishCell.self, forCellWithReuseIdentifier: "ChorePublishCell")
        collection.dataSource = self
        collection.delegate = self
        collection.alwaysBounceVertical = true
    }
    
    
    private var dataSource: [PouchContentType] = PouchContentType.allCases
    
    override func loadListData() {
        super.loadListData()
        
        MineReq.publishList(self.scene, page: page, size: size, completion: { [weak self] list in
            list.forEach { $0.configureContentSize() }
            guard let self = self else { return  }

            if self.page == 1 {
                self.dataList.removeAll()
            }
            self.dataList.appends(list)
            self.setupEmptyView(self.dataList.count)
            self.endRefreshAndReloadData(list.count, self.dataList.count)
        })
    }

}


extension ChorePublishContentController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
        dataList[indexPath.row].contentSize
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChorePublishCell", for: indexPath)
        if let cell = cell as? ChorePublishCell {
            let model = dataList[indexPath.row]
            cell.configModel(model)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = dataList[indexPath.row]
        RoutinStore.push(.chorePublishDetail, param: model.id)
    }
}

extension ChorePublishContentController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        view
    }
}
