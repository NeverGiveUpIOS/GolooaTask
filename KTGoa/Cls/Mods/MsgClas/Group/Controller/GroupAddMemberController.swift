//
//  GroupAddMemberController.swift
//  Golaa
//
//  Created by xiaoxuhui on 2024/5/24.
//

import UIKit

class GroupAddMemberController: BasTableViewVC {
        
    var groupId: String = ""
    
    lazy var dataList = [GUsrInfo]()
    
    override func routerParam(param: Any?, router: RoutinRouter?) {
        if let id = param as? String {
            self.groupId = id
        } else if let param = param as? [String: Any], let id = param["groupId"] as? String {
            self.groupId = id
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navTitle("邀请好友入群".msgLocalizable())
        setupUI()
        setupEmptyView(0)
    }
    
    func setupUI() {
        view.addSubview(searchContent)
        view.addSubview(inviteBtn)
    
        searchContent.addSubview(searchIcon)
        searchContent.addSubview(textField)

        tableView?.rowHeight = 80
        tableView?.gt.register(cellClass: GroupMemberAddCell.self)
        
        searchContent.snp.makeConstraints { make in
            make.height.equalTo(38)
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.top.equalTo(naviH)
        }
        
        searchIcon.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.leading.equalTo(15)
            make.centerY.equalToSuperview()
        }
        
        textField.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.trailing.equalTo(-15)
            make.centerY.equalToSuperview()
            make.leading.equalTo(searchIcon.snp.trailing).offset(8)
        }
        
        tableView?.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(searchContent.snp.bottom)
            make.bottom.equalTo(inviteBtn.snp.top).offset(-10)
        }
        
        inviteBtn.snp.makeConstraints { make in
            make.height.equalTo(52)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.bottom.equalTo(-10 - safeAreaBt)
        }
    }


    // MARK: -
    // MARK: Lazy
    private lazy var searchContent: UIView = {
        let view = UIView()
        view.gt.setCornerRadius(8)
        view.backgroundColor = .xf2
        return view
    }()
    
    private lazy var searchIcon: UIImageView = {
        let img =  UIImageView()
        img.image = .searchIcon
        img.isUserInteractionEnabled = true
        img.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(searchClick)))
        return img
    }()
    
    private lazy var textField: UITextField = {
        let text = UITextField()
        text.textColor = .black
        text.tintColor = .appColor
        text.returnKeyType = .done
        text.font = UIFontReg(13)
        text.keyboardType = .default
        text.clearButtonMode = .whileEditing
        text.delegate = self
        text.placeholder = "searchNicknameuserId".msgLocalizable()
        return text
    }()
    
    private lazy var inviteBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.gt.setCornerRadius(8)
        btn.textColor(.black)
        btn.font(UIFontSemibold(16))
        btn.backgroundColor = .appColor.alpha(0.5)
        btn.isUserInteractionEnabled = false
        btn.title("inviteToJoinGroup".msgLocalizable())
        return btn
    }()
    
    private lazy var searchBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(.searchTaskBtn, for: .normal)
        return btn
    }()
    
    /// 搜索
    @objc func searchClick(sender: UIButton) {
        endEditTextField()
    }

}

extension GroupAddMemberController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.gt.dequeueReusableCell(cellType: GroupMemberAddCell.self, cellForRowAt: indexPath)
        if dataList.count > 0 {
            cell.bind(model: dataList[indexPath.row], ids: [])
        }
        cell.selectedBlock = { [weak self] model in
            self?.selRow(indexPath.row, model)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        RoutinStore.push(.ordinaryUserInfo, param: dataList[indexPath.row].id)
    }
    
}

extension GroupAddMemberController {
    
    private func selRow(_ row: NSInteger, _ model: GUsrInfo) {
        model.isSel = true
        dataList[row] = model
        tableView?.reloadData()
        
        let selList = dataList.map({$0.isSel}).filter{$0 == true}
        inviteBtn.backgroundColor =  selList.count > 0 ? .appColor : .appColor.alpha(0.5)
        inviteBtn.isUserInteractionEnabled = selList.count > 0
    }
    
    private func searchUser(_ text: String) {
        UserReq.search(text) { [weak self] models, error in
            if let models = models {
                self?.dataList = models
                self?.tableView?.reloadData()
                self?.setupEmptyView(models.count)
            } else if let _ = error {
                self?.dataList.removeAll()
                self?.tableView?.reloadData()
                self?.setupEmptyView(0)
            }
        }
    }
}

extension GroupAddMemberController: UITextFieldDelegate {
    
    func endEditTextField() {
        textField.resignFirstResponder()
        textField.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        searchUser(textField.text ?? "")
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        dataList.removeAll()
        tableView?.reloadData()
        setupEmptyView(0)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let text = (currentText as NSString).replacingCharacters(in: range, with: string)
        if text.count <= 0 {
            dataList.removeAll()
            tableView?.reloadData()
            setupEmptyView(0)
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditTextField()
        return true
    }
}
