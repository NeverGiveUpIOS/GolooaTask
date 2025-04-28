//
//  ChorePublishAppealView.swift
//  Golaa
//
//  Created by Cb on 2024/5/21.
//

import Foundation

class ChorePublishAppealView: UIView {
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
        backgroundColor = .white
        gt.setCornerRadius(8)
        
        addSubview(avatarIcon)
        avatarIcon.snp.makeConstraints { make in
            make.width.height.equalTo(66)
            make.top.leading.equalTo(15)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarIcon)
            make.leading.equalTo(avatarIcon.snp.trailing).offset(12)
            make.trailing.equalTo(-15)
        }
        
        addSubview(countLabel)
        countLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarIcon.snp.trailing).offset(12)
            make.bottom.equalTo(avatarIcon.snp.bottom)
        }
        
//        addSubview(stateLabel)
//        stateLabel.snp.makeConstraints { make in
//            make.trailing.equalTo(-15)
//            make.bottom.equalTo(avatarIcon.snp.bottom).offset(-2)
//        }
//        
//        addSubview(stateIcon)
//        stateIcon.snp.makeConstraints { make in
//            make.trailing.equalTo(stateLabel.snp.leading).offset(-4)
//            make.bottom.equalTo(avatarIcon.snp.bottom).offset(-2)
//        }
        
        addSubview(bottomContainer)
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
        
        addSubview(bottomContainer)
        bottomContainer.snp.makeConstraints { make in
            make.top.equalTo(avatarIcon.snp.bottom).offset(12)
            make.leading.equalTo(15)
            make.bottom.trailing.equalTo(-15)
        }
        
        bottomContainer.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(-12)
        }
        
        stackView.addArrangedSubview(leftStackView)
        leftStackView.addArrangedSubview(leftLabel)
        leftStackView.addArrangedSubview(leftDetailLabel)
        
        stackView.addArrangedSubview(middleStackView)
        middleStackView.addArrangedSubview(middleLabel)
        middleStackView.addArrangedSubview(middleDetailLabel)
        
        stackView.addArrangedSubview(rightStackView)
        rightStackView.addArrangedSubview(rightLabel)
        rightStackView.addArrangedSubview(rightDetailLabel)

    }
    
    private func configActions() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapClick))
        titleLabel.addGestureRecognizer(tap)
    }
    
    @objc private func tapClick() {
        guard let model = model else { return }
        RoutinStore.push(.taskDesc, param: ["id": model.id, "source": TaskDescFromSource.other.rawValue])
    }
    
    private func configData() {
        titleLabel.text = "【注册】网易智造佳能长焦摄影师标准的内容两行"
        countLabel.text = "$ 1999"
//        stateLabel.text = "pendingSettlement".meLocalizable()
        
        leftLabel.text = "dateOfAppeal".meLocalizable()
        leftDetailLabel.text = "2023-9-12"
        
        middleLabel.text = "consumeDeposit".meLocalizable()
        middleDetailLabel.text = "- $364"

        rightLabel.text = "quantityOfTasksCompleted".meLocalizable()
        rightDetailLabel.text = "13458"
    }
    
    private var model: HomeListModel?
    
    func configModel(_ model: HomeListModel) {
        self.model = model
        
        avatarIcon.normalImageUrl(model.img)

        titleLabel.text = model.name
        countLabel.text = model.picDes
                
        leftLabel.text = "dateOfAppeal".meLocalizable()
        leftDetailLabel.text = model.settleDateDesc

        middleLabel.text = "consumeDeposit".meLocalizable()
        middleDetailLabel.text = "\(model.consumeDesc)"
        
        rightLabel.text = "quantityOfTasksCompleted".meLocalizable()
        rightDetailLabel.text = "\(model.finishCount)"
    }
    
    // MARK: - 属性
    private let avatarIcon: UIImageView = {
        let img = UIImageView()
        img.gt.setCornerRadius(9)
        img.contentMode = .scaleAspectFill
        img.backgroundColor = .lightGray
        return img
    }()
    
    private let titleLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = .black
        lab.font = .boldSystemFont(ofSize: 14)
        lab.numberOfLines = 0
        lab.isUserInteractionEnabled = true
        return lab
    }()
    
    private let countLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.hexStrToColor("#FF5722")
        lab.font = .boldSystemFont(ofSize: 16)
        return lab
    }()
    
//    private let stateIcon = UIImageView(image: UIImage(named: "mine_chore_state"))
//    
//    private let stateLabel: UILabel = {
        let lab = UILabel()
//        .textColor = .black
//        .font = .systemFont(ofSize: 14)
//        .numberOfLines = 0
//    }
    
    private let bottomContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.hexStrToColor("#F96464", 0.1)
        view.gt.setCornerRadius(8)
        return view
    }()
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.alignment = .bottom
        view.spacing = 0
        return view
    }()
    
    private let leftStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .center
        view.spacing = 14
        return view
    }()
    
    private let middleStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .center
        view.spacing = 14
        return view
    }()

    private let rightStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .center
        view.spacing = 14
        return view
    }()
    
    private let leftLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.hexStrToColor("#F96464")
        lab.font = .systemFont(ofSize: 11)
        lab.textAlignment = .center
        lab.numberOfLines = 0
        return lab
    }()
    
    private let leftDetailLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.hexStrToColor("#F96464")
        lab.font = .boldSystemFont(ofSize: 16)
        lab.textAlignment = .center
        lab.numberOfLines = 0
        return lab
    }()
    
    private let middleLabel: UILabel = {
        let lab = UILabel()
        lab .textColor = UIColor.hexStrToColor("#F96464")
        lab.font = .systemFont(ofSize: 11)
        lab.textAlignment = .center
        lab.numberOfLines = 0
        return lab
    }()
    
    private let middleDetailLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.hexStrToColor("#F96464")
        lab.font = .boldSystemFont(ofSize: 16)
        lab.textAlignment = .center
        lab.numberOfLines = 0
        return lab
    }()

    private let rightLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.hexStrToColor("#F96464")
        lab.font = .systemFont(ofSize: 11)
        lab.textAlignment = .center
        lab.numberOfLines = 0
        return lab
    }()

    private let rightDetailLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.hexStrToColor("#F96464")
        lab.font = .boldSystemFont(ofSize: 16)
        lab.textAlignment = .center
        return lab
    }()

}
