//
//  DenyListCell.swift
//  Golaa
//
//  Created by Cb on 2024/5/17.
//

import Foundation

class DenyListCell: SettingBasicCell {
    
    override func configViews() {
        super.configViews()
        
        bgView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        bgView.addSubview(imgView)
        imgView.snp.makeConstraints { make in
            make.width.height.equalTo(52)
            make.centerY.equalToSuperview()
            make.leading.equalTo(15)
        }
        
        let width = ("remove".meLocalizable() as NSString).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 30), options: [.usesLineFragmentOrigin], attributes: [.font: UIFont.systemFont(ofSize: 12)], context: nil).size.width + 20
        rightBtn.snp.remakeConstraints { make in
            make.trailing.equalTo(-15)
            make.centerY.equalToSuperview()
            make.width.equalTo(width)
            make.height.equalTo(30)
        }
        
        titleLabel.numberOfLines = 0
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        titleLabel.snp.remakeConstraints { make in
            make.leading.equalTo(imgView.snp.trailing).offset(15)
            make.trailing.lessThanOrEqualTo(rightBtn.snp.leading).offset(-5)
            make.centerY.equalToSuperview()
        }
        
        rightBtn.gt.setCornerRadius(15)
        rightBtn.titleLabel?.font = .systemFont(ofSize: 12)
        rightBtn.setTitleColor(.white, for: .normal)
        rightBtn.setTitle("remove".meLocalizable(), for: .normal)
        rightBtn.setImage(nil, for: .normal)
        rightBtn.backgroundColor = UIColor.hexStrToColor("#F96464")
        rightBtn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        rightBtn.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    func configItem(_ item: DenyListModel) {
        self.item = item
        titleLabel.text = item.user.name
        imgView.normalImageUrl(item.user.avatar)
        
        rightBtn.gt.handleClick { [weak self] _ in
            self?.onRemoveClosure?()
        }
    }
    
    // MARK: - 属性
    private var item: DenyListModel?
    
    var onRemoveClosure: (() -> Void)?
    
    private let imgView: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = .lightGray
        img.gt.setCornerRadius(26)
        return img
    }()
}
