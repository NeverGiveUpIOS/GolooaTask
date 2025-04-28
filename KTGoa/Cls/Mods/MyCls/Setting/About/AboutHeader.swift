//
//  AboutHeader.swift
//  Golaa
//
//  Created by Cb on 2024/5/17.
//

import Foundation

class AboutHeader: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configViews()
        configActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configViews() {
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(40)
            make.centerX.equalToSuperview()
        }
        
        stackView.addArrangedSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(80)
        }
        
        stackView.addArrangedSubview(titleLabel)
    }
    
    private func configActions() {}
    
    // MARK: - 属性
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .center
        view.spacing = 10
        return view
    }()
    
    private let imageView: UIImageView = UIImageView(image: UIImage(named: "mine_logo"))
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 14)
        view.textColor = UIColor.hexStrToColor("#666666")
        view.text = "Golaa V\(Bundle.gt.appVersion)（\(Bundle.gt.appBuild)）"
        return view
    }()
}
