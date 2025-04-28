//
//  HomeReleTaskClasVc.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/7/25.
//

import UIKit

enum ReleTaskType {
    case edit
    case detail
}

class HomeReleTaskClasVc: BasClasVC {
    
    var scrollView: UIScrollView?
    
    var topView: ReleTaskTopView?
    var taskName: ReleTaskEditView?
    var tsakLogo: ReleTaskAddPicView?
    var tsakDes: ReleTaskEditView?
    var taskTime: ReleTaskTimeView?
    var stepLab: UILabel?
    var stepStackView: UIStackView?
    var stepOneView: ReleTaskStepView?
    var stepTwoView: ReleTaskStepView?
    var stepThreeView: ReleTaskStepView?
    var stepComView: ReleTaskStepComView?
    var relsStakButton: UIButton?
    var stepEditView: ReleTaskStepEditView?
    var stepEditAlpView: UIView?
    /// 任务步骤, 默认为1
    var stepNumber = 0
    
    var type: ReleTaskType = .edit
    
    lazy var taskClasModel = ReleTaskClasModel()
    
    lazy var taskListInfo = HomeListModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNotification()
        callResult()
    }
    
    deinit {
        removeNotification()
    }
    
    override func setupWidgetLayout() {
        super.setupWidgetLayout()
        
        relsStakButton = createButton(UIColorHex("#000000"), UIFontSemibold(14), text: "Publicar Tarefa")
        relsStakButton?.backgroundColor = UIColorHex("#FFDA00", alpha: 0.5)
        relsStakButton?.isUserInteractionEnabled = false
        relsStakButton?.layer.cornerRadius = 8
        relsStakButton?.clipsToBounds = true
        relsStakButton?.frame = .init(x: 30, y: screH - safeAreaBt - 91, width: screW - 60, height: 52)
        view.addSubview(relsStakButton!)
        
        scrollView = UIScrollView(frame: .init(x: 0, y: -statusBarH, width: screH, height: screH - safeAreaBt - 91 + statusBarH))
        scrollView?.contentSize = CGSize(width: screW, height: screH + 250)
        scrollView?.showsVerticalScrollIndicator = false
        view.insertSubview(scrollView!, at: 0)
        
        scrollView?.gt.addActionClosure { [weak self] tap, view, index in
            self?.view.gt.keyboardEnd()
        }
        
        scrollView?.gt.bottom = relsStakButton!.gt.top
        
        topView = ReleTaskTopView.loadNibWithNibName()
        taskName = ReleTaskEditView.loadNibWithNibName()
        tsakLogo = ReleTaskAddPicView.loadNibWithNibName()
        tsakDes = ReleTaskEditView.loadNibWithNibName()
        taskTime = ReleTaskTimeView.loadNibWithNibName()
        stepLab = createLab(.black, UIFontSemibold(14))
        stepStackView = UIStackView()
        stepStackView?.axis = .vertical
        stepStackView?.spacing = 0
        stepStackView?.distribution = .fillProportionally
        stepStackView?.alignment = .fill
        stepComView = ReleTaskStepComView.loadNibWithNibName()
        
        scrollView?.addSubview(topView!)
        scrollView?.addSubview(taskName!)
        scrollView?.addSubview(tsakLogo!)
        scrollView?.addSubview(tsakDes!)
        scrollView?.addSubview(taskTime!)
        scrollView?.addSubview(stepLab!)
        scrollView?.addSubview(stepStackView!)
        scrollView?.addSubview(stepComView!)
        
        
        taskName?.titleLab.text = "Nome da Tarefa de Promoção"
        taskName?.placeHoldText.text = "Por favor, Digite o Nome da Tarefa"
        tsakLogo?.titleLab.text = "Logo da Tarefa"
        tsakDes?.titleLab.text = "Descrição da Tarefa"
        tsakDes?.placeHoldText.text = "Digite as Instruções da Tarefa"
        stepLab?.text = "Definir Etapas da Tarefa (Máximo 3 Etapas)"
        
        topView?.frame = .init(x: 0, y: 0, width: screW, height: 236)
        taskName?.frame = .init(x: 0, y: topView!.gt.bottom + 25, width: screW, height: 73)
        tsakLogo?.frame = .init(x: 0, y: taskName!.gt.bottom + 18, width: screW, height: 142)
        tsakDes?.frame = .init(x: 0, y: tsakLogo!.gt.bottom + 18, width: screW, height: 143)
        taskTime?.frame = .init(x: 0, y: tsakDes!.gt.bottom + 18, width: screW, height: 73)
        stepLab?.frame = .init(x: 19, y: taskTime!.gt.bottom + 18, width: screW, height: 16)
        stepStackView?.frame = .init(x: 0, y: stepLab!.gt.bottom + 18, width: screW, height: 0)
        stepComView?.frame = .init(x: 0, y: stepStackView!.gt.bottom, width: screW, height: 28)
        
        if type == .edit {
            addStepView()
        } else {
            setDetailData()
        }
    }
    
    private func callResult() {
        
        taskName?.callResult = { [weak self] text in // 推广名称
            self?.taskClasModel.taskName = text
            self?.editComResult()
        }
        
        tsakDes?.callResult = { [weak self] text in // 任务说明
            self?.taskClasModel.taskDes = text
            self?.editComResult()
        }
        
        tsakLogo?.callResult = { [weak self] imsge in // 任务logo
            self?.taskClasModel.taskicon =  imsge 
            self?.editComResult()
        }
        
        taskTime?.callResultStart = { [weak self] text in // 开始时间
            self?.taskClasModel.taskStartTime = text
            self?.editComResult()
        }
        
        taskTime?.callResultEnd = { [weak self] text in // 结束时间
            self?.taskClasModel.taskEndTime = text
            self?.editComResult()
        }
        
        stepComView?.callResult = { [weak self] result in // 完成
            self?.taskClasModel.isCompletion = result
            self?.editComResult()
        }
        
        stepComView?.callJXBlock = { [weak self] in  // 继续添加
            self?.addStepView()
        }
        
        relsStakButton?.gt.handleClick { button in // 发布任务
            ToastHud.showToastAction()
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
                ToastHud.hiddenToastAction()
                ToastHud.showToastAction(message: "Tarefa publicada com sucesso, aguardando revisão em segundo plano", 3)
                self?.gt.disCurrentVC()
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.gt.keyboardEnd()
    }
}

// MARK: - Step Handle
extension HomeReleTaskClasVc {
    
    private func addStepView() {
        
        stepNumber += 1
        
        if stepNumber == 1 {
            stepOneView = ReleTaskStepView.loadNibWithNibName()
            stepOneView?.tag =  1
            stepOneView?.steplab.text = "No.\(1)"
            stepStackView?.addArrangedSubview(stepOneView!)
            
            stepOneView?.callDelStepBlock = { [weak self] in // 删除步骤
                let alert = UIAlertController(title: "Aviso", message: "Confirma a exclusão do passo?", preferredStyle: .alert)
                let action = UIAlertAction(title: "Confirmar", style: .default) { [weak self] (action) in
                    self?.stepNumber -= 1
                    self?.stepStackView?.removeArrangedSubview((self?.stepOneView)!)
                    self?.stepOneView?.removeFromSuperview()
                    self?.stepChange()
                }
                let canceAction = UIAlertAction(title: "Cancelar", style: .cancel) { (_) in
                }
                
                alert.addAction(action)
                alert.addAction(canceAction)

                self?.present(alert, animated: true, completion: nil)
            }
            stepOneView?.callEditStepBlock = { [weak self] in // 编辑
                self?.editStepText(self?.stepOneView)
            }
            
            stepOneView?.callResult = { [weak self] img in // 添加图片
                self?.taskClasModel.oneStep.taskIcon = img
                self?.editComResult()
            }
        }

        
        if stepNumber == 2 {
            stepTwoView = ReleTaskStepView.loadNibWithNibName()
            stepTwoView?.tag =  2
            stepTwoView?.steplab.text = "No.\(2)"
            stepStackView?.addArrangedSubview(stepTwoView!)
            
            stepTwoView?.callDelStepBlock = { [weak self] in // 删除步骤
                
                let alert = UIAlertController(title: "Aviso", message: "Confirma a exclusão do passo?", preferredStyle: .alert)
                let action = UIAlertAction(title: "Confirmar", style: .default) { [weak self] (action) in
                    self?.stepNumber -= 1
                    self?.stepStackView?.removeArrangedSubview((self?.stepTwoView)!)
                    self?.stepTwoView?.removeFromSuperview()
                    self?.stepChange()
                }
                let canceAction = UIAlertAction(title: "Cancelar", style: .cancel) { (_) in
                }
                
                alert.addAction(action)
                alert.addAction(canceAction)

                self?.present(alert, animated: true, completion: nil)

            }
            stepTwoView?.callEditStepBlock = { [weak self] in // 编辑
                self?.editStepText(self?.stepTwoView)
            }
            
            stepTwoView?.callResult = { [weak self] img in // 添加图片
                self?.taskClasModel.twoStep.taskIcon = img
                self?.editComResult()
            }
        }
        
        if stepNumber == 3 {
            stepThreeView = ReleTaskStepView.loadNibWithNibName()
            stepThreeView?.tag =  3
            stepThreeView?.steplab.text = "No.\(3)"
            stepStackView?.addArrangedSubview(stepThreeView!)
            
            stepThreeView?.callDelStepBlock = { [weak self] in // 删除步骤
                
                let alert = UIAlertController(title: "Aviso", message: "Confirma a exclusão do passo?", preferredStyle: .alert)
                let action = UIAlertAction(title: "Confirmar", style: .default) { [weak self] (action) in
                    self?.stepNumber -= 1
                    self?.stepStackView?.removeArrangedSubview((self?.stepThreeView)!)
                    self?.stepThreeView?.removeFromSuperview()
                    self?.stepChange()
                }
                
                let canceAction = UIAlertAction(title: "Cancelar", style: .cancel) { (_) in
                }
                
                alert.addAction(action)
                alert.addAction(canceAction)

                self?.present(alert, animated: true, completion: nil)

            }
            stepThreeView?.callEditStepBlock = { [weak self] in // 编辑
                self?.editStepText(self?.stepThreeView)
            }
            
            stepThreeView?.callResult = { [weak self] img in // 添加图片
                self?.taskClasModel.threeStep.taskIcon = img
                self?.editComResult()
            }
        }
    
        stepChange()
    }
    
    private func stepChange() {
        
        stepOneView?.deleStepBtn.isHidden = stepNumber == 1
        stepTwoView?.deleStepBtn.isHidden = stepNumber == 1
        stepThreeView?.deleStepBtn.isHidden = stepNumber == 1
        
        stepStackView?.frame = .init(x: 0, y: stepLab!.gt.bottom + 18, width: screW, height: CGFloat(stepNumber * 180))
        stepComView?.frame = .init(x: 0, y: stepStackView!.gt.bottom, width: screW, height: 28)
        stepComView?.setStepNumber(stepNumber)
        scrollView?.contentSize = CGSize(width: screW, height: screH + CGFloat(stepNumber * 180))
        
        editComResult()
    }
    
    private func editStepText(_ stepView: ReleTaskStepView?) {
        stepEditAlpView = UIView()
        stepEditAlpView?.removeFromSuperview()
        stepEditAlpView?.frame = ScreB
        stepEditAlpView?.backgroundColor = UIColorHex("#000000", alpha: 0.5)
        view.addSubview(stepEditAlpView!)
        
        let dText = (stepView?.editButton.titleLabel?.text ?? "").replacingOccurrences(of: " ", with: "")
        
        stepEditView?.removeFromSuperview()
        stepEditView = ReleTaskStepEditView.loadNibWithNibName()
        stepEditView?.textView.text = dText == "Editar Instruções de Imagem e Texto da Tarefa (Obrigatório)" ? "" : dText
        stepEditView?.frame = .init(x: 0, y: screH, width: screW, height: 55)
        stepEditView?.callEditText = { [weak self] text in
            stepView?.editButton.title(text.count <= 0 ? "  Editar Instruções de Imagem e Texto da Tarefa (Obrigatório)" : "  \(text)")
            stepView?.editButton.textColor(text.count <= 0 ? UIColor.lightGray : UIColor.black)
            
            if stepView?.tag == 1 {
                self?.taskClasModel.oneStep.taskDes = text
            }
            
            if stepView?.tag == 2 {
                self?.taskClasModel.twoStep.taskDes = text
            }
            
            if stepView?.tag == 3 {
                self?.taskClasModel.threeStep.taskDes = text
            }
            
            self?.editComResult()
        }
        view.addSubview(stepEditView!)
        
        stepEditView?.textView.becomeFirstResponder()
    }
    
    private func editComResult() {
        if taskClasModel.taskName.count <= 0 {
            relsStakButtonStatue(false)
            return
        }
        if taskClasModel.taskicon == nil {
            relsStakButtonStatue(false)
            return
        }
        if taskClasModel.taskDes.count <= 0 {
            relsStakButtonStatue(false)
            return
        }
        if taskClasModel.taskStartTime.count <= 0 {
            relsStakButtonStatue(false)
            return
        }
        if taskClasModel.taskEndTime.count <= 0 {
            relsStakButtonStatue(false)
            return
        }
        if taskClasModel.isCompletion == false {
            relsStakButtonStatue(false)
            return
        }
        
        
        stepStackView?.subviews.forEach({ view in
            if view.isKind(of: ReleTaskStepView.classForCoder()) {
                if view.tag == 1 {
                    if taskClasModel.oneStep.taskDes.count < 0 ||  taskClasModel.oneStep.taskIcon == nil {
                        relsStakButtonStatue(false)
                        return
                    }
                }
                if view.tag == 2 {
                    if taskClasModel.twoStep.taskDes.count < 0 ||  taskClasModel.twoStep.taskIcon == nil {
                        relsStakButtonStatue(false)
                        return
                    }
                }
                if view.tag == 3 {
                    if taskClasModel.threeStep.taskDes.count < 0 ||  taskClasModel.threeStep.taskIcon == nil {
                        relsStakButtonStatue(false)
                        return
                    }
                }
                
                relsStakButtonStatue(true)
            }
        })
        
    }
    
    private func relsStakButtonStatue(_ isUser: Bool) {
        if isUser {
            relsStakButton?.backgroundColor = UIColorHex("#FFDA00")
            relsStakButton?.isUserInteractionEnabled = true
            return
        }
        
        relsStakButton?.backgroundColor = UIColorHex("#FFDA00", alpha: 0.5)
        relsStakButton?.isUserInteractionEnabled = false
        
    }
    
}

// MARK: - 详情数据设置
extension HomeReleTaskClasVc {
    
    private func setDetailData() {
        
        topView?.taskDetail.text = "Detalhes da Tarefa"
        
        taskName?.textView.text = taskListInfo.name
        taskName?.textView.isUserInteractionEnabled = false
        taskName?.placeHoldText.isHidden = true
        
        tsakLogo?.addPicImg.isHidden = false
        tsakLogo?.addPicImg.imageWithUrl(withURL: taskListInfo.img)
        tsakLogo?.addPic.isUserInteractionEnabled = false

        tsakDes?.textView.text = taskListInfo.intro
        tsakDes?.textView.isUserInteractionEnabled = false
        tsakDes?.placeHoldText.isHidden = true

        taskTime?.startTimebtn.isUserInteractionEnabled = false
        taskTime?.endTimeBtn.isUserInteractionEnabled = false
        taskTime?.startTimebtn.textColor(.black)
        taskTime?.endTimeBtn.textColor(.black)
        taskTime?.lineView.backgroundColor = .black
        
        let startD = Date(timeIntervalSince1970: TimeInterval(taskListInfo.startTime) / 1000)
        let startFor = DateFormatter()
         startFor.dateFormat = "YYYY-MM-dd"
         startFor.string(from: startD)
        taskTime?.startTimebtn.title(startFor.string(from: startD))
        
        let endD = Date(timeIntervalSince1970: TimeInterval(taskListInfo.endTime) / 1000)
        let endFor = DateFormatter()
        endFor.dateFormat = "YYYY-MM-dd"
        taskTime?.endTimeBtn.title(endFor.string(from: endD))
        

        stepStackView?.isHidden = true
        stepComView?.isHidden = true
        stepLab?.isHidden = true
        relsStakButton?.isUserInteractionEnabled = false
        relsStakButton?.title("Verificação e Liquidação pela Plataforma")
        
        scrollView?.contentSize = CGSize(width: screW, height: screH)

    }
    
}

// MARK: - keyboard
extension HomeReleTaskClasVc {
    
    private func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardShow(_ noti: Notification) {
        guard let userInfo = noti.userInfo, let keyboardRect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let height = keyboardRect.height
        
        stepEditView?.frame = .init(x: 0, y: screH, width: screW, height: 55)
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.stepEditView?.frame = .init(x: 0, y: screH - height - 55, width: screW, height: 55)
        }
    }
    
    @objc func keyboardHide(_ noti: Notification) {
        stepEditAlpView?.removeFromSuperview()
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.stepEditView?.frame = .init(x: 0, y: screH, width: screW, height: 55)
        } completion: { [weak self] result in
            self?.stepEditView?.removeFromSuperview()
        }
    }
    
}
