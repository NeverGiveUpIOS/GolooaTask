//
//  PhotoBroVc.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/8/5.
//

import UIKit

class PhotoBroView: AlertBaseView {
    
    private let collectionView: UICollectionView
    private let images: [UIImage]
    private let imageStrs: [String]
    
    static func showWithImages(_ imageStrs: [String]?, images: [UIImage]?, curIndex: Int = 0) {
        let view = PhotoBroView(frame: ScreB, images: images, imageStrs: imageStrs, curIndex: curIndex)
        view.show()
    }
    
    init(frame: CGRect, images: [UIImage]?, imageStrs: [String]?, curIndex: NSInteger = 0) {
        
        self.images = images ?? []
        self.imageStrs = imageStrs ?? []
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        layout.minimumLineSpacing = 0
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        super.init(frame: frame)
        

        collectionView.gt.register(cellClass: PhotoBroCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .black
        
        addSubview(collectionView)
        
        debugPrint("滚动到的位置:\(curIndex)")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { [weak self] in
            self?.collectionView.scrollToItem(at: IndexPath(row: curIndex, section: 0), at: .centeredHorizontally, animated: false)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return .init(width: screW, height: screH)
    }
}

extension PhotoBroView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count > 0 ? images.count : imageStrs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.gt.dequeueReusableCell(cellType: PhotoBroCell.self, cellForRowAt: indexPath)
        if images.count > 0 {
            let image = images[indexPath.item]
            cell.configureImg(with: image)
        }
        if imageStrs.count > 0 {
            let image = imageStrs[indexPath.item]
            cell.configure(with: image)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.popupView()?.dismiss(animated: true)
    }
}
