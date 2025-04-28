//
//  FillCodeViewController.swift
//  Golaa
//
//  Created by Cb on 2024/5/17.
//

import Foundation

class FillCodeViewController: BasClasVC, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configViews()
        configActions()
    }
    
    private func configViews() {
        navTitle("invitationCode".meLocalizable())
        
        view.insertSubview(scrollView, at: 0)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(screW)
        }
        
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(55)
            make.bottom.equalToSuperview()
            make.leading.equalTo(20)
            make.width.equalTo(screW - 40)
        }
        
        stackView.addArrangedSubview(titleLabel)
        
        stackView.addArrangedSubview(textField)
        textField.delegate = self
        textField.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(50)
        }
        
        stackView.setCustomSpacing(50, after: textField)
        
        stackView.addArrangedSubview(confirmBtn)
        confirmBtn.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(52)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    private func configActions() {
//        textField.rx.text.orEmpty.asDriver().drive(textField.rx.countLimit(20)).disposed(by: disposeBag)
//        textField.rx.text.orEmpty.map({ $0.count >= 0}).bind(to: confirmBtn.rx.isEnabled).disposed(by: disposeBag)
//        confirmBtn.rx.tap.subscribe(onNext: { [weak self] _ in
//            self?.confirmAction()
//        }).disposed(by: disposeBag)
        confirmBtn.gt.handleClick { [weak self] _ in
            self?.textField.resignFirstResponder()
            self?.textField.endEditing(true)
            self?.confirmAction()
        }
    }
    
    // MARK: - 属性
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.alwaysBounceVertical = true
        return view
    }()
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .leading
        view.spacing = 12
        return view
    }()
    
    private let titleLabel: UILabel = {
        let lab = UILabel()
        lab.font = .boldSystemFont(ofSize: 18)
        lab.textColor = .black
        lab.text = "enterInvitationCode".meLocalizable()
        return lab
    }()
    
    private let textField: UITextField = {
        let text = UITextField()
        text.gt.setCornerRadius(12)
        text.font = .boldSystemFont(ofSize: 16)
        text.textColor = UIColor.hexStrToColor("#333333")
        text.backgroundColor = UIColor.xf2
        text.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        text.leftViewMode = .always
        return text
    }()
    
    private let confirmBtn: UIButton = {
        let btn = UIButton()
        btn.gt.setCornerRadius(8)
        btn.backgroundColor = UIColor.appColor
        btn.setTitle("confirm".msgLocalizable(), for: .normal)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 16)
        btn.setTitleColor(UIColor.hexStrToColor("#000000"), for: .normal)
        return btn
    }()
}

extension FillCodeViewController {
    private func confirmAction() {
        guard let code = textField.text, code.count > 0 else { return }
        MineReq.parentBind(code) { isSuccess, msg in
            if let msg = msg {
                ToastHud.showToastAction(message: msg)
            }
            if isSuccess {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    RoutinStore.dismiss()
                }
            }
        }
    }
}
