//
//  ChatMsgStatusView.swift
//  Golaa
//
//  Created by chenkaisong on 2024/5/11.
//

import UIKit

class ChatMsgStatusView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        gt.addSubviews([dicatorView, statueImageView])
        
        dicatorView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        statueImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    func setupStatue(msgStatue: IMMsgStatue, readStatue: IMMsgReadStatue) {
        
        switch msgStatue {
        case .sending:
            // 发送中
            dicatorView.startAnimating()
            dicatorView.isHidden = false
            statueImageView.isHidden = true
            statueImageView.setImage(UIImage(named: ""), for: .normal)
            statueImageView.isUserInteractionEnabled = false
        case .success:
            // 发送成功
            dicatorView.stopAnimating()
            dicatorView.isHidden = true
            readStaue(readStatue: readStatue)
            statueImageView.isUserInteractionEnabled = false
        default:
            // 发送失败
            dicatorView.stopAnimating()
            dicatorView.isHidden = true
            statueImageView.isHidden = false
            statueImageView.setImage(.chatMsgFail, for: .normal)
            statueImageView.isUserInteractionEnabled = true
        }
        
    }
    
    private func readStaue(readStatue: IMMsgReadStatue) {
        
        switch readStatue {
        case .read:
            statueImageView.isHidden = false
            statueImageView.setImage(.chatMsgRead, for: .normal)
        case .unRead:
            statueImageView.isHidden = false
            statueImageView.setImage(.chatMsgUnRead, for: .normal)
        default:
            statueImageView.isHidden = true
            statueImageView.setImage(UIImage(named: ""), for: .normal)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var dicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        if #available(iOS 13.0, *) {
            view.style = .large
        } else {
            view.style = .gray
        }
        view.color = .hexStrToColor("#CBCBCB")
        view.backgroundColor = .clear
        view.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        return view
    }()
    
    lazy var statueImageView: UIButton = {
        let button = UIButton(type: .custom)
        button.contentHorizontalAlignment = .center
        button.isHidden = true
        button.gt.preventDoubleHit()
        return button
    }()

}
