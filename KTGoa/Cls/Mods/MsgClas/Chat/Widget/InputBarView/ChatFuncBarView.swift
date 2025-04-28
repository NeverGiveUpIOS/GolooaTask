//
//  ChatFuncBarView.swift
//  Golaa
//
//  Created by chenkaisong on 2024/5/11.
//

import UIKit

class ChatFuncBarView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .hexStrToColor("#FAFAFA")
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var albumButton: ChatFuncView = {
        let view = ChatFuncView()
        view.setupFunContent(.chatAlbum, "sendImage".msgLocalizable())
        return view
    }()
    
    lazy var taskButton: ChatFuncView = {
        let view = ChatFuncView()
        view.setupFunContent(.chatTask, "shareMyTask".msgLocalizable())
        return view
    }()
    
    lazy var giftButton: ChatFuncView = {
        let view = ChatFuncView()
        view.setupFunContent(.chatGift, "gift".msgLocalizable())
        return view
    }()
    
}

extension ChatFuncBarView {
    
    private func setupSubviews() {
        
        addSubview(albumButton)
        addSubview(taskButton)
        
        albumButton.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.bottom.equalTo(-15)
            make.leading.equalToSuperview()
            make.width.equalTo(screW/4)
        }
        
        if mm.curSession?.sessionType == .P2P {
            addSubview(giftButton)
            giftButton.snp.makeConstraints { make in
                make.centerY.height.width.equalTo(albumButton)
                make.leading.equalTo(albumButton.snp.trailing)
            }
            
            taskButton.snp.makeConstraints { make in
                make.centerY.height.width.equalTo(albumButton)
                make.leading.equalTo(giftButton.snp.trailing)
            }
            
        } else {
            taskButton.snp.makeConstraints { make in
                make.centerY.height.width.equalTo(albumButton)
                make.leading.equalTo(albumButton.snp.trailing)
            }
        }
    }
}

class ChatFuncView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        addSubview(textLabel)
        addSubview(tapButton)
        
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(60)
            make.top.equalToSuperview().offset(15)
            make.centerX.equalToSuperview()
        }
        
        textLabel.snp.makeConstraints { make in
            make.leading.equalTo(2)
            make.trailing.equalTo(-2)
            make.top.equalTo(imageView.snp.bottom).offset(10)
        }
        
        tapButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setupFunContent(_ image: UIImage, _ text: String) {
        imageView.image = image
        textLabel.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFontSemibold(12)
        label.textColor = .hexStrToColor("#666666")
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var tapButton: UIButton = {
        let button = UIButton(type: .custom)
        button.gt.preventDoubleHit(2)
        return button
    }()
}
