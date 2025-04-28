//
//  TaskShareSheet.swift
//  Golaa
//
//  Created by duke on 2024/5/28.
//

import UIKit

enum ShareSearchType {
    case friend
    case group
}

enum TaskShareType {
    case link
    case friend
    case group
    case more
}

class TaskShareModel: NSObject {
    
    var type: TaskShareType = .more
    var icon = ""
    var name = ""
    
    init(type: TaskShareType, icon: String, name: String) {
        self.type = type
        self.icon = icon
        self.name = name
    }
}

class TaskShareCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildUI() {
        contentView.addSubview(button)
        button.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    var model: TaskShareModel?
    func bind(model: TaskShareModel) {
        self.model = model
        
        button.setTitle(model.name, for: .normal)
        button.setImage(UIImage(named: model.icon), for: .normal)
        button.gt.setImageTitlePos(.imgTop, spacing: 7)
    }
    
    private lazy var button: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFontReg(12)
        btn.isEnabled = false
        return btn
    }()
}

class TaskShareSheet: AlertBaseView {
  
    private lazy var dataList = [           
        TaskShareModel(type: .link, icon: "share_link", name: "links".homeLocalizable()),
        TaskShareModel(type: .friend, icon: "share_friend", name: "myFriends".homeLocalizable()),
        TaskShareModel(type: .group, icon: "share_group", name: "myGroups".homeLocalizable()),
        TaskShareModel(type: .more, icon: "share_more", name: "more".msgLocalizable())
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildUI()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildUI() {
        addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(closeBtn)
        contentView.addSubview(collectionView)
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(screW)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(19)
            make.centerX.equalToSuperview()
        }
        
        closeBtn.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.trailing.equalTo(-12)
            make.width.height.equalTo(20)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(33)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(-27 - safeAreaTp)
            make.height.equalTo(0)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.snp.updateConstraints { make in
            let height = collectionView.collectionViewLayout.collectionViewContentSize.height
            make.height.equalTo(height)
        }
    }
    
    private var id = 0
    private var link = ""
    func show(id: Int, link: String) {
        self.id = id
        self.link = link
        show(position: .bottom)
    }
    
    override func touchDismissEvent() {
        super.touchDismissEvent()
        FlyerLibHelper.log(.shareCancelClick)
    }
    
    private func bind() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.gt.setCustomCoRadius([.layerMinXMinYCorner, .layerMaxXMinYCorner], cornerRadius: 16)
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let lab = UILabel()
        lab.font = UIFontSemibold(15)
        lab.textColor = .black
        lab.text = "shareTo".homeLocalizable()
        return lab
    }()
    
    private lazy var closeBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.image(.payClose)
        btn.gt.handleClick { [weak self] _ in
            self?.dismissView()
        }
        return btn
    }()
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let lay = UICollectionViewFlowLayout()
        lay.minimumLineSpacing = 29
        lay.minimumInteritemSpacing = 0
        lay.scrollDirection = .vertical
        lay.itemSize = .init(width: screW/4.0, height: 74)
        return lay
    }()
    
    private lazy var collectionView: UICollectionView = {
        let col = UICollectionView(frame: .zero, collectionViewLayout: layout)
        col.showsVerticalScrollIndicator = false
        col.showsHorizontalScrollIndicator = false
        col.gt.register(cellClass: TaskShareCell.self)
        col.delegate = self
        col.dataSource = self
        return col
    }()
}

extension TaskShareSheet: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.gt.dequeueReusableCell(cellType: TaskShareCell.self, cellForRowAt: indexPath)
        cell.bind(model: dataList[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dismissView()
        let model = self.dataList[indexPath.row]
        switch model.type {
        case .link:
            let pboard = UIPasteboard.general
            pboard.string = link
            ToastHud.showToastAction(message: "copySuccessful".homeLocalizable())
            // 1 Facebook；2 Tik Tok；3 Instagram；5 链接分享；6 我的好友；7 我的群组
            FlyerLibHelper.log(.shareToTarget, source: 5)
        case .friend:
            var params: [String: Any] = [:]
            params["type"] = ShareSearchType.friend
            params["id"] = id
            params["link"] = link
            RoutinStore.push(.shareTask, param: params)
            FlyerLibHelper.log(.shareToTarget, source: 6)
        case .group:
            var params: [String: Any] = [:]
            params["type"] = ShareSearchType.group
            params["id"] = id
            params["link"] = link
            RoutinStore.push(.shareTask, param: params)
            FlyerLibHelper.log(.shareToTarget, source: 7)
        case .more:
            let activityController = UIActivityViewController(activityItems: [link], applicationActivities: nil)
            activityController.completionWithItemsHandler = { activityType, flag, _, error in
                if flag {
                    if let activityType = activityType {
                        switch activityType {
                        case .copyToPasteboard:
                            FlyerLibHelper.log(.shareToTarget, source: 5)
                        case .postToFacebook:
                            FlyerLibHelper.log(.shareToTarget, source: 1)
                        default:
                            break
                        }
                    }
                    debugPrint("分享成功")
                } else {
                    debugPrint("分享失败：\(error?.localizedDescription ?? "")")
                }
            }
            UIViewController.gt.topCurController()?.present(activityController, animated: true, completion: nil)
        }
    }
}
