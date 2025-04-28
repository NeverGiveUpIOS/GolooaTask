//
//  TaskDescViewController.swift
//  Golaa
//
//  Created by duke on 2024/5/20.
//

import UIKit

enum TaskDescFromSource: Int {
    case home = 1 // 来自于主页
    case publish = 2 // 来自于发布者详情
    case friendShare = 3 // 来自于好友分享
    case groupShare = 4 // 来自于群分享
    case other = 5 // 来自于其它
}

class TaskDescViewController: BasClasVC {
    
    var id: String = ""
    var source: TaskDescFromSource = .other
    var descModel: TaskDescModel?
    var model: TaskDescModel?
    
    override func routerParam(param: Any?, router: RoutinRouter?) {
        if let dict = param as? [String: Any] { // 多个参数
            if let id = dict["id"] as? Int {
                self.id = "\(id)"
            } else if let id = dict["id"] as? String {
                self.id = id
            }
            
            if let value = dict["source"] as? Int,
               let source = TaskDescFromSource(rawValue: value) {
                self.source = source
            } else if let value = dict["source"] as? String,
                      let source = TaskDescFromSource(rawValue: Int(value) ?? 0) {
                self.source = source
            }
        } else if let id = param as? Int { // 一个参数, 默认传 id
            self.id = "\(id)"
        } else if let id = param as? String { // 一个参数, 默认传 id
            self.id = id
        }
    }
    
    var isDisappear = false
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildUI()
        FlyerLibHelper.log(.enterTaskDetailScreen, values: ["source": source.rawValue])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mutateLoadTaskDesc(id)
        isDisappear = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopTimer()
        isDisappear = true
    }
    
    func startTimer() {
        guard timer == nil, !isDisappear else { return }
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] _ in
            guard let self = self else { return }
            guard let model = self.model else { return }
            model.surSec -= 1
            if model.surSec <= 0 {
                self.stopTimer()
            }
            self.bind(model)
        })
        if let timer = timer {
            RunLoop.main.add(timer, forMode: .common)
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    
    override func rightItemClick() {
        super.rightItemClick()
        guard let model = model else {
            return
        }
        TaskShareSheet().show(id: model.id, link: model.traLink)
        let from = (LoginTl.shared.usrId == model.userId) ? 1 : (LoginTl.shared.userInfo?.isAgent ?? false ? 3 : 2)
        FlyerLibHelper.log(.shareTaskClick, values: ["from": from])
    }
    
    @objc  func tapPubUserAction(sender: UITapGestureRecognizer) {
        if GlobalHelper.shared.inEndGid { return }
        guard let model = model else { return }
        RoutinStore.push(.publisherDesc, param: model.userId)
    }
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.isScrollEnabled = true
        view.backgroundColor = .clear
        if #available(iOS 13.0, *) {
            view.automaticallyAdjustsScrollIndicatorInsets = false
        } else {
            view.contentInsetAdjustmentBehavior = .never
        }
        return view
    }()
    
    lazy var logoView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.gt.setCornerRadius(6)
        return img
    }()
    
    lazy var nameLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = .black
        lab.font = UIFontSemibold(14)
        lab.numberOfLines = 2
        return lab
    }()
    
    lazy var priceLabel: UILabel = {
        let lab = UILabel()
        lab.font = .oswaldDemiBold(16)
        lab.textColor = .hexStrToColor("#FF5722")
        return lab
    }()
    
    lazy var numLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = .hexStrToColor("#999999")
        lab.font = UIFontReg(12)
        return lab
    }()
    
    lazy var danbaoLabel: HomeListCeltagView = {
        let view = HomeListCeltagView()
        view.backgroundColor = .hexStrToColor("#FFF4CF")
        view.gt.setCornerRadius(4)
        view.tipImg.image = .homeRz
        view.tagContent.text = "\("secured".homeLocalizable())"
        view.isHidden = true
        return view
    }()
    
    lazy var pubUserView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        let icon = UIImageView()
        icon.contentMode = .scaleAspectFill
        icon.gt.setCornerRadius(8.5)
        icon.tag = 100
        view.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
            make.width.height.equalTo(17)
        }
        let label = UILabel()
        label.textColor = .hexStrToColor("#5B6FA3")
        label.font = UIFontReg(12)
        label.tag = 101
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.equalTo(icon.snp.trailing).offset(5)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapPubUserAction)))
        return view
    }()
    
    lazy var chatBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.image(.taskChat)
        btn.isHidden = true
        btn.gt.handleClick { [weak self] _ in
            FlyerLibHelper.log(.consultClick, values: ["source": 1])
            self?.mutateConsultResult()
        }
        return btn
    }()
    
    lazy var arcView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.gt.setCustomCoRadius([.layerMinXMinYCorner, .layerMaxXMinYCorner], cornerRadius: 16)
        return view
    }()
    
    lazy var introTitle: UILabel = {
        let lab = UILabel()
        lab.textColor = .black
        lab.font = UIFontSemibold(14)
        lab.text = "taskDescription".homeLocalizable()
        return lab
    }()
    
    lazy var idLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = .hexStrToColor("#999999")
        lab.font = UIFontReg(12)
        return lab
    }()
    
    lazy var idCopyBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.image(.taskIdCopy)
        btn.gt.handleClick { [weak self] _  in
            guard let self = self else { return }
            guard let model = self.model else { return }
            UIPasteboard.general.string = "\(model.id)"
            ToastHud.showToastAction(message: "copySuccessful".homeLocalizable())
        }
        return btn
    }()
    
    lazy var introLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = .hexStrToColor("#666666")
        lab.font = UIFontReg(14)
        lab.numberOfLines = 0
        return lab
    }()
    
    lazy var linkTitle: UILabel = {
        let lab = UILabel()
        lab.textColor = .black
        lab.font = UIFontSemibold(14)
        lab.text = "myPromotionLink".homeLocalizable()
        lab.isHidden = true
        return lab
    }()
    
    lazy var linkContent: UIView = {
        let view = UIView()
        view.backgroundColor = .xf2
        view.gt.setCornerRadius(8)
        view.isHidden = true
        return view
    }()
    
    lazy var linkLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = .hexStrToColor("#5B6FA3")
        lab.font = UIFontReg(12)
        lab.numberOfLines = 0
        return lab
    }()
    
    lazy var linkCopyBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.image(.taskIdCopy)
        btn.gt.handleClick { [weak self] _ in
            guard let self = self else { return }
            guard let model = model else { return }
            UIPasteboard.general.string = model.traLink
            ToastHud.showToastAction(message: "copySuccessful".homeLocalizable())
        }
        return btn
    }()
    
    lazy var stepTitle: UILabel = {
        let lab = UILabel()
        lab.textColor = .black
        lab.font = UIFontSemibold(14)
        lab.text = "taskSteps".homeLocalizable()
        return lab
    }()
    
    lazy var stepView = TaskStepView()
    
    lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var bottomBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFontSemibold(14)
        btn.setBackgroundImage(UIColor.appColor.transform(), for: .normal)
        btn.setBackgroundImage(UIColor.hexStrToColor("#CBCBCB").transform(), for: .highlighted)
        btn.setBackgroundImage(UIColor.hexStrToColor("#CBCBCB").transform(), for: .selected)
        btn.gt.setCornerRadius(8)
        btn.gt.handleClick { [weak self] _ in
            guard let model = self?.model else {
                return
            }
            
            self?.mutateReceiveTask(model: model)
        }
        return btn
    }()
    
    lazy var bottomDescBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.titleLabel?.font = UIFontReg(12)
        btn.titleLabel?.textAlignment = .center
        btn.setTitleColor(.hexStrToColor("#999999"), for: .normal)
        btn.isEnabled = false
        return btn
    }()
}

