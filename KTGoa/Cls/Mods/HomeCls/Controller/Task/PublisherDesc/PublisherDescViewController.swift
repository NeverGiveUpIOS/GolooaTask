//
//  PublisherDescViewController.swift
//  Golaa
//
//  Created by duke on 2024/5/21.
//

import UIKit

class PublisherDescViewController: BasTableViewVC {
    
    var userId: String?
    var model: PublisherDescModel?
    
    override func routerParam(param: Any?, router: RoutinRouter?) {
        if let userId = param as? String {
            self.userId = userId
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        mutateLoadPublishDesc()
    }
    
    
    override func loadListData() {
        super.loadListData()
        mutateLoadPublishDesc()
    }
    
    lazy var bgView: UIImageView = {
        let img = UIImageView()
        img.image = .fberBg
        return img
    }()
    
    lazy var arcView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.gt.setCustomCoRadius([.layerMinXMinYCorner, .layerMaxXMinYCorner], cornerRadius: 16)
        return view
    }()
    
    lazy var avatarView: UIImageView = {
        let view = UIImageView()
        view.gt.setCornerRadius(50)
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.font = .oswaldDemiBold(15)
        view.textColor = .black
        view.numberOfLines = 0
        return view
    }()
    
    lazy var idLabel: UILabel = {
        let view = UILabel()
        view.font = UIFontReg(12)
        view.textColor = .hexStrToColor("#999999")
        return view
    }()
    
    lazy var chatBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.image(.taskChat)
        btn.gt.handleClick { [weak self] _ in
            guard let user = self?.model?.extra.user else { return }
            self?.mutateConsultResult(user.id)
            FlyerLibHelper.log(.consultClick, values: ["source": 2])
        }
        return btn
    }()
    
    lazy var editBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.image(.fberEdit)
        btn.isHidden = true
        btn.gt.handleClick { _ in
            RoutinStore.push(.individualInfo)
        }
        return btn
    }()
    
    lazy var rzIcon: UIImageView = {
        let img = UIImageView()
        img.image = .fberRz
        return img
    }()
    
    lazy var pubNameLabel: UILabel = {
        let lab = UILabel()
        lab.font = UIFontReg(12)
        lab.textColor = .hexStrToColor("#666666")
        return lab
    }()
    
    lazy var introIcon: UIImageView = {
        let img = UIImageView()
        img.image = .fberIntro
        return img
    }()
    
    lazy var introLabel: UILabel = {
        let lab = UILabel()
        lab.font = UIFontReg(12)
        lab.textColor = .hexStrToColor("#666666")
        return lab
    }()
    
    lazy var titleLabel: UILabel = {
        let lab = UILabel()
        lab.font = UIFontSemibold(14)
        lab.textColor = .black
        return lab
    }()
    
    lazy var pubBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.image(.fbDescFb)
        btn.isHidden = true
        btn.gt.handleClick { [weak self] _ in
            self?.mutatePublishCheck()
            FlyerLibHelper.log(.toPublishClick)
        }
        return btn
    }()
}


extension PublisherDescViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.list.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.gt.dequeueReusableCell(cellType: HomeListCell.self, cellForRowAt: indexPath)
        if let model = model?.list[indexPath.row] {
            cell.bind(model)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let model = model?.list[indexPath.row] else {
            return
        }
        RoutinStore.push(.taskDesc, param: ["id": model.id, "source": TaskDescFromSource.publish.rawValue])
    }
    
}
