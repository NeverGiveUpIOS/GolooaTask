//
//  ChatRecordView.swift
//  Golaa
//
//  Created by chenkaisong on 2024/5/15.
//

import UIKit
import SVGAPlayer

class ChatRecordView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        isDismissible = true
//        backgroundColor = .clear
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func disChatRecordView() {
        svgPlayer.stopAnimation()
        svgPlayer.clear()
        svgPlayer.clearDynamicObjects()
        gt.removeSubviews()
        removeFromSuperview()
    }
    
    deinit {
        svgPlayer.stopAnimation()
        svgPlayer.clear()
        svgPlayer.clearDynamicObjects()
    }
    
    func startRecord() {
        recordDes.textColor = .hexStrToColor("#999999")
        recordDes.text = "loosenCom".msgLocalizable()
        recordView.backgroundColor = .appColor
        stopSVGAAnimation()
        playSVGAAnimation("Black_SoundWaveBar")
    }
    
    /// 停止录音
    func stopRecord(_ text: String) {
        recordDes.textColor = .hexStrToColor("#F96464")
        recordDes.text = text
        recordView.backgroundColor = .hexStrToColor("#F96464")
        stopSVGAAnimation()
        playSVGAAnimation("White_SoundWaveBar")
    }
    
    func playSVGAAnimation(_ name: String) {
        let parser = SVGAParser()
        parser.parse(withNamed: name, in: .main) { [weak self] videoItem in
            self?.svgPlayer.videoItem = videoItem
            self?.svgPlayer.startAnimation()
        }
    }
    
    func stopSVGAAnimation() {
        svgPlayer.stopAnimation()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        disChatRecordView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        coverView.gradientLayer(startPoint: CGPoint(x: 0, y: 0),
                                endPoint: CGPoint(x: 0, y: 1),
                                frame: coverView.frame,
                                colors: [UIColorHex("#000000", alpha: 0).cgColor,
                                         UIColorHex("#000000", alpha: 0.5).cgColor,
                                         UIColorHex("#000000").cgColor])
    }
    
    private lazy var coverView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var recordView: UIView = {
        let view = UIView()
        view.gt.setCornerRadius(20)
        return view
    }()
    
    private lazy var recordDes: UILabel = {
        let lable = UILabel()
        lable.font = UIFontMedium(14)
        return lable
    }()
    
    private lazy var svgPlayer: SVGAPlayer = {
        let player = SVGAPlayer()
        player.loops = 0
        player.contentMode = .scaleAspectFill
        player.clearsAfterStop = false
        player.mainRunLoopMode = .common
        player.isUserInteractionEnabled = false
        return player
    }()
    
    private lazy var recordImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .chatFunRecord
        return imageView
    }()
}

extension ChatRecordView {
    
    private func setupSubviews() {
        
        gt.addSubviews([coverView, recordView, recordDes, recordImageView])
        recordView.addSubview(svgPlayer)
        startRecord()
        
        coverView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        svgPlayer.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(18)
            make.width.equalTo(76)
        }
        
        recordDes.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(recordView.snp.bottom).offset(14)
        }
        
        recordImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-64)
        }
        
        recordView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(60)
            make.bottom.equalTo(-220)
        }
    }
    
}
