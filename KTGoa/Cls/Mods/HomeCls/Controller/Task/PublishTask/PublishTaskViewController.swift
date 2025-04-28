//
//  PublishTaskViewController.swift
//  Golaa
//
//  Created by duke on 2024/5/15.
//

import UIKit
import IQKeyboardManagerSwift

class PublishTaskViewController: BasClasVC {
    var id: Int?
    
    override func routerParam(param: Any?, router: RoutinRouter?) {
        if let id = param as? Int {
            self.id = id
            mutateLoadTaskDesc(id: id)
        } else if let id = Int(param as? String ?? "") {
            self.id = id
        }
    }
    
    var isEditStep = false
    let namePlaceholder = "pleaseEnterTaskName".homeLocalizable()
    let linkPlaceholder = "veryImportantPleaseEnterTheDownload".homeLocalizable()
    let registPlaceholder = "setThePriceForThisTask".homeLocalizable()
    let explainPlaceholder = "enterTaskInstructions".homeLocalizable()
    let timeStartPlaceholder = "startDate".homeLocalizable()
    let timeEndPlaceholder = "endDate".homeLocalizable()
    
    var currentStep: TaskStepModel?
    var model = TaskPublishModel()
    
    let currentDateCom: DateComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildUI()
        subViewsHandle()
        configStepDataSource()
        addTaskNoti()
        if let taskId = self.id {
            mutateLoadTaskDesc(id: taskId)
        }
        
    }
    
    deinit {
        removeNotiObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = true
    }
    
    private func configStepDataSource() {
        let edit = TaskStepModel()
        edit.type = .edit
        let add =  TaskStepModel()
        add.type = .add
        stepView.dataSource = [edit, add]
    }
    
    func keyboardReturn(_ text: String) {
        currentStep?.explain = text
        stepView.reloadData()
        updateBottomBtnState()
    }
    
    @objc private func tapEndEditAction(sender: UITapGestureRecognizer) {
        editToolTF.resignFirstResponder()
    }
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.isScrollEnabled = true
        if #available(iOS 13.0, *) {
            view.automaticallyAdjustsScrollIndicatorInsets = false
        } else {
            view.contentInsetAdjustmentBehavior = .never
        }
        return view
    }()
    
    lazy var bgView: UIImageView = {
        let img = UIImageView()
        img.image = .taskFbBg
        return img
    }()
    
    lazy var titleLabel: UILabel = {
        let lab = UILabel()
        lab.font = .oswaldDemiBold(24)
        lab.textColor = .black
        lab.text = "postTask".homeLocalizable()
        lab.numberOfLines = 0
        return lab
    }()
    
    lazy var arcView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.gt.setCustomCoRadius([.layerMinXMinYCorner, .layerMaxXMinYCorner], cornerRadius: 16)
        return view
    }()
    
    lazy var nameTitle: UILabel = {
        let lab = UILabel()
        lab.font = UIFontSemibold(14)
        lab.textColor = .black
        lab.text = "promotionTaskName".homeLocalizable()
        return lab
    }()
    
    lazy var nameTV: UITextView = {
        let text = UITextView()
        text.font = UIFontReg(12)
        text.textColor = .black
        text.keyboardType = .default
        text.gt.setCornerRadius(10)
        text.backgroundColor = .xf2
        text.textContainerInset = .init(top: 15, left: 15, bottom: 15, right: 15)
        text.gt_placeholder = namePlaceholder
        text.gt_placeholderColor = .hexStrToColor("#999999")
        text.delegate = self
        return text
    }()
    
    lazy var linkTitle: UILabel = {
        let lab = UILabel()
        lab.font = UIFontSemibold(14)
        lab.textColor = .black
        lab.text = "promotionLink".homeLocalizable()
        return lab
    }()
    
    lazy var linkTV: UITextView = {
        let text = UITextView()
        text.font = UIFontReg(12)
        text.textColor = .hexStrToColor("#FF5722")
        text.keyboardType = .emailAddress
        text.gt.setCornerRadius(10)
        text.backgroundColor = .xf2
        text.textContainerInset = .init(top: 15, left: 15, bottom: 15, right: 15)
        text.gt_placeholder = linkPlaceholder
        text.gt_placeholderColor = .hexStrToColor("#999999")
        text.delegate = self
        return text
    }()
    
    lazy var imageTitle: UILabel = {
        let lab = UILabel()
        lab.font = UIFontSemibold(14)
        lab.textColor = .black
        lab.text = "taskLogo".homeLocalizable()
        return lab
    }()
    
    lazy var addImgView: CommentUpdateImgView = {
        let view = CommentUpdateImgView()
        view.tapAddPhotoBlock = { [weak self] image in
            guard let self = self, let image = image as? UIImage else { return }
            self.model.logo = image
            self.updateBottomBtnState()
        }
        view.tapImageBlock = { [weak self] in
            guard let self = self else { return }
            if let logo = self.model.logo {
                PhotoBroView.showWithImages(nil, images: [logo])
            } else if !self.model.cover.isEmpty {
                PhotoBroView.showWithImages([self.model.cover], images: nil)
            }
        }
        view.clearBlock = { [weak self] in
            guard let self = self else { return }
            self.model.logo = nil
            self.updateBottomBtnState()
        }
        return view
    }()
    
    lazy var registTitle: UILabel = {
        let lab = UILabel()
        lab.font = UIFontSemibold(14)
        lab.textColor = .black
        lab.text = "pricePerRegistrationTask".homeLocalizable()
        return lab
    }()
    
    lazy var registContent: UIView = {
        let view = UIView()
        view.backgroundColor = .xf2
        view.gt.setCornerRadius(8)
        return view
    }()
    
    lazy var registTF: UITextField = {
        let text = UITextField()
        text.font = UIFontReg(12)
        text.textColor = .hexStrToColor("#FF5722")
        text.placeholder = registPlaceholder
        text.gt.setPlaceholderAttribute(font: UIFontReg(12), color: .hexStrToColor("#999999"))
        text.textAlignment = .center
        text.keyboardType = .numbersAndPunctuation
        text.delegate = self
        return text
    }()
    
    lazy var explainTitle: UILabel = {
        let lab = UILabel()
        lab.font = UIFontSemibold(14)
        lab.textColor = .black
        lab.text = "taskDescription".homeLocalizable()
        return lab
    }()
    
    /// 任务说明
    lazy var explainTV: UITextView = {
        let text = UITextView()
        text.font = UIFontReg(12)
        text.textColor = .black
        text.gt.setCornerRadius(10)
        text.backgroundColor = .xf2
        text.keyboardType = .default
        text.textContainerInset = .init(top: 15, left: 15, bottom: 15, right: 15)
        text.gt_placeholder = explainPlaceholder
        text.gt_placeholderColor = .hexStrToColor("#999999")
        text.delegate = self
        return text
    }()
    
    lazy var timeTitle: UILabel = {
        let lab = UILabel()
        lab.font = UIFontSemibold(14)
        lab.textColor = .black
        lab.text = "setTaskDuration".homeLocalizable()
        return lab
    }()
    
    lazy var timeContent: UIView = {
        let view = UIView()
        view.backgroundColor = .xf2
        view.gt.setCornerRadius(8)
        return view
    }()
    
    lazy var timeStartBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle(timeStartPlaceholder, for: .normal)
        btn.setTitleColor(.hexStrToColor("#999999"), for: .normal)
        btn.setTitleColor(.black, for: .selected)
        btn.titleLabel?.font = UIFontReg(12)
        btn.addTarget(self, action: #selector(clickTimeStartBtn), for: .touchUpInside)
        return btn
    }()
    
    lazy var timeSeparator: UILabel = {
        let lab = UILabel()
        lab.text = " - "
        lab.font = UIFontReg(12)
        lab.textColor = .hexStrToColor("#999999")
        return lab
    }()
    
    lazy var timeEndBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle(timeEndPlaceholder, for: .normal)
        btn.setTitleColor(.hexStrToColor("#999999"), for: .normal)
        btn.setTitleColor(.black, for: .selected)
        btn.titleLabel?.font = UIFontReg(12)
        btn.addTarget(self, action: #selector(clickTimeEndBtn), for: .touchUpInside)
        return btn
    }()
    
    lazy var stepTitle: UILabel = {
        let lab = UILabel()
        lab.font = UIFontSemibold(14)
        lab.textColor = .black
        lab.text = "setTaskStepsMaxXxxSteps".homeLocalizable()
        return lab
    }()
    
    lazy var stepView = TaskStepView()
    
    lazy var maskBg: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.5)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapEndEditAction)))
        view.isHidden = true
        view.isUserInteractionEnabled = true
        return view
    }()
    
    /// 步骤
    lazy var editToolTF: UITextField = {
        let text = UITextField()
        text.textColor = .black
        text.font = UIFontReg(12)
        text.clearButtonMode = .whileEditing
        text.keyboardType = .default
        text.delegate = self
        return text
    }()
    
    lazy var editToolView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.addSubview(editToolTF)
        editToolTF.snp.makeConstraints { make in
            make.leading.equalTo(15)
            make.trailing.equalTo(-80)
            make.centerY.equalToSuperview()
            make.height.equalTo(28)
        }
        
        let btn = UIButton(type: .custom)
        btn.setTitle("confirm".homeLocalizable(), for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFontReg(12)
        btn.gt.setCornerRadius(6)
        btn.backgroundColor = .appColor
        btn.gt.handleClick { [weak self] button in
            self?.editToolTF.resignFirstResponder()
        }
        view.addSubview(btn)
        btn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(-12)
            make.width.equalTo(65)
            make.height.equalTo(35)
        }
        return view
    }()
    
    lazy var bottomBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("postTask".homeLocalizable(), for: .normal)
        btn.setTitleColor(.black.withAlphaComponent(0.5), for: .normal)
        btn.setTitleColor(.black.withAlphaComponent(0.5), for: .highlighted)
        btn.setTitleColor(.black, for: .selected)
        btn.titleLabel?.font = UIFontSemibold(14)
        btn.setBackgroundImage(UIColorHex("#FFDA00", alpha: 0.5).transform(), for: .normal)
        btn.setBackgroundImage(UIColorHex("#FFDA00", alpha: 0.5).transform(), for: .highlighted)
        btn.setBackgroundImage(UIColor.appColor.transform(), for: .selected)
        btn.gt.setCornerRadius(8)
        btn.gt.preventDoubleHit(5)
        btn.gt.handleClick { [weak self] _ in
            guard let self = self else {
                return
            }
            self.model.stepArr = self.stepView.dataSource
            self.mutatePublishResult(self.model)
        }
        return btn
    }()
}
