//
//  ChorePublishCell.swift
//  Golaa
//
//  Created by Cb on 2024/5/21.
//

import Foundation

class ChorePublishCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configViews()
        configActions()
//        configData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configViews() {
        contentView.backgroundColor = .white
        contentView.gt.setCornerRadius(8)
        
        contentView.addSubview(avatarIcon)
        avatarIcon.snp.makeConstraints { make in
            make.width.height.equalTo(66)
            make.top.leading.equalTo(15)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarIcon)
            make.leading.equalTo(avatarIcon.snp.trailing).offset(12)
            make.trailing.equalTo(-15)
        }
        
        contentView.addSubview(countLabel)
        countLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarIcon.snp.trailing).offset(12)
            make.top.equalTo(titleLabel.snp.bottom).offset(7)
        }
                
        contentView.addSubview(bottomContainer)
        bottomContainer.snp.makeConstraints { make in
            make.height.equalTo(79)
            make.leading.equalTo(15)
            make.bottom.trailing.equalTo(-15)
        }
        
        contentView.addSubview(stateLabel)
        stateLabel.snp.makeConstraints { make in
            make.trailing.equalTo(-15)
            make.bottom.equalTo(avatarIcon.snp.bottom).offset(-2)
        }
        
        contentView.addSubview(stateIcon)
        stateIcon.snp.makeConstraints { make in
            make.trailing.equalTo(stateLabel.snp.leading).offset(-4)
            make.centerY.equalTo(stateLabel.snp.centerY).offset(0)
            make.width.height.equalTo(15)
        }
        
        contentView.addSubview(supplyLabel)
        supplyLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarIcon.snp.trailing).offset(12)
            make.trailing.equalTo(stateIcon.snp.leading).offset(-5)
            make.bottom.equalTo(bottomContainer.snp.top).offset(-12)
        }
        
        bottomContainer.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(-12)
        }
        
        if !GlobalHelper.shared.inEndGid {
            stackView.addArrangedSubview(leftStackView)
            leftStackView.addArrangedSubview(leftLabel)
            leftStackView.addArrangedSubview(leftDetailLabel)
        }
        
        stackView.addArrangedSubview(middleStackView)
        middleStackView.addArrangedSubview(middleLabel)
        middleStackView.addArrangedSubview(middleDetailLabel)
        
        stackView.addArrangedSubview(rightStackView)
        rightStackView.addArrangedSubview(rightLabel)
        rightStackView.addArrangedSubview(rightDetailLabel)

    }
    
    func configActions() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapClick))
        titleLabel.addGestureRecognizer(tap)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(tapClick))
        avatarIcon.addGestureRecognizer(tap2)
    }
    
    @objc private func tapClick() {
        guard let model = model else { return }
        RoutinStore.push(.taskDesc, param: ["id": model.id, "source": TaskDescFromSource.other.rawValue])
    }
    
    private func configData() {
        titleLabel.text = ""
        countLabel.text = ""
        stateLabel.text = "pendingSettlement".meLocalizable()
        if GlobalHelper.shared.inEndGid {
            leftLabel.text = "participate".meLocalizable()
            leftDetailLabel.text = ""
            rightLabel.text = "completions".meLocalizable()
        } else {
            leftLabel.text = "earnings".meLocalizable()
            leftDetailLabel.text = ""
            rightLabel.text = "registrations".meLocalizable()
        }
        rightDetailLabel.text = ""
    }
    
    private var model: HomeListModel?
    
    func configModel(_ model: HomeListModel) {
        self.model = model
        
        avatarIcon.normalImageUrl(model.img)

        titleLabel.text = model.name
        countLabel.text = model.picDes

        if !model.supplyDeposit.isEmpty {
            supplyLabel.text = model.supplyDeposit
            supplyLabel.isHidden = false

        } else {
            supplyLabel.text = ""
            supplyLabel.isHidden = true
        }
        
        stateLabel.text = model.statusDesc
        if !model.statusScene.icon.isEmpty {
            stateLabel.text = model.statusDesc
            stateIcon.image = UIImage(named: model.statusScene.icon)
        } else {
            stateLabel.text = ""
            stateIcon.image = nil
        }
                
        leftLabel.text = "securityDepositPaid".meLocalizable()
        leftDetailLabel.text = model.depositDes

        middleLabel.text = "numberOfPeopleClaimed".meLocalizable()
        middleDetailLabel.text = "\(model.receNum)"
        
        rightLabel.text = "quantityOfTasksCompleted".meLocalizable()
        rightDetailLabel.text = "\(model.finishCount)"

    }
    
    // MARK: - 属性
    let avatarIcon: UIImageView = {
        let img = UIImageView()
        img.gt.setCornerRadius(9)
        img.contentMode = .scaleAspectFill
        img.isUserInteractionEnabled = true
        return img
    }()
    
    let titleLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = .black
        lab.font = .boldSystemFont(ofSize: 14)
        lab.numberOfLines = 2
        lab.isUserInteractionEnabled = true
        return lab
    }()
    
    let countLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.hexStrToColor("#FF5722")
        lab.font = .oswaldDemiBold(16)
        return lab
    }()
    
    let supplyLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.hexStrToColor("#FF5722")
        lab.font = .systemFont(ofSize: 11)
        lab.numberOfLines = 0
        lab.isHidden = true
        lab.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return lab
    }()
    
    let stateIcon = UIImageView(image: UIImage(named: "mine_chore_state"))
    
    let stateLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = .black
        lab.font = .systemFont(ofSize: 14)
        lab.numberOfLines = 0
        lab.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return lab
    }()
    
    let bottomContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.xf2
        view.gt.setCornerRadius(8)
        return view
    }()
    
    let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.alignment = .center
        view.spacing = 0
        return view
    }()
    
    let leftStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .center
        view.spacing = 14
        return view
    }()
    
    let middleStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .center
        view.spacing = 14
        return view
    }()

    let rightStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .center
        view.spacing = 14
        return view
    }()
    
    let leftLabel: UILabel = {
        let view = UILabel()
        view.textColor = UIColor.hexStrToColor("#F96464")
        view.font = .systemFont(ofSize: 11)
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    
    let leftDetailLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.hexStrToColor("#F96464")
        lab.font = .oswaldDemiBold(16)
        lab.textAlignment = .center
        lab.numberOfLines = 0
        return lab
    }()

    let middleLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.hexStrToColor("#000000")
        lab.font = .systemFont(ofSize: 11)
        lab.textAlignment = .center
        lab.numberOfLines = 0
        return lab
    }()
    
    let middleDetailLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.hexStrToColor("#000000")
        lab.font = .oswaldDemiBold(16)
        lab.textAlignment = .center
        lab.numberOfLines = 0
        return lab
    }()

    let rightLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.hexStrToColor("#000000")
        lab.font = .systemFont(ofSize: 11)
        lab.textAlignment = .center
        lab.numberOfLines = 0
        return lab
    }()

    let rightDetailLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.hexStrToColor("#000000")
        lab.font = .oswaldDemiBold(16)
        lab.textAlignment = .center
        lab.numberOfLines = 0
        return lab
    }()

}
