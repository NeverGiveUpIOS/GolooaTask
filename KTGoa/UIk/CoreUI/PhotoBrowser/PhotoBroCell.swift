//
//  PhotoBroCell.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/8/5.
//

import UIKit

class PhotoBroCell: UICollectionViewCell {
    
    var downImg: UIImage?
    var downImgUrl: String = ""

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var downLoadBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.image(.chatDownloadIcon)
        btn.gt.handleClick { [weak self] button in
            guard let self = self else {
                return
            }
            
            if self.downImgUrl.count > 0 {
                UIImage.savrImgUrl(url: self.downImgUrl)
            }
            
            if self.downImg != nil {
                self.downImg?.saveImgToAlbum()
            }
        }
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(downLoadBtn)
        imageView.frame = contentView.bounds
        downLoadBtn.snp.makeConstraints { make in
            make.trailing.equalTo(-20)
            make.bottom.equalTo(-80)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with image: String) {
        guard let _ = URL(string: image) else {
            imageView.image = UIImage(named: image)
            downImg = UIImage(named: image)
            return
        }
        downImgUrl = image
        imageView.normalImageUrl(image)
    }
    
    func configureImg(with image: UIImage) {
        imageView.image = image
        downImg = image
    }
}
