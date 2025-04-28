//
//  UploadPicturesView.swift
//  Golaa
//
//  Created by duke on 2024/5/29.
//

import UIKit

class UploadPicturesView: UIView {
    
    var maxCount: Int = 5
    var itemSpace: CGFloat = 15.0
    var cols = 3
    var margin: CGFloat = 15.0
    
    var addItemsBlock: (([UploadPicturesModel]) -> Void)?
    var removeItemBlock: ((UploadPicturesModel) -> Void)?
    
    var selectedItems: [UploadPicturesModel] {
        dataArray.filter({ $0.type != .add })
    }
    
    var itemSize: CGFloat {
        (screW - 2*margin - CGFloat(cols - 1) * itemSpace)/CGFloat(cols)
    }
    
    private(set) var itemH: CGFloat = 0
    private var dataArray: [UploadPicturesModel] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildUI()
        loadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildUI() {
        itemH = itemSize
        
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(margin)
            make.trailing.equalTo(-margin)
            make.width.equalTo(screW - 2*margin)
            make.height.equalTo(itemH)
        }
        
        PictureTl.shared.callImgBlock = { [weak self] img in
            guard let self = self else { return }
            
            let addM = UploadPicturesModel(type: .image, image: img)
            self.dataArray.insert(addM, at: 0)
            
            if dataArray.count > self.maxCount {
                dataArray.removeLast()
            }
            let items = self.dataArray.map({ UploadPicturesModel(image: $0.image) })
            self.refreshLayout()
            self.addItemsBlock?(items)
            self.collectionView.reloadData()
            self.refreshLayout()
        }
        
    }
    
    private func loadData() {
        let add = UploadPicturesModel(type: .add)
        dataArray.append(add)
        self.refreshLayout()
        collectionView.reloadData()
    }
    
    private func refreshLayout() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let height = collectionView.collectionViewLayout.collectionViewContentSize.height
        self.itemH = height
        collectionView.snp.updateConstraints { make in
            make.height.equalTo(height)
        }
    }
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let lay = UICollectionViewFlowLayout()
        lay.minimumLineSpacing = itemSpace
        lay.minimumInteritemSpacing = itemSpace
        lay.itemSize = .init(width: itemSize, height: itemSize)
        return lay
    }()
    
    private lazy var collectionView: UICollectionView =  {
        let col = UICollectionView(frame: .zero, collectionViewLayout: layout)
        col.showsVerticalScrollIndicator = false
        col.showsHorizontalScrollIndicator = false
        col.gt.register(cellClass: UploadPicturesCell.self)
        col.delegate = self
        col.dataSource = self
        return col
    }()
}


extension UploadPicturesView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.gt.dequeueReusableCell(cellType: UploadPicturesCell.self, cellForRowAt: indexPath)
        if dataArray.count > 0 {
            cell.bind(model: dataArray[indexPath.row])
        }
        cell.removeBlock = { [weak self] in
            guard let self = self else { return }
            self.removeItemBlock?(self.dataArray[indexPath.row])
            self.dataArray.remove(at: indexPath.row)
            if dataArray.first(where: { $0.type == .add }) == nil {
                let add = UploadPicturesModel(type: .add)
                dataArray.append(add)
            }
            self.collectionView.reloadData()
            self.refreshLayout()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.dataArray[indexPath.row]
        if item.type == .add {
            PictureTl.shared.showAlertPic()
        } else { // 查看照片
            let imageArray = self.dataArray.filter({ $0.type != .add })
            let imgs = imageArray.map({$0.image ?? UIImage()})
            if imgs.count > 0 {
                PhotoBroView.showWithImages(nil, images: imgs)
            }
        }
    }
    
}
enum UploadPicturesType {
    case add
    case image
}

class UploadPicturesModel: NSObject {
    var type: UploadPicturesType = .image
    var image: UIImage?
    var url: String?
    
    init(type: UploadPicturesType = .image, image: UIImage? = nil, url: String? = nil) {
        self.type = type
        self.image = image
        self.url = url
    }
}

class UploadPicturesCell: UICollectionViewCell {
    var removeBlock: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildUI() {
        contentView.addSubview(imageView)
        contentView.addSubview(removeBtn)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        removeBtn.snp.makeConstraints { make in
            make.trailing.equalTo(-6)
            make.top.equalTo(6)
            make.width.height.equalTo(17)
        }
    }
    
    var model: UploadPicturesModel?
    func bind(model: UploadPicturesModel) {
        switch model.type {
        case .add:
            removeBtn.isHidden = true
            imageView.image = .updateImgAdd
        case .image:
            removeBtn.isHidden = (model.image == nil && model.url == nil && !(model.url ?? "").isEmpty)
            imageView.image = nil
            if let image = model.image {
                imageView.image = image
            } else if let url = model.url {
                imageView.normalImageUrl(url)
            }
        }
    }
    
    @objc private func clickRemoveBtn(sender: UIButton) {
        removeBlock?()
    }
    
    private lazy var imageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.gt.setCornerRadius(10)
        return img
    }()
    
    private lazy var removeBtn: UIButton =  {
        let btn = UIButton(type: .custom)
        btn.image(.imageClear)
        btn.isHidden = true
        btn.addTarget(self, action: #selector(clickRemoveBtn), for: .touchUpInside)
        return btn
    }()
}
