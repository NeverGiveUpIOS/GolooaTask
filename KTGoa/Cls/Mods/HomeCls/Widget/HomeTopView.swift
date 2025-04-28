//
//  HomeTopView.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/7/24.
//

import UIKit

enum TaskType {
    case all
    case new
}

typealias HomeTopViewCallBlock  = (_ type: TaskType) -> ()

class HomeTopView: BasView {
    
    var taskLabel: UILabel?
    var relButton: UIButton?
    lazy var segView = UIView()
    var allTaskBtn: UIButton?
    var newtaskBtn: UIButton?
    
    var callBlock: HomeTopViewCallBlock?
    
    override func addWeights() {
        super.addWeights()
        taskLabel = createLab(UIColorHex("#000000"), UIFontSemibold(22), text: "Central de Tarefas")
        relButton = createButton(.homeRelTaskIcon)
        relButton?.image(.homeRelTaskIcon, .highlighted)
        gt.addSubviews([taskLabel!, relButton!, segView])
        
        allTaskBtn = createButton(UIColorHex("#000000"), UIFontSemibold(18))
        allTaskBtn?.title("Tudo")
        newtaskBtn = createButton(UIColorHex("#999999"), UIFontReg(18))
        newtaskBtn?.title("Nova")
        segView.gt.addSubviews([allTaskBtn!, newtaskBtn!])
        
        allTaskBtn?.gt.handleClick { [weak self] button in
            self?.newtaskBtn?.textColor(UIColorHex("#999999"))
            self?.allTaskBtn?.textColor(UIColorHex("#000000"))
            self?.callBlock?(.all)
        }
        
        newtaskBtn?.gt.handleClick { [weak self] button in
            self?.newtaskBtn?.textColor(UIColorHex("#000000"))
            self?.allTaskBtn?.textColor(UIColorHex("#999999"))
            self?.callBlock?(.new)
        }
        
        relButton?.gt.handleClick { button in
            ToastHud.showToastAction()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
               getTopController().gt.pushViewController(HomeReleTaskClasVc())
                ToastHud.hiddenToastAction()
            }
        }
        
    }
    
    override func addLayout() {
        super.addLayout()
        
        backgroundColor = UIColorHex("#F2F2F2")
        segView.backgroundColor = .white
        
        taskLabel?.frame = .init(x: 15, y: 68, width: 100, height: 20)
        taskLabel?.sizeToFit()
        
        relButton?.frame = .init(x: screW - 80, y: 0, width: 80, height: 80)
        relButton?.gt.centerY = taskLabel?.gt.centerY ?? 0
        
        segView.frame = .init(x: 0, y: gt.height - 30, width: screW, height: 30)
        segView.gt.addCorner(conrners: [.topLeft, .topRight], radius: 12)
        
        allTaskBtn?.frame = .init(x: 15, y: 0, width: 70, height: 30)
        allTaskBtn?.sizeToFit()
        newtaskBtn?.frame = .init(x: (allTaskBtn?.gt.right ?? 0) + 30, y: 0, width: 70, height: 30)
        newtaskBtn?.sizeToFit()
    }
}
