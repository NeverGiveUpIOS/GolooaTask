//
//  TaskStepView.swift
//  Golaa
//
//  Created by duke on 2024/5/16.
//

import UIKit

enum TaskStepOption {
    case add
    case delete
    case finish
}

class TaskStepView: UIView {
    var dataSource: [TaskStepModel] = [] {
        didSet {
            configStepNum()
            let height = dataSource.reduce(0.0) { $0 + $1.cellHeight }
            updateLayoutBlock?(height)
        }
    }
    var tapEidtTitleBlock: ((TaskStepModel, String) -> Void)?
    var updateLayoutBlock: ((CGFloat) -> Void)?
    var didFinishBlock: (() -> Void)?
    
    // 是否填写完成
    var isEditFinish: Bool {
        var isFinish = true
        if dataSource.last?.type != .finish {
            isFinish = false
        }
        if dataSource.first(where: { $0.type == .add || $0.type == .addLast }) != nil {
            isFinish = false
        }
        for item in dataSource {
            if item.type == .edit, (item.explain.isEmpty || item.explain == "editTaskImageAndTextInstructions".homeLocalizable()) {
                isFinish = false
            }
        }
        return isFinish
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildUI() {
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func reloadData() {
        tableView.reloadData()
        let height = dataSource.reduce(0.0) { $0 + $1.cellHeight }
        updateLayoutBlock?(height)
    }
    
    private func configStepNum() {
        for i in 0..<dataSource.count {
            let model = dataSource[i]
            model.stepNum = i + 1
        }
    }
    
    private func execute(_ option: TaskStepOption, model: TaskStepModel) {
        switch option {
        case .add:
            if dataSource.count >= 4 { return }
            let new = TaskStepModel()
            new.type = .edit
            if dataSource.isEmpty {
                dataSource.append(new)
            } else {
                dataSource.insert(new, at: dataSource.count - 1)
                let edits = dataSource.filter({ $0.type == .edit })
                if let last = dataSource.last, (last.type == .add || last.type == .addLast) {
                    last.type = edits.count >= 3 ? .addLast : .add
                }
                edits.forEach({ $0.isShowDelete = edits.count > 1 ? true : false })
            }
            configStepNum()
            tableView.reloadData()
            let height = dataSource.reduce(0.0) { $0 + $1.cellHeight }
            updateLayoutBlock?(height)
        case .delete:
            if dataSource.count <= 2 { return }
            dataSource.removeAll(where: { $0.stepNum == model.stepNum })
            let edits = dataSource.filter({ $0.type == .edit })
            if let last = dataSource.last, (last.type == .add || last.type == .addLast) {
                last.type = edits.count >= 3 ? .addLast : .add
            }
            edits.forEach({ $0.isShowDelete = edits.count > 1 ? true : false })
            configStepNum()
            tableView.reloadData()
            let height = dataSource.reduce(0.0) { $0 + $1.cellHeight }
            updateLayoutBlock?(height)
        case .finish:
            if dataSource.count > 4 { return }
            dataSource.removeLast()
            let finish = TaskStepModel()
            finish.type = .finish
            dataSource.append(finish)
            configStepNum()
            tableView.reloadData()
            let height = dataSource.reduce(0.0) { $0 + $1.cellHeight }
            updateLayoutBlock?(height)
            didFinishBlock?()
        }
    }
    
    private lazy var tableView: UITableView = {
        let tab = UITableView()
        tab.separatorStyle = .none
        tab.showsVerticalScrollIndicator = false
        tab.showsHorizontalScrollIndicator = false
        // 修改指示器的缩进 - 强行解包是为了拿到一个必有的 inset
        tab.scrollIndicatorInsets = tab.contentInset
        if #available(iOS 15.0, *) {
            tab.sectionHeaderTopPadding = 0
        }
        if #available(iOS 11.0, *) {
            tab.contentInsetAdjustmentBehavior = .never
            tab.estimatedRowHeight = 1
            tab.estimatedSectionHeaderHeight = 0
            tab.estimatedSectionFooterHeight = 0
        }
        tab.isScrollEnabled = false
        tab.register(TaskStepCell.self, forCellReuseIdentifier: NSStringFromClass(TaskStepCell.self))
        tab.register(TaskStepAddCell.self, forCellReuseIdentifier: NSStringFromClass(TaskStepAddCell.self))
        tab.dataSource = self
        tab.delegate = self
        return tab
    }()
}

extension TaskStepView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataSource[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: model.type.cellId, for: indexPath)
        if let cell = cell as? TaskStepCell {
            cell.bind(model)
            cell.tapEidtTitleBlock = tapEidtTitleBlock
            cell.addImgBlock = { image in
                model.image = image
            }
            cell.clearImgBlock = { _ in
                model.image = nil
            }
            cell.tapDeleteStepBlock = { [weak self] item in
                guard let self = self else { return }
                self.execute(.delete, model: item)
            }
        } else if let cell = cell as? TaskStepAddCell {
            cell.bind(model)
            cell.clickAddSetpBlock = { [weak self] item in
                guard let self = self else { return }
                self.execute(.add, model: item)
            }
            cell.clickFinishBlock = {  [weak self] item in
                guard let self = self else { return }
                self.execute(.finish, model: item)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = dataSource[indexPath.row]
        return model.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
