//
//  PouchEnsureCell.swift
//  Golaa
//
//  Created by Cb on 2024/5/20.
//

import Foundation

class PouchEnsureCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configViews()
        configActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configViews() {
        contentView.backgroundColor = .white
        
        contentView.addSubview(bgContentView)
        bgContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let middleView = UIView()
        bgContentView.addSubview(middleView)
        middleView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
        }
        
        middleView.addSubview(rightLabel)
        rightLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(-15)
        }
        
        middleView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalTo(rightLabel.snp.leading).offset(-5)
            make.top.equalToSuperview()
        }
        
        middleView.addSubview(detailLabel)
        detailLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.bottom.equalToSuperview()
        }
        
    }
    
    private func configActions() {
        
    }
    
    private var model: PouchDetailModel?
    
    func configModel(_ model: PouchDetailModel, roundStyle: CellRoundStyle) {
        self.model = model
        
        titleLabel.attributedText = model.attrContent
//        titleLabel.text = model.content // "taskDeposit".meLocalizable() + " (ID \(model.taskId)"//"Caução para Tarefa（ID 2345678）"
        detailLabel.text = model.addTime_// "12/20/2023 12:45"
//        rightLabel.text = model.flow    // "+ $100"
        rightLabel.text = model.amountDesc    // "+ $100"
        rightLabel.textColor = model.amountColor
        roundView(roundStyle)
    }
    
    func configData(_ roundStyle: CellRoundStyle) {
        titleLabel.text = "Caução para Tarefa（ID 2345678）"
        detailLabel.text = "12/20/2023 12:45"
        rightLabel.text = "+ $100"
        roundView(roundStyle)
    }
    
    private func roundView(_ roundStyle: CellRoundStyle) {
        var maskedCorners: CACornerMask = []
        var radius = 0.0
        var edges = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        switch roundStyle {
        case .top:
            radius = 12
            maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            edges = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        case .bottom:
            radius = 12
            maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            edges = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)

        case .noRound:
            radius = 0.0
            maskedCorners = []
            edges = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        case .all:
            radius = 12
            edges = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        }
        contentView.layer.cornerRadius = radius
        contentView.layer.maskedCorners = maskedCorners
        contentView.layer.masksToBounds = true
        
        bgContentView.snp.remakeConstraints { make in
            make.edges.equalTo(edges)
        }
    }
    
    // MARK: - 属性
    private let bgContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let titleLabel: UILabel = {
        let lab = UILabel()
        lab.setContentHuggingPriority(.defaultLow, for: .horizontal)
        lab.textColor = .black
        lab.font = .systemFont(ofSize: 14)
        lab.numberOfLines = 0
        return lab
    }()
    
    private let detailLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.hexStrToColor("#CBCBCB")
        lab.font = .systemFont(ofSize: 12)
        lab.numberOfLines = 0
        return lab
    }()
    
    private let rightLabel: UILabel = {
        let lab = UILabel()
        lab.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        lab.textColor = UIColor.hexStrToColor("#F96464")
        lab.font = .oswaldDemiBold(16)
        return lab
    }()
    
}
