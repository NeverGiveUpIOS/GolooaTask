//
//  ShareTaskViewController.swift
//  Golaa
//
//  Created by duke on 2024/5/22.
//

import UIKit


class ShareSearchViewController: BasTableViewVC {
    
    var type: ShareSearchType = .friend
    var id = 0
    var link: String = ""
    lazy var dataList = [ShareSearchListModel]()
    
    override func routerParam(param: Any?, router: RoutinRouter?) {
        if let dict = param as? [String: Any] {
            if let type = dict["type"] as? ShareSearchType {
                self.type = type
            }
            if let id = dict["id"] as? Int {
                self.id = id
            }
            if let link = dict["link"] as? String {
                self.link = link
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        mutateLoadSearchList(type: type, text: "", page: page, size: size)
    }
    
    
    private func buildUI() {
        
        navTitle(type == .friend ? "shareWithFriends".homeLocalizable() : "shareToGroups".homeLocalizable())
        navBagColor(.clear)
        size = 1000
        
        view.insertSubview(maskBgView, at: 0)
        view.addSubview(arcView)
        view.addSubview(searchContent)
        searchContent.addSubview(searchIcon)
        searchContent.addSubview(textField)
        view.addSubview(cancelBtn)
        view.addSubview(bottomBtn)
        
        tableView?.rowHeight = 72
        tableView?.gt.register(cellClass: ShareSearchListCell.self)
        
        maskBgView.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(131)
        }
        
        arcView.snp.makeConstraints { make in
            make.top.equalTo(98)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(33)
        }
        
        searchContent.snp.makeConstraints { make in
            make.top.equalTo(arcView.snp.bottom)
            make.leading.equalTo(15)
            make.trailing.equalTo(cancelBtn.snp.leading).offset(-10)
            make.height.equalTo(35)
        }
        
        searchIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(18)
            make.width.height.equalTo(15)
        }
        
        textField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(searchIcon.snp.trailing).offset(15)
            make.trailing.equalTo(-15)
            make.height.equalTo(17)
        }
        
        cancelBtn.snp.makeConstraints { make in
            make.centerY.equalTo(searchContent.snp.centerY)
            make.trailing.equalTo(-10.5)
            make.width.height.equalTo(24)
        }
        
        tableView?.snp.makeConstraints { make in
            make.top.equalTo(searchContent.snp.bottom).offset(14)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(bottomBtn.snp.top)
        }
        
        bottomBtn.snp.makeConstraints { make in
            make.bottom.equalTo(-49 - safeAreaBt)
            make.leading.equalTo(30)
            make.trailing.equalTo(-30)
            make.height.equalTo(52)
        }
    }
    
    private func keyboardReturn(_ text: String) {
        page = 1
        mutateLoadSearchList(type: type, text: "", page: page, size: size)
    }
    
    private func updateBottomBtnState() {
        bottomBtn.isSelected = dataList.first(where: { $0.isSelected }) != nil
    }
    
    @objc private func tapSearchAction(sender: UITapGestureRecognizer) {
        textField.becomeFirstResponder()
    }
    
    private lazy var maskBgView: UIView = {
        let view = UIView()
        view.backgroundColor = .xf2
        return view
    }()
    
    private lazy var arcView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.gt.setCustomCoRadius([.layerMinXMinYCorner, .layerMaxXMinYCorner], cornerRadius: 16)
        return view
    }()
    
    private lazy var searchContent: UIView = {
        let view = UIView()
        view.backgroundColor = .xf2
        view.gt.setCornerRadius(8)
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
        text.font = UIFontReg(12)
        text.clearButtonMode = .whileEditing
        text.returnKeyType = .done
        text.keyboardType = .default
        text.delegate = self
        text.placeholder = "search".homeLocalizable()
        text.gt.setPlaceholderAttribute(font: UIFontReg(12), color: .hexStrToColor("#999999"))
        return text
    }()
    
    private lazy var cancelBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.image(.shareEditCancel)
        btn.gt.handleClick { [weak self] _ in
            guard let self = self else { return }
            self.textField.text = ""
            self.textField.resignFirstResponder()
            self.dataList.forEach({ $0.isSelected = false })
            self.tableView?.reloadData()
            self.updateBottomBtnState()
        }
        return btn
    }()
    
    private lazy var bottomBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("share".homeLocalizable(), for: .normal)
        btn.setTitleColor(.black.withAlphaComponent(0.5), for: .normal)
        btn.setTitleColor(.black.withAlphaComponent(0.5), for: .highlighted)
        btn.titleLabel?.font = UIFontSemibold(14)
        btn.setBackgroundImage(UIColor.hexStrToColor("#FFDA00", 0.5).transform(), for: .normal)
        btn.setBackgroundImage(UIColor.hexStrToColor("#FFDA00", 0.5).transform(), for: .highlighted)
        btn.setBackgroundImage(UIColor.appColor.transform(), for: .selected)
        btn.gt.setCornerRadius(8)
        btn.gt.handleClick { [weak self] _ in
            guard let self = self else { return }
            guard self.bottomBtn.isSelected else { return }
            let userIds = self.dataList
                .filter({ $0.isSelected })
                .map({ $0.id })
                .joined(separator: ",")
            self.mutateShare(type: self.type, id: self.id, userIds: userIds)
        }
        return btn
    }()
}

extension ShareSearchViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.gt.dequeueReusableCell(cellType: ShareSearchListCell.self, cellForRowAt: indexPath)
        cell.bind(model: dataList[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = dataList[indexPath.row]
        model.isSelected = !model.isSelected
        dataList[indexPath.row] = model
        self.tableView?.reloadData()
        self.updateBottomBtnState()
    }
    
}

extension ShareSearchViewController: UITextFieldDelegate {
    func endEditTextField(_ textField: UITextField) {
        textField.resignFirstResponder()
        textField.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let text = self.textField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        self.keyboardReturn(text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditTextField(textField)
        return true
    }
}

extension ShareSearchViewController {
    
    private func mutateLoadSearchList(type: ShareSearchType, text: String, page: Int, size: Int) {
        
        var params: [String: Any] = [:]
        var apiItem: APIItem?
        params["page.current"] = page
        params["page.size"] = size
        if type == .friend {
            apiItem = NetAPI.HomeAPI.friendList
            if !text.isEmpty {
                params["nickname"] = text
            }
        } else if type == .group {
            apiItem = NetAPI.HomeAPI.groupList
            params["type"] = 1
            if !text.isEmpty {
                params["context"] = text
            }
        }
        apiItem?.reqToListHandler(parameters: params, model: ShareSearchListModel.self) {[weak self] list, _ in
            // single(.success(.loadSearchListResult(list)))
            self?.dataList = list
            self?.tableView?.reloadData()
            self?.setupEmptyView(list.count)
        } failed: { error in
            print("error: \(error)")
        }
    }
    
    private func mutateShare(type: ShareSearchType, id: Int, userIds: String) {
        
        var params: [String: Any] = [:]
        params["taskId"] = id
        if type == .friend {
            params["toUserIds"] = userIds
        } else if type == .group {
            params["groupIds"] = userIds
        }
        
        NetAPI.HomeAPI.shareTask.reqToJsonHandler(parameters: params) { _ in
            
            FlyerLibHelper.log(.sendMessageClick)
            ToastHud.showToastAction(message: "shareSuccessful".homeLocalizable())
        } failed: { error in
            print("error: \(error)")
        }
    }
    
}
