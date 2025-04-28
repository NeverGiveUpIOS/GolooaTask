//
//  AboutContactViewController.swift
//  Golaa
//
//  Created by Cb on 2024/5/27.
//

import Foundation

class AboutContactViewController: BasClasVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configViews()
        configActions()
        configData()
    }
    
    private func configViews() {
//        setupNavTitle("contactMe".meLocalizable())
        
        view.insertSubview(stackView, at: 0)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(naviH)
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
        }

        stackView.addArrangedSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        stackView.addArrangedSubview(contentLabel)
        stackView.addArrangedSubview(contactLabel)

    }
    
    private func configActions() {
        
    }
    
    private func configData() {
        titleLabel.text = "contactMe".meLocalizable()
        contentLabel.text = "ifYouHaveAnyQuestions".meLocalizable()
        let text = "golaa.help@gmail.com"
        let total = "emailXx".meLocalizable(text)
        contactLabel.text(total)
        contactLabel.gt.setSpecificTextColor(text, color: .hexStrToColor("#2697FF"))
    }
    
    // MARK: - 属性
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.spacing = 12
        return view
    }()
    
    private let titleLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = .hexStrToColor("#000000")
        lab.font = .boldSystemFont(ofSize: 20)
        lab.numberOfLines = 0
        lab.textAlignment = .center
        return lab
    }()
    
    private let contentLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = .hexStrToColor("#666666")
        lab.font = .systemFont(ofSize: 15)
        lab.numberOfLines = 0
        return lab
    }()
    
    private let contactLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = .hexStrToColor("#000000")
        lab.font = .boldSystemFont(ofSize: 15)
        lab.numberOfLines = 0
        return lab
    }()

}
