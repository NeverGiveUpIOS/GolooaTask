//
//  ChorePublishAppealController.swift
//  Golaa
//
//  Created by Cb on 2024/5/21.
//

import Foundation

class ChorePublishAppealController: BasClasVC {
    
    private var id = 0
    private var date = ""
    lazy var model = HomeListModel()
    
    override func routerParam(param: Any?, router: RoutinRouter?) {
        if let param = param as? [String: Any],
           let id = param["taskId"] as? Int,
           let date = param["date"] as? String {
            self.id = id
            self.date = date
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configViews()
        configActions()
        configData()
        mutationLoadDataResult()
    }
    
    private func configViews() {
        navTitle("submitAppeal".meLocalizable())
        navBagColor(.xf2)
        view.backgroundColor = UIColor.xf2
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.width.equalTo(screW)
            make.edges.equalToSuperview()
        }
        
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.width.equalTo(screW - 30)
        }
        
        stackView.addArrangedSubview(topView)
        topView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(42)
        }
        
        topView.addSubview(leftLabel)
        leftLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        
        topView.addSubview(rightIcon)
        rightIcon.snp.makeConstraints { make in
            make.trailing.centerY.equalToSuperview()
            make.width.height.equalTo(14)
        }
        
        topView.addSubview(rightLabel)
        rightLabel.snp.makeConstraints { make in
            make.trailing.equalTo(rightIcon.snp.leading).offset(-4)
            make.centerY.equalToSuperview()
        }
        
        stackView.setCustomSpacing(2, after: topView)
        
        stackView.addArrangedSubview(detailView)
        detailView.snp.makeConstraints { make in
            make.height.equalTo(187)
            make.width.equalToSuperview()
        }
        
        let middleView = UIView()
        middleView.backgroundColor = .white
        middleView.gt.setCornerRadius(8)
        stackView.addArrangedSubview(middleView)
        middleView.snp.makeConstraints { make in
            make.height.equalTo(164)
            make.width.equalToSuperview()
        }
        
        middleView.addSubview(middleLabel)
        middleLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(15)
        }
        
        middleView.addSubview(textBgView)
        textBgView.snp.makeConstraints { make in
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.top.equalTo(49)
            make.bottom.equalTo(-15)
        }
        
        textBgView.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.leading.top.equalTo(15)
            make.trailing.bottom.equalTo(-15)
        }
        
        view.addSubview(appealBtn)
        appealBtn.snp.makeConstraints { make in
            make.bottom.equalTo(-safeAreaTp - 20)
            make.width.equalTo(screW - 30)
            make.height.equalTo(52)
            make.centerX.equalToSuperview()
        }
        
        textView.delegate = self
        
    }
    
    private func configActions() {
        
        appealBtn.gt.handleClick { [weak self] _ in
            
            guard let self = self else { return }
            guard let content = self.textView.text, !content.isEmpty else { return }
            //                        self.publishAppealReactor.action.onNext(.appealSubmit(self.id, date: self.date, content: content))
            
        }
        
        rightIcon.gt.handleClick { [weak self] _ in
            guard let self = self else { return }
            UIPasteboard.general.string = "\(self.id)"
            ToastHud.showToastAction(message: "copySuccessful".homeLocalizable())
            
        }
        
        
    }
    
    private func configData() {
        leftLabel.text = "appealTask".meLocalizable()
        rightLabel.text = "taskId".homeLocalizable() + " \(id)"
    }
            
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.alwaysBounceVertical = true
        return view
    }()
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .leading
        view.distribution = .fill
        view.spacing = 20
        return view
    }()
    
    private let topView = UIView()
    
    private let leftLabel = {
        let lab = UILabel()
        lab.textColor = .black
        lab.font = .boldSystemFont(ofSize: 16)
        return lab
    }()
    
    private let rightLabel = {
        let view = UILabel()
        view.textColor = UIColor.hexStrToColor("#999999")
        view.font = .systemFont(ofSize: 11)
        return view
    }()
    
    private let rightIcon: UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "mine_cpy"), for: .normal)
        btn.setBackgroundImage(UIImage(named: "mine_cpy"), for: .highlighted)
        return  btn
    }()
    
    private let detailView = ChorePublishAppealView(frame: .zero)
    
    private let middleLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = .black
        lab.font = .boldSystemFont(ofSize: 16)
        lab.text = "reasonForAppeal".meLocalizable()
        return lab
    }()
    
    private let textBgView: UIView = {
        let view = UIView()
        view.gt.setCornerRadius(8)
        view.backgroundColor = UIColor.xf2
        return view
    }()
    
    private let textView: UITextView = {
        let  text = UITextView()
        text.gt.setCornerRadius(8)
        text.backgroundColor = UIColor.xf2
        text.font = .systemFont(ofSize: 16)
        text.textColor = .black
        return text
    }()
    
    private let appealBtn: UIButton = {
        let btn = UIButton()
        btn.gt.setCornerRadius(8)
        btn.backgroundColor = UIColor.appColor
        btn.setTitle("submitAppeal".meLocalizable(), for: .normal)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 16)
        btn.setTitleColor(UIColor.hexStrToColor("#000000"), for: .normal)
        return btn
    }()
    
}

extension ChorePublishAppealController {
    
    private func mutationLoadDataResult() {
        MineReq.choreAppealDetail(id, date: date, completion: { [weak self] model in
            self?.model = model
            self?.detailView.configModel(model)
        })
        
    }
}

extension ChorePublishAppealController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let currentText = textView.text ?? ""
        self.textView.text = currentText
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {                if text == hhf {
        textView.resignFirstResponder()
        return false
    }
        return true
    }
    
}
