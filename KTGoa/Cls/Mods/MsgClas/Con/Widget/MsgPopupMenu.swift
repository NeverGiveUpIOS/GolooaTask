//
//  MsgPopupMenu.swift
//  Golaa
//
//  Created by chenkaisong on 2024/5/10.
//

import UIKit

class MsgPopupMenu: UIView {
    
    // MARK: - Public
    static func show(_ items: [String], topRight: CGPoint, completion: CallBackIntBlock? = nil) {
        let view = MsgPopupMenu(items, topRight: topRight, completion: completion)
        view.show()
    }
    
    // MARK: - Models
    private var items: [String] = []
    private var topRight: CGPoint
    private var completion: CallBackIntBlock?
    
    // MARK: - Lifecycle
    init(_ items: [String], topRight: CGPoint, completion: CallBackIntBlock? = nil) {
        self.items = items
        self.topRight = topRight
        self.completion = completion
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.gt.addCorner(conrners: .topRight, radius: 2)
        tableView.gt.addCornerAndShadow(superview: self, conrners: [.topLeft, .bottomLeft, .bottomRight], radius: 12, shadowColor: UIColorHex("#000000", alpha: 0.1), shadowOffset: CGSize(width: 0, height: 0), shadowOpacity: 1, shadowRadius: 3)
    }
    
    // MARK: - Views
    private func setupViews() {
        let view = UIView()
        addSubview(view)
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        view.addGestureRecognizer(tap)
        
        let widths = items.map { $0.rectWidth(font: UIFontReg(14), size: .init(width: .max, height: .max)) }
        let maxWidth = widths.max() ?? 0
        
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(topRight.y)
            make.trailing.equalTo(-topRight.x)
            make.width.equalTo(maxWidth + 46)
            make.height.equalTo(tableView.rowHeight * CGFloat(items.count))
        }
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .white
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.gt.register(cellClass: MsgPopupMenuCell.self)
        tableView.rowHeight = 36
        tableView.separatorColor = .white.withAlphaComponent(0.1)
        tableView.separatorInset = .init(top: 0, left: 12, bottom: 0, right: 12)
        tableView.gt.addShadow(shadowColor: .red, shadowOffset: .init(width: 1, height: 1), shadowOpacity: 0.8)
        return tableView
    }()
    
    // MARK: - Actions
        private func show() {
        getKeyWindow().addSubview(self)
        self.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc private func dismiss() {
        removeFromSuperview()
    }
    
}

extension MsgPopupMenu: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MsgPopupMenuCell.className, for: indexPath) as? MsgPopupMenuCell
        cell?.label.text = items[indexPath.row]
        return cell!
    }
    
}

extension MsgPopupMenu: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss()
        completion?(indexPath.row)
    }
    
}

class MsgPopupMenuCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private(set) lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = UIColorHex("#000000")
        label.font = UIFontReg(14)
        return label
    }()
    
}
