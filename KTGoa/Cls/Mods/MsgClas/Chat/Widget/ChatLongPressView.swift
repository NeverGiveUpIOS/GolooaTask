//
//  ChatLongPressView.swift
//  Golaa
//
//  Created by chenkaisong on 2024/5/21.
//

import UIKit

class ChatLongPressView: UIView {
    
    var clickBlock: CallBackStringBlock?
        
    // 黑色三角箭头方向是否朝下
    var isDownArrow = true {
        didSet {
            self.resetAngleArrowViewLayout(isDownArrow)
        }
    }
    
    private var items = [String]()
    private let itemWidth: Int = 60
    private let itemHeight: Int = 36
    
    var viewSize = CGSize.zero
    
    private var firstRecordItem = UIButton()
    
    // 背景视图
    lazy var controlView: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(controlViewClick(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    /// 三角型
    lazy var triangleView: TriangleView = {
        let view = TriangleView()
        return view
    }()
    
    /// 倒三角
    lazy var invertedTriangleView: InvertedTriangleView = {
        let view = InvertedTriangleView()
        return view
    }()
    
    init(items: [String], frame: CGRect) {
        super.init(frame: frame)
        
        self.items = items
        viewSize = CGSizeMake(CGFloat(itemWidth * items.count), CGFloat(itemHeight + 10))
        setupUI()
        setupLayout()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
        
    func setupUI() {
        
        addSubview(controlView)
        addSubview(backView)
        backView.addSubview(contentView)
        backView.addSubview(triangleView)
        backView.addSubview(invertedTriangleView)

        for (index, item) in items.enumerated() {
            let button = UIButton()
            button.setTitle(item, for: .normal)
            button.titleLabel?.font = UIFontReg(14)
            button.setTitleColor(.white, for: .normal)
            button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
            button.tag = index
            contentView.addSubview(button)
            
            button.frame = CGRect(x: index*itemWidth, y: 0, width: itemWidth, height: itemHeight)
            
            if index == 0 {
                firstRecordItem = button
            }
        }
        
        /// 添加分割线
        for (index, _) in items.enumerated() {
            if index < items.count - 1 {
                let view = UIView()
                view.backgroundColor = .hexStrToColor("#D4D4D4", 0.2)
                contentView.addSubview(view)
                
                view.frame = CGRect(x: CGFloat(60*(index+1)), y: CGFloat(0), width: CGFloat(1/UIScreen.main.scale), height: CGFloat(30))
            }
        }
        
        backView.frame = CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height)
    }
    
    func setupLayout() {
        
        controlView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        
        contentView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(itemHeight)
        }
        
        invertedTriangleView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(contentView.snp.bottom)
            make.size.equalTo(CGSize(width: 12, height: 6))
        }
        
        triangleView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(contentView.snp.top)
            make.size.equalTo(invertedTriangleView)
        }
    }
    
    func resetAngleArrowViewLayout(_ isDownArrow: Bool) {
        if isDownArrow {
            
            contentView.snp.remakeConstraints { make in
                make.left.top.right.equalToSuperview()
                make.bottom.equalTo(-10)
            }
            
            triangleView.isHidden = true
            invertedTriangleView.isHidden = false
        } else {
            
            contentView.snp.remakeConstraints { make in
                make.left.bottom.right.equalToSuperview()
                make.top.equalTo(10)
            }
            
            triangleView.isHidden = false
            invertedTriangleView.isHidden = true
        }
    }
    
    @objc func buttonAction(_ button: UIButton) {
        clickBlock?(button.titleLabel?.text ?? "")
        removeFromSuperview()
    }
    
    @objc func controlViewClick(_ button: UIButton) {
        removeFromSuperview()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        removeFromSuperview()
    }
}

 // MARK: - 三角
class InvertedTriangleView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = .clear
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.beginPath()
        context.move(to: CGPoint(x: rect.minX, y: rect.minY))
        context.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        context.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        context.closePath()
        
        UIColor.black.setFill()
        context.fillPath()
    }
}

// MARK: - 三角
class TriangleView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = .clear
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.beginPath()
        context.move(to: CGPoint(x: rect.midX, y: rect.minY))
        context.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        context.closePath()
        
        UIColor.black.setFill()
        context.fillPath()
    }
}
