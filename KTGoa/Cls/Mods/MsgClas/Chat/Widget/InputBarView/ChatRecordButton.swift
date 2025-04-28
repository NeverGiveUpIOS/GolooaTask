//
//  ChatRecordButton.swift
//  Golaa
//
//  Created by chenkaisong on 2024/6/7.
//

import UIKit
import AVFAudio

class ChatRecordButton: UIButton {

    var recordView: ChatRecordView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        isUserInteractionEnabled = true
        setupConfig()
        RecorderTool.shared.blockRecordStatus = { [weak self] status in
            
            switch status {
            case .stop:
                self?.recoedStop()
            case .fail:
                self?.recoedFail()
            case .end:
                self?.recordView?.disChatRecordView()
            }
        }
        
    }
    
    private func setupConfig() {
        backgroundColor = .xf2
        setTitleColor(.hexStrToColor("#666666"), for: .normal)
        titleLabel?.font = UIFontSemibold(12)
        contentHorizontalAlignment = .center
        setTitle("holdSpeak".msgLocalizable(), for: .normal)
        gt.preventDoubleHit()
        gt.setCornerRadius(8)
        addTargets()
    }
    
    private func addTargets() {
        addTarget(self, action: #selector(audioTouchDown), for: .touchDown)
        addTarget(self, action: #selector(audioTouchDragEnter), for: .touchDragInside)
        addTarget(self, action: #selector(audioTouchDragExit), for: .touchDragOutside)
        addTarget(self, action: #selector(audioTouchDragUpInside), for: .touchUpInside)
        addTarget(self, action: #selector(audioTouchDragOutside), for: .touchUpOutside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Record
extension ChatRecordButton {
    
    /// 按下录音 开始录音
    @objc func audioTouchDown() {
        
        if openAudioSession() == false {return}

        if  UIApplication.gt.isOpenPermission(.audio) == false {
            ToastHud.showToastAction(message: "microphonesDes".msgLocalizable())
            return
        }
        
        showRecordView()
        RecorderTool.shared.beginRcordss()
    }
    
    private func showRecordView() {
        recordView?.disChatRecordView()
        recordView = ChatRecordView(frame: ScreB)
        recordView?.startRecord()
        getKeyWindow().addSubview(recordView!)
    }
    
    /// "继续录音"
    @objc func audioTouchDragEnter() {
        recordView?.startRecord()
    }
    
    /// "暂停"
    @objc func audioTouchDragExit() {
        recordView?.stopRecord("loosenCance".msgLocalizable())
    }
    
    /// "放开 发送" -- 发送语音消息
    @objc func audioTouchDragUpInside() {
        RecorderTool.shared.stopRecord()
    }
    
    /// 时间不足
    private func recoedStop() {
        recordView?.stopRecord("speechTimeShort".msgLocalizable())
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.recordView?.disChatRecordView()
        }
    }
    
    /// 录音失败
    private func recoedFail() {
        recordView?.stopRecord("recordFail".msgLocalizable())
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.recordView?.disChatRecordView()
        }
    }
    
    /// "取消录音"
    @objc func audioTouchDragOutside() {
        recordView?.disChatRecordView()
        RecorderTool.shared.canceRecord()
    }

    // 启动时是否开启麦克风权限
    func openAudioSession() -> Bool {
        let permissionStatus = AVAudioSession.sharedInstance().recordPermission
        if permissionStatus == AVAudioSession.RecordPermission.undetermined {
            AVAudioSession.sharedInstance().requestRecordPermission { _ in }
            return false
        } else {
            return true
        }
    }

}
