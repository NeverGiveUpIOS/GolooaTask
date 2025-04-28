//
//  BroadcastCell.swift
//  Golaa
//
//  Created by Cb on 2024/5/17.
//

import Foundation

class BroadcastCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configViews()
        configActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configViews() {
        selectionStyle = .none
        contentView.backgroundColor = UIColor.xf2

        addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.top.bottom.equalToSuperview()
        }
        
        bgView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(15)
            make.centerY.equalToSuperview()
        }
        
        bgView.addSubview(switchBtn)
        switchBtn.snp.makeConstraints { make in
            make.trailing.equalTo(-15)
            make.centerY.equalToSuperview()
        }
    }
    
    private func configActions() {
        switchBtn.addTarget(self, action: #selector(switchSlider), for: .valueChanged)
    }
    
    @objc private func switchSlider(_ sender: UISwitch) {
        guard let item = item else { return }
        if item.type == .newMsgNotice {
            sender.isOn = !sender.isOn
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
            }
        } else {
            UserDefaults.standard.set(sender.isOn, forKey: CacheKey.vibrateState)
            UserDefaults.standard.synchronize()
            BroadcastType.vibrateOccurred()
        }
    }
    
    func configItem(_ item: BroadcastModel) {
        self.item = item
        titleLabel.text = item.type.rawValue
        item.type.roundView(bgView)
        switchBtn.isOn = item.isSelect
    }
    
    // MARK: - 属性
    private var item: BroadcastModel?
    
    private let bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let titleLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = .hexStrToColor("#343740")
        lab.font = .boldSystemFont(ofSize: 14)
        return lab
    }()
    
    private let switchBtn: UISwitch = {
        let view = UISwitch()
        view.onTintColor = UIColor.hexStrToColor("#FED40A")
        return view
    }()
}
