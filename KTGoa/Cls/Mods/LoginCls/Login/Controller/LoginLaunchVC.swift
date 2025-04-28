//
//  LoginLaunchVC.swift
//  Golaa
//
//  Created by xiaoxuhui on 2024/5/7.
//

import UIKit
import AVKit
import AVFoundation

class LoginLaunchVC: BasClasVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hiddenNavView(true)
        sets()
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        
    }
    
    @objc func playerDidFinishPlaying(notification: Notification) {
        // 视频播放完成后重新开始播放
        player?.seek(to: .zero)
        player?.play()
    }
    
    deinit {
        // 移除通知
        NotificationCenter.default.removeObserver(self)
    }
    
    func sets() {
        view.layer.addSublayer(playerLayer)
        view.addSubview(spacer)
        view.addSubview(phoneBtn)
        view.addSubview(emailBtn)
        view.addSubview(agreeTermsView)
        //        view.addSubview(agreeBtn)
        
        agreeTermsView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-30-safeAreaBt)
            make.width.lessThanOrEqualTo(screW - 50)
        }
        
        //        agreeBtn.snp.makeConstraints { make in
        //            make.size.equalTo(10)
        //            make.centerY.equalTo(label)
        //            make.right.equalTo(label.snp.left).offset(-5)
        //        }
        
        emailBtn.snp.makeConstraints { make in
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.height.equalTo(50)
            make.bottom.equalTo(-safeAreaBt - 171)
        }
        
        phoneBtn.snp.makeConstraints { make in
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.height.equalTo(50)
            make.bottom.equalTo(emailBtn.snp.top).offset(-16)
        }
        
    }
    
    // MARK: -
    // MARK: Lazy
    
    lazy var phoneBtn: UIButton = {
        let button = UIButton()
        button.gt.setCornerRadius(12)
        button.textColor(.hexStrToColor("#4B4669"))
        button.image(UIImage(named: "login_pe"))
        button.backgroundColor = .hexStrToColor("#EFEFEF")
        button.setTitle("loginWithPhoneNumber".loginLocalizable(), for: .normal)
        button.gt.setImageTitlePos(.imgLeft, spacing: 0)
        button.addTarget(self, action: #selector(phoneClick), for: .touchUpInside)
        return button
    }()
    
    lazy var emailBtn: UIButton = {
        let button = UIButton()
        button.gt.setCornerRadius(12)
        button.textColor(.hexStrToColor("#4B4669"))
        button.image(UIImage(named: "login_dx"))
        button.backgroundColor = .hexStrToColor("#EFEFEF")
        button.setTitle("emailLogin".loginLocalizable(), for: .normal)
        button.gt.setImageTitlePos(.imgLeft, spacing: 0)
        button.addTarget(self, action: #selector(emailClick), for: .touchUpInside)
        return button
    }()
    
    lazy var agreeTermsView: AgreeTermsView = {
        let view = AgreeTermsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var spacer: UIImageView = {
        let view = UIImageView()
        view.image = .loginSpac
        return view
    }()
    
    var player: AVPlayer?
    lazy var playerLayer: AVPlayerLayer = {
        // 确保文件路径是正确的
        let filePath = Bundle.main.path(forResource: "launch", ofType: "mp4") ?? ""
        let fileURL = URL(fileURLWithPath: filePath)
        let playerItem = AVPlayerItem(url: fileURL)
        player = AVPlayer(playerItem: playerItem)
        let  playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = view.bounds
        playerLayer.videoGravity = .resizeAspect
        player?.play()
        return playerLayer
    }()
}

extension LoginLaunchVC {
    
    @objc func emailClick() {
        showAgree { [weak self] in
            let vc = LoginEmailVC()
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func phoneClick() {
        showAgree { [weak self] in
            let vc = LoginPhoneVC()
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func agreeClick(sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    func showAgree(completed: (() -> Void)?) {
        
        if agreeTermsView.isAgree {
            completed?()
        } else {
            LoginStartAlert.show { [weak self] result in
                if result {
                    completed?()
                    self?.agreeTermsView.isAgree = true
                    self?.agreeTermsView.checkboxButton.isSelected = true
                }
            }
        }
    }
}
