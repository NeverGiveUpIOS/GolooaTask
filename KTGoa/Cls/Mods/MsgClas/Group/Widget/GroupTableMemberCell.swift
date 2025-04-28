//
//  GroupTableMemberCell.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/8/3.
//

import UIKit

class GroupTableMemberCell: GroupTableBaseCell {
    
    var groupId = ""
    
    var members: [GroupMemberModel]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    
    override func setupCoder() {
        super.setupCoder()
        addSubview(memberNext)
        addSubview(collectionView)
        
        memberNext.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.right.equalTo(-15)
            make.centerY.equalTo(titleLabel)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.bottom.trailing.equalToSuperview()
        }
    }
    

    lazy var memberNext: UIButton = {
        let btn = UIButton()
        btn.image(.groupMemberNext)
        return btn
    }()
    
    lazy var layout: UICollectionViewFlowLayout = {
        let lay = UICollectionViewFlowLayout()
        lay.minimumLineSpacing = 20
        lay.minimumInteritemSpacing = 20
        lay.itemSize = CGSize(width: 52, height: 75)
        return lay
    }()
    
    lazy var collectionView: UICollectionView = {
        let col = UICollectionView(frame: .zero, collectionViewLayout: layout)
        col.backgroundColor = .clear
        col.showsVerticalScrollIndicator = false
        col.showsHorizontalScrollIndicator = false
        col.delegate = self
        col.dataSource = self
        col.gt.register(cellClass: GroupMemberInfoCell.self)
        return col
    }()
}

extension GroupTableMemberCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return members?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.gt.dequeueReusableCell(cellType: GroupMemberInfoCell.self, cellForRowAt: indexPath)
        
        if let model = members?[indexPath.row] {
            cell.bind(model: model)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let model = members?[indexPath.row] {
            if model.isAdd {
                RoutinStore.push(.groupAdd, param: groupId)
            } else {
                RoutinStore.push(.groupMember, param: groupId)
            }       
        }
    }
    
}
