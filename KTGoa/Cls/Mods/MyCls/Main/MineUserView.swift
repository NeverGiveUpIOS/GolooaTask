//
//  MineUserView.swift
//  Golaa
//
//  Created by Cb on 2024/5/14.
//

import UIKit

class MineUserView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configViews()
        configActions()
        updataUsr()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configViews() {
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
            make.width.height.equalTo(MineLayout.userAvatar)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(10)
            make.trailing.equalTo(-52)
            make.bottom.equalTo(imageView.snp.centerY)
        }
        
        addSubview(detailLabel)
        detailLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.leading)
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
        }
        
        addSubview(rightBtn)
        rightBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(36)
        }
    }
    
    private func configActions() {
        rightBtn.gt.handleClick { _ in
            RoutinStore.push(.individualInfo)
        }
    }
    
    // MARK: - 属性
    private let imageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.gt.setCornerRadius(MineLayout.userAvatar/2.0)
        img.backgroundColor = .lightGray
        return img
    }()
    
    private let titleLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = .white
        lab.font = .boldSystemFont(ofSize: 18)
        lab.text = ""
        return lab
    }()
    
    private let detailLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = .hexStrToColor("#999999")
        lab.font = .systemFont(ofSize: 13)
        lab.text = ""
        return lab
    }()
    
    private let rightBtn: UIButton = {
        let btn =  UIButton(type: .custom)
        btn.setImage(UIImage(named: "mine_edit"), for: .normal)
        return btn
    }()
    
    func updataUsr() {
        let model = LoginTl.shared.userInfo
        titleLabel.text = model?.nickname
        detailLabel.text = "ID：\(model?.id ?? "")"
        imageView.headerImageUrl(model?.avatar ?? "")
    }

}
