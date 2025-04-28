//
//  ChatInputBarView.swift
//  Golaa
//
//  Created by chenkaisong on 2024/5/10.
//

protocol ChatInputBarViewDelegate: NSObjectProtocol {
    
    /// 发送文本消息
    func sendTextMsg(_ text: String)
    
    /// 输入框的高度变化
    func textViewHeight(_ height: Int)
    
    /// 照片选择
    func choseAlbumImgs(_ imgs: [UIImage])
    
    /// 音频文件
    func recordDPath(_ duration: Int, path: String)
    
    /// 发送任务消息
    func sendTaskMsg()
    
}

import UIKit

class ChatInputBarView: UIView {
    
    weak var delegate: ChatInputBarViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .hexStrToColor("#FAFAFA")
        
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hiddenFunView() {
        toolBarView.hiddenFunView()
    }
    
    /// 更新群禁言类型
    func updateStatusMute() {
        toolBarView.updateStatusMute()
    }
    
    private lazy var toolBarView: ChatInputToolBarView = {
        let view = ChatInputToolBarView()
        view.callSendTextBlock = { [weak self] text in
            self?.sendTextMsg(text)
        }
        view.callTextViewHeightBlock = { [weak self] height in
            self?.textViewChangeHeight(height)
        }
        view.callImsgBlock = { [weak self] imsg in
            if let imgs = imsg as? [UIImage] {
                self?.choseImgsResult(imgs)
            }
        }
        view.callRecordResultBlock = {  [weak self] (duration, path) in
            self?.recordResult(duration, path: path)
        }
        view.callTaskBlock = { [weak self]  in
            self?.sendTaskMsg()
        }
        return view
    }()
}

extension ChatInputBarView {
    
    private func setupSubviews() {
        
        addSubview(toolBarView)
        toolBarView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(-safeAreaBt)
        }
    }
}

extension ChatInputBarView {
    
    /// 发送文本消息
    private func sendTextMsg(_ text: String) {
        self.delegate?.sendTextMsg(text)
    }
    
    /// 输入框高度变化
    func textViewChangeHeight(_ height: Int) {
        self.delegate?.textViewHeight(height)
    }
    
    /// 发送图片消息
    func choseImgsResult(_ imgs: [UIImage]) {
        self.delegate?.choseAlbumImgs(imgs)
    }
    
    /// 音频文件
    func recordResult(_ duration: Int, path: String) {
        self.delegate?.recordDPath(duration, path: path)
    }
    
    /// 发送任务消息
    private func sendTaskMsg() {
        self.delegate?.sendTaskMsg()
    }
}
