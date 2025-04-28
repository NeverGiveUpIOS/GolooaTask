//
//  PouchEmptyFooter.swift
//  Golaa
//
//  Created by Cb on 2024/5/23.
//

import Foundation

class PouchEmptyFooter: UICollectionReusableView {
    
    static let contenHeight = 272.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configViews()
        configActions()
        configData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configViews() {
        addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
        }
        
        bgView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalTo(50)
            make.centerX.equalToSuperview()
        }

        bgView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(imageView.snp.bottom).offset(9)
        }
    }
    
    private func configActions() {
        
    }
    
    private func configData() {
        titleLabel.text = "noDataAvailable".meLocalizable()
        layer.cornerRadius = 10
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        layer.masksToBounds = true

    }
    
    // MARK: - 属性
    private let bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.gt.setCornerRadius(12)
        return view
    }()
    
    private let imageView: UIImageView = {
        let img = UIImageView(image: UIImage(named: "mine_pouch_empty"))
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    private let titleLabel: UILabel = {
        let lab = UILabel()
        lab.textAlignment = .center
        lab.textColor = UIColor.hexStrToColor("#999999")
        lab.font = .systemFont(ofSize: 12)
        lab.numberOfLines = 0
        return lab
    }()
}
