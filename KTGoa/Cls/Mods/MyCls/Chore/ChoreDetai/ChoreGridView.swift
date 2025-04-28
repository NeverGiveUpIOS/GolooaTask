//
//  ChoreGridView.swift
//  Golaa
//
//  Created by Cb on 2024/5/21.
//

import Foundation

enum ChoreGridType {
    case recordTitle
    case publishTitle
    
    case recordData
    case publishData
}

class ChoreGridView: UIView {
    
    var didSelectClosure: ((_ date: String) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configViews()
        configActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configViews() {
        backgroundColor = .white
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(16)
            make.trailing.equalTo(-13)
            make.centerY.equalToSuperview()
        }
        
        stackView.addArrangedSubview(leftOneLabel)
        if !GlobalHelper.shared.inEndGid {
            stackView.addArrangedSubview(leftTwoLabel)
        }
        stackView.addArrangedSubview(rightOneLabel)
        stackView.addArrangedSubview(rightTwoLabel)
        
        addSubview(line)
        line.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.equalTo(10)
            make.trailing.equalTo(-10)
            make.bottom.equalToSuperview()
        }
    }
    
    private func configActions() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapClick))
        rightTwoLabel.addGestureRecognizer(tap)
    }
    
    @objc private func tapClick() {
        guard let type = type else { return }
        if type == .publishData, let model = publishModel, let scene = model.scene {
            if scene == .needCheck {
                didSelectClosure?(model.settleDateDesc)
            }
        }
        debugPrint("tapClick")
    }
    
    func configData(_ roundStyle: CellRoundStyle, type: ChoreGridType) {
        roundView(roundStyle)
        
        if type == .recordTitle || type == .publishTitle {
            
            leftOneLabel.text = "date".meLocalizable()
            if type == .recordTitle {
                leftTwoLabel.text = "earnings".meLocalizable()
                rightTwoLabel.text = GlobalHelper.shared.inEndGid ? "taskStatus".meLocalizable() : "settlementStatus".meLocalizable()
                rightTwoLabel.text = "settlementStatus".meLocalizable()
            } else {
                leftTwoLabel.text = "consumed".meLocalizable()
                rightTwoLabel.text = "verificationStatus".meLocalizable()
            }
            
            leftOneLabel.text = "date".meLocalizable()
            if GlobalHelper.shared.inEndGid {
                leftTwoLabel.text = "participate".meLocalizable()
                rightOneLabel.text = "completions".meLocalizable()
            } else {
                rightOneLabel.text = "registrations".meLocalizable()
            }
            
            leftOneLabel.textColor = UIColor.hexStrToColor("#666666")
            leftTwoLabel.textColor = UIColor.hexStrToColor("#666666")
            rightOneLabel.textColor = UIColor.hexStrToColor("#666666")
            rightTwoLabel.textColor = UIColor.hexStrToColor("#666666")
            
            leftTwoLabel.font = .systemFont(ofSize: 11)
            leftTwoLabel.font = .systemFont(ofSize: 11)
            rightOneLabel.font = .systemFont(ofSize: 11)
            rightTwoLabel.font = .systemFont(ofSize: 11)
        } else {
            leftOneLabel.text = ""
            leftTwoLabel.text = ""
            rightOneLabel.text = ""
            rightTwoLabel.text = ""
            
            leftOneLabel.textColor = UIColor.hexStrToColor("#000000")
            leftTwoLabel.textColor = UIColor.hexStrToColor("#000000")
            rightOneLabel.textColor = UIColor.hexStrToColor("#000000")
            rightTwoLabel.textColor = UIColor.hexStrToColor("#000000")
            
            leftTwoLabel.font = .boldSystemFont(ofSize: 12)
            leftTwoLabel.font = .boldSystemFont(ofSize: 12)
            rightOneLabel.font = .boldSystemFont(ofSize: 12)
            rightTwoLabel.font = .boldSystemFont(ofSize: 12)
        }
    }
    
    // MARK: - ChoreRecordModel
    
    private var type: ChoreGridType?
    private var choreModel: ChoreRecordModel?
    
    func configRecordModel(_ model: ChoreRecordModel, roundStyle: CellRoundStyle, type: ChoreGridType) {
        self.type = type
        self.choreModel = model
        roundView(roundStyle)
        
        leftOneLabel.text = model.settleDesc
        leftTwoLabel.text = model.incomeDesc
        rightOneLabel.text = "\(model.finishCount)"
        rightTwoLabel.text = "\(model.statusShow)"
        
        leftOneLabel.textColor = UIColor.hexStrToColor("#000000")
        leftTwoLabel.textColor = UIColor.hexStrToColor("#000000")
        rightOneLabel.textColor = UIColor.hexStrToColor("#000000")
        rightTwoLabel.textColor = UIColor.hexStrToColor("#000000")
        
        leftOneLabel.font = .boldSystemFont(ofSize: 12)
        leftTwoLabel.font = .boldSystemFont(ofSize: 12)
        rightOneLabel.font = .boldSystemFont(ofSize: 12)
        rightTwoLabel.font = .boldSystemFont(ofSize: 12)
        
        if let scene = model.scene {
            rightTwoLabel.isUserInteractionEnabled = scene.isEnable
            rightTwoLabel.textColor = scene.enableColor
        } else {
            rightTwoLabel.isUserInteractionEnabled = false
            rightTwoLabel.textColor = UIColor.hexStrToColor("#000000")
        }
    }
    
    // MARK: - ChorePublishDetailModel
    
    private var publishModel: ChorePublishDetailModel?
    
    func configPublishModel(_ model: ChorePublishDetailModel, roundStyle: CellRoundStyle, type: ChoreGridType) {
        self.type = type
        self.publishModel = model
        roundView(roundStyle)
        
        leftOneLabel.text = model.settleDateDesc
        leftTwoLabel.text = model.consumeDesc
        rightOneLabel.text = "\(model.finishCount)"
        rightTwoLabel.text = "\(model.statusShow)"
        
        leftOneLabel.textColor = UIColor.hexStrToColor("#000000")
        leftTwoLabel.textColor = UIColor.hexStrToColor("#000000")
        rightOneLabel.textColor = UIColor.hexStrToColor("#000000")
        
        leftOneLabel.font = .boldSystemFont(ofSize: 12)
        leftTwoLabel.font = .boldSystemFont(ofSize: 12)
        rightOneLabel.font = .boldSystemFont(ofSize: 12)
        rightTwoLabel.font = .systemFont(ofSize: 12)
        
        if let scene = model.scene {
            rightTwoLabel.isUserInteractionEnabled = scene.isEnable
            rightTwoLabel.textColor = scene.enableColor
        } else {
            rightTwoLabel.isUserInteractionEnabled = false
            rightTwoLabel.textColor = UIColor.hexStrToColor("#000000")
        }
    }
    
    // MARK: -
    
    private func roundView(_ roundStyle: CellRoundStyle) {
        var maskedCorners: CACornerMask = []
        var radius = 0.0
        switch roundStyle {
        case .top:
            radius = 10
            maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        case .bottom:
            radius = 10
            maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        case .noRound:
            radius = 0.0
            maskedCorners = []
        case .all:
            radius = 10
        }
        layer.cornerRadius = radius
        layer.maskedCorners = maskedCorners
        layer.masksToBounds = true
        
        line.isHidden = roundStyle == .bottom
    }
    
    // MARK: - 属性
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.alignment = .center
        view.spacing = 0
        return view
    }()
    
    private let leftOneLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.hexStrToColor("#000000")
        lab.font = .boldSystemFont(ofSize: 12)
        lab.numberOfLines = 0
        lab.textAlignment = .center
        return lab
    }()
    
    private let leftTwoLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.hexStrToColor("#000000")
        lab.font = .boldSystemFont(ofSize: 14)
        lab.numberOfLines = 0
        lab.textAlignment = .center
        return lab
    }()
    
    private let rightOneLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.hexStrToColor("#000000")
        lab.font = .boldSystemFont(ofSize: 14)
        lab.numberOfLines = 0
        lab.textAlignment = .center
        return lab
    }()
    
    private let rightTwoLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.hexStrToColor("#000000")
        lab.font = .boldSystemFont(ofSize: 14)
        lab.numberOfLines = 0
        lab.textAlignment = .center
        return lab
    }()
    
    private let line:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.xf2
        view.isHidden = true
        return view
    }()
    
}
