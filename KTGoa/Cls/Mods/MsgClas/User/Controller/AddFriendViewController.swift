//
//  AddFriendViewController.swift
//  Golaa
//
//  Created by chenkaisong on 2024/5/20.
//

import UIKit

class AddFriendViewController: BasTableViewVC {
    
    var type: SessionType = .other
    var searctText = ""
    lazy var searchg = [NIMGroupModel]()
    lazy var searchu = [GUsrInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navTitle(type == .other ? "addFriends".msgLocalizable() : "")
        setupSubviews()
        searchReq(searctText)
        setupEmptyView(0, img: .chatSearchEmpty)
    }
    
    private lazy var searchView: MsgAddFriendSearchView = {
        let view = MsgAddFriendSearchView()
        view.setupLeftView()
        view.callBlock = { [weak self] text, isClear in
            if isClear {
                self?.searchu.removeAll()
                self?.tableView?.reloadData()
                self?.setupEmptyView(0, img: .chatSearchEmpty)
                return
            }
            self?.searchReq(text)
        }
        return view
    }()
    
    private func setupSubviews() {
        
        if type == .other {
            view.addSubview(searchView)
            searchView.snp.makeConstraints { make in
                make.leading.trailing.equalTo(0)
                make.top.equalTo(naviH)
            }
        }
        
        tableView?.tableHeaderView = UIView(frame: .init(x: 0, y: 0, width: 10, height: 10))
        tableView?.gt.register(cellClass: MsgFriendCell.self)
        tableView?.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            if type == .other {
                make.top.equalTo(searchView.snp.bottom)
            } else {
                make.top.equalTo(0)
            }
        }
        
        if type == .groupChat {
            setupHeadRefresh()
            setupFootRefresh()
        }
    }
    
    func searchReq(_ text: String) {
        searctText = text
        if type == .groupChat {
            searchGroup(text)
            return
        }
        searchUser(text)
    }
    
    override func loadListData() {
        super.loadListData()
        searchReq(searctText)
    }
    
}

extension AddFriendViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return type == .groupChat ? searchg.count : searchu.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.gt.dequeueReusableCell(cellType: MsgFriendCell.self, cellForRowAt: indexPath)
        type == .groupChat ? cell.setupGroupInfo(searchg[indexPath.row]) : cell.setupAddUserInfo(searchu[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if type == .groupChat {
            let group = searchg[indexPath.row]
            ToastHud.showToastAction()
            NIMSDK.shared().teamManager.fetchTeamMembers(fromServer: group.teamId) { error, _ in
                ToastHud.hiddenToastAction()
                if error == nil {
                    RoutinStore.push(.groupChat, param: group.teamId)
                    FlyerLibHelper.log(.enterGroupTalkScreen, source: "0")
                    return
                }
                RoutinStore.push(.groupInfo, param: group.id)
            }
            return
        }
        
        let model = searchu[indexPath.row]
//        if model.isPublish {
//            RoutinStore.push(.publisherDesc, param: model.id)
//        } else {
            RoutinStore.push(.ordinaryUserInfo, param: model.id)
//        }
    }
}

// MARK: - ReqData
extension AddFriendViewController {
    
    private func searchUser(_ text: String) {
        if text.count <= 0 {
            searchg.removeAll()
            tableView?.reloadData()
            setupEmptyView(0, img: .chatSearchEmpty)
            return
        }
        
        MessageReq.userSearch(text) { [weak self] list in
            guard let self = self else { return }
            
            self.searchu = list.count > 0 ? list  : []
            self.searchu = self.searchu.filterDuplicates({
                $0.id
            })
            self.setupEmptyView(list.count, img: .chatSearchEmpty)
            self.tableView?.reloadData()
        }
    }
    
    private func searchGroup(_ text: String) {
        
        let dict: [String: Any] = [
            "type": 0,
            "context": text,
            "page.current": page,
            "page.size": size
        ]
        
        if text.count <= 0 {
            searchg.removeAll()
            tableView?.reloadData()
            setupEmptyView(0, img: .chatSearchEmpty)
            self.endRefreshAndReloadData(0, 0)
            return
        }
        
        MessageReq.groupList(dict) { [weak self] list in
            guard let self = self else { return }
            
            if page == 1 {
                self.searchg.removeAll()
            }
            
            self.searchg.appends(list)
            self.setupEmptyView(self.searchg.count, img: .chatSearchEmpty)
            self.endRefreshAndReloadData(list.count, self.searchg.count)

        } failCom: { [weak self] in
            self?.setupEmptyView(0, img: .chatSearchEmpty)
            self?.endRefreshAndReloadData(0, 0)
        }
    }
    
}

extension AddFriendViewController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        view
    }
}
