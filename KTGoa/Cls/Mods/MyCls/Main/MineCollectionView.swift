//
//  MineCollectionView.swift
//  Golaa
//
//  Created by Cb on 2024/5/13.
//

import Foundation

class MineCollectionView: UIView {
        
    var list: [MineCellLayoutable] = []
    
    var module: MineTableModule?
    
    func configModule(_ module: MineTableModule) {
        self.module = module
        configureItems(module.moduleList)
    }
    
    func configureItems(_ items: [MineCellLayoutable]) {
        list = items
        collectionView.reloadData()
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        configViews()
        configActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private func configViews() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configActions() {}
    
    // MARK: - 属性
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let lay = UICollectionViewFlowLayout()
        lay.scrollDirection = .vertical
        return lay
    }()
    
    private lazy var collectionView: UICollectionView = {
        let col =  UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        col.backgroundColor = .white
        col.register(MineCell.self, forCellWithReuseIdentifier: "MineCell")
        col.register(MineMinCell.self, forCellWithReuseIdentifier: "MineMinCell")
        col.register(MineTitleHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MineTitleHeader")
        col.delegate = self
        col.dataSource = self
        col.isScrollEnabled = false
        return col
    }()
}

extension MineCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: screW, height: MineLayout.headerHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let row = list[indexPath.row]
        let width = row.itemWidth(indexPath: indexPath)
        let height = row.itemHeight(row: indexPath.row)
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        list[indexPath.row].push()
    }
}

extension MineCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MineCell", for: indexPath)
        if module == .common || module == .agent {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MineMinCell", for: indexPath)
        }
        if let cell = cell as? MineCell {
            let row = list[indexPath.row]
            cell.titleLabel.text = row.title
            cell.icon.image = UIImage(named: row.icon)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MineTitleHeader", for: indexPath)
            if let view = view as? MineTitleHeader {
                view.titleLabel.text = module?.title ?? ""
            }
            return view
        }
        return UICollectionReusableView()
    }
}
