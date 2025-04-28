//
//  ChoreRecordCell.swift
//  Golaa
//
//  Created by Cb on 2024/5/21.
//

import Foundation

class ChoreRecordCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configViews()
        configActions()
        //        configData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configViews() {
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
            make.bottom.equalTo(avatarIcon.snp.bottom)
        }
        
        contentView.addSubview(stateLabel)
        stateLabel.snp.makeConstraints { make in
            make.trailing.equalTo(-15)
            make.bottom.equalTo(avatarIcon.snp.bottom).offset(-2)
        }
        
        contentView.addSubview(stateIcon)
        stateIcon.snp.makeConstraints { make in
            make.trailing.equalTo(stateLabel.snp.leading).offset(-4)
            make.bottom.equalTo(avatarIcon.snp.bottom).offset(-2)
        }
        
        contentView.addSubview(bottomContainer)
        bottomContainer.snp.makeConstraints { make in
            make.top.equalTo(avatarIcon.snp.bottom).offset(12)
            make.leading.equalTo(15)
            make.bottom.trailing.equalTo(-15)
        }
        
        bottomContainer.addSubview(leftLabel)
        bottomContainer.snp.makeConstraints { make in
            make.top.equalTo(avatarIcon.snp.bottom).offset(12)
            make.leading.equalTo(15)
            make.bottom.trailing.equalTo(-15)
        }
        
        contentView.addSubview(bottomContainer)
        bottomContainer.snp.makeConstraints { make in
            make.top.equalTo(avatarIcon.snp.bottom).offset(12)
            make.leading.equalTo(15)
            make.bottom.trailing.equalTo(-15)
        }
        
        bottomContainer.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stackView.addArrangedSubview(leftStackView)
        leftStackView.addArrangedSubview(leftLabel)
        leftStackView.addArrangedSubview(leftDetailLabel)
        
        stackView.addArrangedSubview(rightStackView)
        rightStackView.addArrangedSubview(rightLabel)
        rightStackView.addArrangedSubview(rightDetailLabel)
        
    }
    
    private func configActions() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapClick))
        titleLabel.addGestureRecognizer(tap)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(tapClick))
        avatarIcon.addGestureRecognizer(tap2)
    }
    
    @objc private func tapClick() {
        RoutinStore.push(.taskDesc, param: ["id": listModel?.id ?? 0, "source": TaskDescFromSource.other.rawValue])
    }
    
    private func configData() {
        titleLabel.text = ""
        countLabel.text = ""
        stateLabel.text = "pendingSettlement".meLocalizable()
        
        leftDetailLabel.text = ""
        
        if GlobalHelper.shared.inEndGid {
            leftLabel.text = "participate".meLocalizable()
            rightLabel.text = "completions".meLocalizable()
        } else {
            leftLabel.text = "earnings".meLocalizable()
            rightLabel.text = "registrations".meLocalizable()
        }
        rightDetailLabel.text = ""
    }
    
    // MARK: - TaskDescModel
    
    private var model: TaskDescModel?
    
    func configModel(_ model: TaskDescModel) {
        self.model = model
    }
    
    // MARK: - HomeListModel
    
    private var listModel: HomeListModel?
    
    func configListModel(_ listModel: HomeListModel) {
        self.listModel = listModel
        
        avatarIcon.normalImageUrl(listModel.img)
        
        titleLabel.text = listModel.name
        countLabel.text = listModel.picDes
        if GlobalHelper.shared.inEndGid {
            leftLabel.text = "participate".meLocalizable()
            leftDetailLabel.text = "\(listModel.receNum)"
            
            rightLabel.text = "completions".meLocalizable()
            rightDetailLabel.text = "\(listModel.finishCount)"
        } else {
            leftLabel.text = "earnings".meLocalizable()
            leftDetailLabel.text = listModel.incomeDesc
            
            rightLabel.text = "registrations".meLocalizable()
            rightDetailLabel.text = "\(listModel.finishCount)"
        }
        
        if !listModel.choreStatusScene.icon.isEmpty {
            stateLabel.text = listModel.choreStatusScene.title
            stateIcon.image = UIImage(named: listModel.choreStatusScene.icon)
        } else {
            stateLabel.text = ""
            stateIcon.image = nil
        }
    }
    
    // MARK: - 属性
    private let avatarIcon: UIImageView = {
        let img = UIImageView()
        img.gt.setCornerRadius(9)
        img.contentMode = .scaleAspectFill
        img.isUserInteractionEnabled = true
        return img
    }()
    
    private let titleLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = .black
        lab.font = .boldSystemFont(ofSize: 14)
        lab.numberOfLines = 2
        lab.isUserInteractionEnabled = true
        return lab
    }()
    
    private let countLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.hexStrToColor("#FF5722")
        lab.font = .oswaldDemiBold(16)
        return lab
    }()
    
    private let stateIcon = UIImageView(image: UIImage(named: "mine_chore_state"))
    
    private let stateLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = .black
        lab.font = .systemFont(ofSize: 14)
        lab.numberOfLines = 0
        return lab
    }()
    
    private let bottomContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.xf2
        view.gt.setCornerRadius(8)
        return view
    }()
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.alignment = .center
        view.spacing = 0
        return view
    }()
    
    private let leftStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .center
        view.spacing = 6
        return view
    }()
    
    private let rightStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .center
        view.spacing = 6
        return view
    }()
    
    private let leftLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.hexStrToColor("#000000")
        lab.font = .systemFont(ofSize: 14)
        lab.textAlignment = .center
        return lab
    }()
    
    private let leftDetailLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.hexStrToColor("#000000")
        lab.font = .oswaldDemiBold(16)
        lab.textAlignment = .center
        lab.numberOfLines = 0
        return lab
    }()
    
    private let rightLabel = {
        let lab = UILabel()
        lab.textColor = UIColor.hexStrToColor("#000000")
        lab.font = .systemFont(ofSize: 14)
        lab.textAlignment = .center
        return lab
    }()
    
    private let rightDetailLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.hexStrToColor("#000000")
        lab.font = .oswaldDemiBold(16)
        lab.textAlignment = .center
        return lab
    }()
    
}
