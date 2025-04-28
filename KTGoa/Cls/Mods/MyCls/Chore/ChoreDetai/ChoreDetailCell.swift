//
//  ChoreDetailCell.swift
//  Golaa
//
//  Created by Cb on 2024/5/21.
//

import Foundation

class ChoreDetailCell: UICollectionViewCell {
    
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
        contentView.addSubview(middleView)
        middleView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configActions() {
        middleView.didSelectClosure = { [weak self] model in
            self?.didSelectClosure?(model)
        }
    }
    
    func configData(_ roundStyle: CellRoundStyle) {
        middleView.configData(roundStyle, type: .recordData)
    }
    
    // MAKR: - publishRecordModel
    
    private var publishModel: ChorePublishDetailModel?
    
    func configPublishModel(_ model: ChorePublishDetailModel, roundStyle: CellRoundStyle) {
        self.publishModel = model
        middleView.configPublishModel(model, roundStyle: roundStyle, type: .publishData)
    }
    
    // MAKR: - ChoreRecordModel
    
    private var recordModel: ChoreRecordModel?
    
    func configRecordModel(_ model: ChoreRecordModel, roundStyle: CellRoundStyle) {
        self.recordModel = model
        middleView.configRecordModel(model, roundStyle: roundStyle, type: .recordData)
    }
    
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
        contentView.layer.cornerRadius = radius
        contentView.layer.maskedCorners = maskedCorners
        contentView.layer.masksToBounds = true
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
    
    private let middleView: ChoreGridView = {
        let view = ChoreGridView()
        view.backgroundColor = .white
        return view
    }()
    
}
