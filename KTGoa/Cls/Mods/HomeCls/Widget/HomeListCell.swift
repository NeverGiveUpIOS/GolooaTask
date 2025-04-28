//
//  HomeListCell.swift
//  Golaa
//
//  Created by duke on 2024/5/14.
//

import UIKit

class HomeListCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildUI() {
        contentView.addSubview(iconView)
        iconView.addSubview(danbaoLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(progessView)
        progessView.addSubview(progressLabel)
        if GlobalHelper.shared.inEndGid {
            contentView.addSubview(tag2Label)
        } else {
            contentView.addSubview(tag1Label)
            contentView.addSubview(tag2Label)
            contentView.addSubview(valueLabel)
        }
        
        iconView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(15.dbw)
            make.width.height.equalTo(90.dbw)
        }
        
        danbaoLabel.snp.makeConstraints { make in
            make.bottom.equalTo(-8.dbw)
            make.trailing.equalTo(-6.dbw)
            make.height.equalTo(17.dbw)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(iconView.snp.top).offset(7.dbw)
            make.leading.equalTo(iconView.snp.trailing).offset(10.dbw)
            make.trailing.equalTo(-10.dbw)
        }
        
        if GlobalHelper.shared.inEndGid {
            tag2Label.snp.makeConstraints { make in
                make.top.equalTo(nameLabel.snp.bottom).offset(6.dbw)
                make.leading.equalTo(iconView.snp.trailing).offset(10.dbw)
                make.height.equalTo(19.dbw)
            }
            
            progessView.snp.makeConstraints { make in
                make.top.equalTo(tag2Label.snp.bottom).offset(14.dbw)
                make.leading.equalTo(iconView.snp.trailing).offset(10.dbw)
                make.width.equalTo(120.dbw)
                make.height.equalTo(15.dbw)
            }
            
        } else {
            tag1Label.snp.makeConstraints { make in
                make.top.equalTo(nameLabel.snp.bottom).offset(6.dbw)
                make.leading.equalTo(iconView.snp.trailing).offset(10.dbw)
                make.height.equalTo(19.dbw)
            }
            tag2Label.snp.makeConstraints { make in
                make.centerY.equalTo(tag1Label.snp.centerY)
                make.leading.equalTo(tag1Label.snp.trailing).offset(4.5.dbw)
                make.height.equalTo(19.dbw)
            }
            
            progessView.snp.makeConstraints { make in
                make.top.equalTo(tag1Label.snp.bottom).offset(14.dbw)
                make.leading.equalTo(iconView.snp.trailing).offset(10.dbw)
                make.width.equalTo(120.dbw)
                make.height.equalTo(15.dbw)
            }
            
            valueLabel.snp.makeConstraints { make in
                make.centerY.equalTo(progessView.snp.centerY)
                make.trailing.equalTo(-15.dbw)
                make.leading.greaterThanOrEqualTo(progessView.snp.trailing).offset(5.dbw)
            }
        }
        
        progressLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
    }
    
    var model: HomeListModel?
    func bind(_ model: HomeListModel) {
        self.model = model
        
        iconView.normalImageUrl(model.img)
        nameLabel.text = model.name
        tag1Label.text = "registrationTask".homeLocalizable()
        
        tag2Label.tipImg.image = .homeTag2Icon
        tag2Label.tagContent.text = "\(model.receNum)"
        
        progessView.progress = Float(CGFloat(model.receCount)/CGFloat(model.num))
        progressLabel.text = "\(model.receCount)/\(model.num)"
        
        danbaoLabel.tipImg.image = .homeRz
        danbaoLabel.tagContent.text = "\("secured".homeLocalizable())"
        
        valueLabel.text = model.picDes
        danbaoLabel.isHidden = !model.isDanbao
    }
    
    private lazy var iconView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.gt.setCornerRadius(6.dbw)
        return img
    }()
    
    private lazy var nameLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = .black
        lab.font = UIFontSemibold(14.dbw)
        return lab
    }()
    
    private lazy var tag1Label: GTPaddingLabel = {
        let lab = GTPaddingLabel()
        lab.textColor = .hexStrToColor("#666666")
        lab.font = UIFontSemibold(9.dbw)
        lab.backgroundColor = .hexStrToColor("#F1F2F8")
        lab.gt.setCornerRadius(4.dbw)
        lab.paddingLeft = 5.dbw
        lab.paddingTop = 3.dbw
        lab.paddingBottom = 3.dbw
        lab.paddingRight = 5.dbw
        return lab
    }()
    
    private lazy var tag2Label: HomeListCeltagView = {
        let lab = HomeListCeltagView()
        lab.backgroundColor = .hexStrToColor("#F1F2F8")
        lab.gt.setCornerRadius(4.dbw)
        lab.tipImg.image = .homeTag2Icon
        lab.tagContent.color(.hexStrToColor("#666666"))
        lab.tagContent.font(UIFontSemibold(9.dbw))
        lab.tagContent.text = "0"
        return lab
    }()
    
    private lazy var valueLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = .hexStrToColor("#FF5722")
        lab.font = .oswaldDemiBold(16.dbw)
        return lab
    }()
    
    private lazy var danbaoLabel: HomeListCeltagView = {
        let lab = HomeListCeltagView()
        lab.backgroundColor = .white
        lab.gt.setCornerRadius(3.dbw)
        lab.isHidden = true
        lab.tipImg.image = .homeRz
        lab.tagContent.color(.hexStrToColor("#B89829"))
        lab.tagContent.font(UIFontMedium(9.dbw))
        lab.tagContent.text = "\("secured".homeLocalizable())"
        return lab
    }()
    
    private lazy var progessView: UIProgressView = {
        let view = UIProgressView()
        view.trackTintColor = .hexStrToColor("#F1F2F8")
        view.progressTintColor = .hexStrToColor("#FFFADF")
        view.gt.setCornerRadius(7.5.dbw)
        return view
    }()
    
    private lazy var progressLabel: UILabel = {
        let lab = UILabel()
        lab.font = UIFontReg(11.dbw)
        lab.textColor = .black
        lab.textAlignment = .center
        return lab
    }()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        
    }
    
}


class HomeListCeltagView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(tipImg)
        addSubview(tagContent)
        
        tipImg.snp.makeConstraints { make in
            make.leading.equalTo(5)
            make.centerY.equalToSuperview()
        }
        
        tagContent.snp.makeConstraints { make in
            make.leading.equalTo(tipImg.snp.trailing).offset(1)
            make.trailing.equalTo(-5)
            make.centerY.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var tipImg = UIImageView()
    
    lazy var tagContent: UILabel = {
        let lab =  createLab(.hexStrToColor("#666666"), UIFontSemibold(9.dbw))
        return lab
    }()
}
