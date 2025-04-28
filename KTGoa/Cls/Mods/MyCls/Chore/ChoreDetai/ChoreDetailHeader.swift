//
//  ChoreDetailHeader.swift
//  Golaa
//
//  Created by Cb on 2024/5/21.
//

import Foundation

class ChoreDetailHeader: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configViews()
        configActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configViews() {
        addSubview(topView)
        topView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(46)
        }
        
        topView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(0)
        }
        
        topView.addSubview(rightIcon)
        rightIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(0)
            make.width.height.equalTo(14)
        }
        
        topView.addSubview(rightLabel)
        rightLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(rightIcon.snp.leading).offset(-4)
        }
        
        addSubview(bottomView)
        bottomView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
    }
    
    private func configActions() {
        rightIcon.gt.handleClick { [weak self] _ in
            guard let self = self else { return }
            guard let listModel = self.listModel else { return }
            print("copy")
            UIPasteboard.general.string = "\(listModel.id)"
            ToastHud.showToastAction(message: "copySuccessful".homeLocalizable())
        }
    }
    
    private func configData() {
        titleLabel.text = "dailyData".meLocalizable()
        rightLabel.text = "taskId".meLocalizable() + " 1212331231"
    }
    
    private var listModel: HomeListModel?
    
    func configListModel(_ listModel: HomeListModel, type: ChoreGridType) {
        self.listModel = listModel
        titleLabel.text = "dailyData".meLocalizable()
        rightLabel.text = "taskId".meLocalizable() + " \(listModel.id)"
        bottomView.configData(.top, type: type)
    }
    
    // MARK: - 属性
    private let topView = UIView()
    
    private let titleLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = .black
        lab.font = .systemFont(ofSize: 16)
        lab.numberOfLines = 0
        return lab
    }()
    
    private let rightLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.hexStrToColor("#999999")
        lab.font = .systemFont(ofSize: 11)
        return lab
    }()
    
    private let rightIcon: UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "mine_cpy"), for: .normal)
        btn.setBackgroundImage(UIImage(named: "mine_cpy"), for: .highlighted)
        return btn
    }()
    
    private let bottomView: ChoreGridView = {
        let view = ChoreGridView()
        view.backgroundColor = .white
        return view
    }()
}
