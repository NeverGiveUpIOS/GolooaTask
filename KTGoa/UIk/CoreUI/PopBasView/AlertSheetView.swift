//
//  AlertBottomListView.swift
//  Golaa
//
//  Created by chenkaisong on 2024/5/10.
//

import UIKit

struct AlertSheetConfig {
    var title: String?
    var sectionH: CGFloat = 54
    var color: UIColor = UIColorHex("#000000")
    var font: UIFont = UIFontReg(16)
    var lineColor: UIColor = UIColorHex("#FAFAFA")
}

class AlertSheetView: AlertBaseView {
    
   static func show(dataSoruce: [AlertSheetConfig],
                    canceTitle: String = "cancel".globalLocalizable(),
                    completion: CallBackIntBlock?) {
    
       let view = AlertSheetView(frame: .zero,
                                  dataSoruce: dataSoruce,
                                  canceTitle: canceTitle,
                                  completion: completion)
       view.show(position: .bottom, containerType: .window, isFadeIn: false)
    }
    
    var selCompletion: CallBackIntBlock?
    lazy var list = [AlertSheetConfig]()
    
    init(frame: CGRect,
         dataSoruce: [AlertSheetConfig],
         canceTitle: String, 
         completion: CallBackIntBlock?) {
        super.init(frame: frame)
        
        list = dataSoruce
        selCompletion = completion
        
        canceButton.setTitle(canceTitle, for: .normal)
        
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contView.gt.addCorner(radius: 20)
    }
    
    private func setupSubviews() {
        contView.gt.addSubviews([tableView, canceButton])
        addSubview(contView)
        
        contView.snp.makeConstraints { make in
            make.leading.equalTo(10)
            make.trailing.equalTo(-10)
            make.width.equalTo(screW - 20)
            make.top.equalToSuperview()
            make.bottom.equalTo(-41)
        }
        
        let th = list.map({$0.sectionH}).reduce(0) { x, y in
            x + y
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(th)
        }
        
        canceButton.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.top.equalTo(tableView.snp.bottom).offset(8)
            make.leading.bottom.trailing.equalToSuperview()
        }
    }
    
    private lazy var contView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColorHex("#FAFAFA")
        return view
    }()
    
    lazy var canceButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .white
        button.contentHorizontalAlignment = .center
        button.setTitleColor(UIColorHex("#CBCBCB"), for: .normal)
        button.titleLabel?.font = UIFontReg(16)
        button.gt.handleClick { [weak self] _ in
            self?.dismissView()
        }
        return button
    }()
    
    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.backgroundColor = .white
        table.separatorStyle = .none
        table.estimatedRowHeight = 1
        table.isScrollEnabled = false
        table.estimatedSectionHeaderHeight = 0
        table.estimatedSectionFooterHeight = 0
        table.showsHorizontalScrollIndicator = false
        table.showsVerticalScrollIndicator = false
        table.dataSource = self
        table.delegate = self
        table.gt.register(cellClass: AlertSheetCell.self)
        return table
    }()
}

extension AlertSheetView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AlertSheetCell.className, for: indexPath) as? AlertSheetCell
        cell?.setupConfig(list[indexPath.row])
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selCompletion?(indexPath.row)
        dismissView()
    }
}

class AlertSheetCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        contentView.gt.addSubviews([titleLabel, lineView])
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(50)
        }
        
        lineView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    func setupConfig(_ config: AlertSheetConfig) {
        titleLabel.text = config.title
        titleLabel.textColor = config.color
        titleLabel.font = config.font
        lineView.backgroundColor = config.lineColor

        titleLabel.snp.updateConstraints { make in
            make.height.equalTo(config.sectionH)
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColorHex("#FAFAFA")
        return view
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
