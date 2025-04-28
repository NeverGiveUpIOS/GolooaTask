//
//  SearchTaskViewController.swift
//  Golaa
//
//  Created by duke on 2024/5/21.
//

import UIKit

class SearchTaskViewController: BasTableViewVC {
    
    lazy var daraList = [HomeListModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        hiddenNavView(true)
    }
    
    private func buildUI() {
        
        view.addSubview(backBtn)
        view.addSubview(searchContent)
        searchContent.addSubview(searchIcon)
        searchContent.addSubview(textField)
        view.addSubview(searchBtn)
        setupFootRefresh()
        tableView?.rowHeight = 80
        tableView?.gt.register(cellClass: SearchTaskCell.self)
        setupEmptyView(0)
        
        backBtn.snp.makeConstraints { make in
            make.top.equalTo(safeAreaTp + 10)
            make.leading.equalTo(15)
            make.width.height.equalTo(24)
        }
        
        searchContent.snp.makeConstraints { make in
            make.top.equalTo(safeAreaTp + 4.5)
            make.leading.equalTo(44)
            make.trailing.equalTo(searchBtn.snp.leading).offset(-13.5)
            make.height.equalTo(35)
        }
        
        searchIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(18)
            make.width.height.equalTo(15)
        }
        
        textField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(searchIcon.snp.trailing).offset(10)
            make.trailing.equalTo(-10)
            make.height.equalTo(17)
        }
        
        searchBtn.snp.makeConstraints { make in
            make.centerY.equalTo(searchContent.snp.centerY)
            make.trailing.equalTo(-15)
            make.width.height.equalTo(24)
        }
        
        tableView?.snp.makeConstraints { make in
            make.top.equalTo(naviH)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(-safeAreaTp)
        }
    }
    
    override func loadListData() {
        super.loadListData()
        mutateLoadSearchList()
    }
    
    private func keyboardReturn() {
        page = 1
        mutateLoadSearchList()
    }
    
    @objc private func tapSearchAction(sender: UITapGestureRecognizer) {
        textField.becomeFirstResponder()
    }
    
    private lazy var backBtn: UIButton = {
        let btn =  UIButton(type: .custom)
        btn.image(.backBlack)
        btn.gt.handleClick { _ in
            RoutinStore.dismiss()
        }
        return btn
    }()
    
    private lazy var searchContent: UIView = {
        let view = UIView()
        view.backgroundColor = .xf2
        view.gt.setCornerRadius(8)
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapSearchAction)))
        return view
    }()
    
    private lazy var searchIcon: UIImageView = {
        let img = UIImageView()
        img.image = .searchTaskSearch
        return img
    }()
    
    private lazy var textField: UITextField = {
        let text = UITextField()
        text.textColor = .black
        text.font = UIFontSemibold(12)
        text.clearButtonMode = .whileEditing
        text.returnKeyType = .done
        text.keyboardType = .default
        text.delegate = self
        text.attributedPlaceholder = NSMutableAttributedString(string: "searchTaskPlaceholder".homeLocalizable(), attributes: [.font: UIFontReg(12), .foregroundColor: UIColorHex("#999999")])
        return text
    }()
    
    private lazy var searchBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.image(.searchTaskBtn)
        btn.gt.handleClick { [weak self] _ in
            self?.endEditTextField()
        }
        return btn
    }()
}

extension SearchTaskViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daraList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.gt.dequeueReusableCell(cellType: SearchTaskCell.self, cellForRowAt: indexPath)
        if daraList.count > 0 {
            cell.bind(model: daraList[indexPath.row])
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if daraList.count > 0 {
            let model =  daraList[indexPath.row]
            RoutinStore.push(.taskDesc, param: ["id": model.id, "source": TaskDescFromSource.other.rawValue])
        }
    }
}

extension SearchTaskViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditTextField()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        keyboardReturn()
    }
    
    func endEditTextField() {
        textField.resignFirstResponder()
        textField.endEditing(true)
    }
    
}

extension SearchTaskViewController {
    
    private func mutateLoadSearchList() {
        let text = self.textField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        var params: [String: Any] = [:]
        params["page.current"] = page
        params["page.size"] = size
        params["tab"] = 0
        params["keyword"] = text
        
        if text.count <= 0 {
            self.setupEmptyView(0)
            self.endRefreshAndReloadData(0, 0)
            return
        }
        
        NetAPI.HomeAPI.taskList.reqToListHandler(parameters: params, model: HomeListModel.self) { [weak self] list, _ in
            guard let self = self else { return }
            if page == 1 {
                self.daraList.removeAll()
            }
            self.daraList.append(contentsOf: list)
            self.daraList.forEach({ $0.search = text })
            self.setupEmptyView(self.daraList.count)
            self.endRefreshAndReloadData(list.count, self.daraList.count)
            
        } failed: { error in
            print("error: \(error)")
            self.setupEmptyView(0)
            self.endRefreshAndReloadData(0, 0)
        }
        
    }
    
    
}
