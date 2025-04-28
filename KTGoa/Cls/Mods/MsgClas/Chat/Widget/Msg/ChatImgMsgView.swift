//
//  ChatImgMsgView.swift
//  Golaa
//
//  Created by chenkaisong on 2024/5/14.
//

import UIKit

class ChatImgMsgView: ChatBaseMsgView {
    
    var imageMinWidth: CGFloat = 120
    var imageMinHeight: CGFloat = 180
    var imageMaxWidth: CGFloat = 180
    var imageMaxHeight: CGFloat = 280
    
    var msgModel: ChatMsgModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imgMsg)
        contentView.addSubview(coverButton)
        
        contentView.gt.setCornerRadius(15)
        
        imgMsg.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.height.equalTo(0)
        }
        
        coverButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func setupMsgModel(_ msg: ChatMsgModel) {
        
        guard let imgObj = msg.imageObject else { return  }
        
        msgModel = msg
        
        statusView.isHidden = msg.msgDirection != .sender
        statusView.setupStatue(msgStatue: msg.msgStatus, readStatue: msg.msgReadStatue)
        
        contentView.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview()
            make.leading.equalTo(msg.msgDirection == .sender ? 50 : 0)
        }
        
        if msg.msgDirection == .sender {
            if let path = imgObj.path {
                let imgUrl = URL(fileURLWithPath: path)
                guard  let imageData = try? Data(contentsOf: imgUrl), let img = UIImage.init(data: imageData) else { return  }
                imgMsg.image = img
            } else {
                imgMsg.normalImageUrl(imgObj.url ?? "")
            }
        } else {
            imgMsg.normalImageUrl(imgObj.url ?? "")
        }
        
        upDateImgSize(aSize: imgObj.size)
        
    }
    
    private func upDateImgSize(aSize: CGSize) {
        
        let layoutSize = getImageSize(aSize: aSize)
        imgMsg.snp.updateConstraints { make in
            make.width.equalTo(layoutSize.width)
            make.height.equalTo(layoutSize.height)
        }
        imgMsg.snp.updateConstraints { make in
            make.width.equalTo(layoutSize.width)
            make.height.equalTo(layoutSize.height)
        }
        
    }
    
    /// 计算图片的大小
    private func getImageSize(aSize: CGSize) -> CGSize {
        
        var retSize = CGSize.zero
        if aSize.width <= 0 || aSize.height <= 0 {
            return CGSize(width: imageMinWidth, height: imageMinHeight)
        }
        imageMaxHeight = aSize.height / aSize.width * imageMaxWidth
        imageMaxWidth = aSize.width < 180 ? aSize.width : 180
        if imageMaxHeight >= imageMaxWidth {
            imageMaxHeight = aSize.height / aSize.width * imageMaxWidth
        }
        retSize = CGSize(width: imageMaxWidth, height: imageMaxHeight)
        return retSize
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var imgMsg: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    lazy var coverButton: UIButton = {
        let button = UIButton(type: .custom)
        button.gt.handleClick { [weak self] _ in
            self?.tapActionBlock?()
        }
        return button
    }()
}
