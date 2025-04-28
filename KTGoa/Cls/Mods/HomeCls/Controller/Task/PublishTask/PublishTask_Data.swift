//
//  PublishTask_Data.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/8/6.
//

import UIKit

extension PublishTaskViewController {
    
    func mutatePublishResult(_ model: TaskPublishModel) {
        
        // 上传任务信息
        let group = DispatchGroup()
        ToastHud.showToastAction()
        
        // 校验填写内容
        var isFail = false
        model.stepArr
            .filter({ $0.type == .edit })
            .forEach { item in
                if item.explain.count < 20 || item.explain.count > 160 {
                    isFail = true
                    return
                }
            }
        if isFail {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                ToastHud.hiddenToastAction()
                ToastHud.showToastAction(message: "submissionFailed".homeLocalizable())
            }
            return
        }
        
        // 任务 logo 上传
        if let logo = model.logo {
            group.enter()
            AliyunOSSHelper.shared.update(images: [logo], type: .taskLogo, showToast: false) { result, imagePaths in
                if result, let url = imagePaths.first {
                    model.cover = url
                } else {
                    isFail = true
                }
                group.leave()
            }
        }
        
        // 步骤图片上传
        let items = model.stepArr.filter({$0.image != nil})
        let images = items.map({ $0.image! })
        if images.count > 0 {
            group.enter()
            AliyunOSSHelper.shared.update(images: images, type: .taskBz, showToast: false) { result, imagePaths in
                if result, imagePaths.count == items.count {
                    for (index, element) in items.enumerated() {
                        element.icon = imagePaths[index]
                    }
                } else {
                    isFail = true
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            ToastHud.hiddenToastAction()
            if isFail || model.cover.isEmpty {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    ToastHud.hiddenToastAction()
                    ToastHud.showToastAction(message: "uploadFailedPleaseTryAgainLater".homeLocalizable())
                }
                return
            }
            
            var params: [String: Any] = [:]
            params["name"] = model.name
            if GlobalHelper.shared.inEndGid {
                params["link"] = "https://www.google.com"
            } else {
                params["link"] = model.link
            }
            params["cover"] = model.cover
            params["price"] = model.price
            params["intro"] = model.intro
            params["startTime"] = model.startTime
            params["endTime"] = model.endTime
            params["steps"] = model.steps
            if GlobalHelper.shared.inEndGid {
                params["count"] = 10
                params["platform"] = TaskPublishZFType.coin.rawValue
            } else {
                params["preCheck"] = "true"
            }
            NetAPI.HomeAPI.publish.reqToJsonHandler(parameters: params) { _ in
                // single(.success(.publishResult(true)))
                if GlobalHelper.shared.inEndGid {
                    RoutinStore.dismissRoot(animated: false)
                    ToastHud.showToastAction(message: "releaseSuccess".homeLocalizable() + "," + "waitingForPlatformTo".homeLocalizable())
                } else {
                    RoutinStore.push(.payDeposit, param: self.model)
                }
            } failed: { error in
                print("error: \(error)")
            }
        }
    }
    
    func mutateLoadTaskDesc(id: Int) {
        
        var params: [String: Any] = [:]
        params["id"] = id
        
        NetAPI.HomeAPI.taskDeac.reqToModelHandler(parameters: params, model: TaskDescModel.self) { [weak self] model, _ in
            self?.updateUI(model)
        } failed: { error in
            print("error: \(error)")
        }
        
    }
    
}

// MARK: - 时间选择
extension PublishTaskViewController {
    
    @objc  func clickTimeStartBtn(sender: UIButton) {
        showPickerDate((sender.titleLabel?.text ?? "").date()) { [weak self] dateStr in
            guard let self = self else { return }
            sender.isSelected = true
            sender.setTitle(dateStr, for: .normal)
            self.model.startTime = dateStr
            if self.timeEndBtn.isSelected,
               let startDate = self.model.startTime.date(),
               let endDate = self.model.endTime.date() {
                // 判断时间是否正确
                if endDate < startDate {
                    sender.isSelected = false
                    sender.setTitle(timeStartPlaceholder, for: .normal)
                    self.model.startTime = ""
                    ToastHud.showToastAction(message: "startTimeCannotLaterThanEndTime".homeLocalizable())
                    self.timeSeparator.textColor = .hexStrToColor("#999999")
                } else {
                    self.timeSeparator.textColor = .black
                }
            }
            self.updateBottomBtnState()
        }
    }
    
    @objc  func clickTimeEndBtn(sender: UIButton) {
        showPickerDate((sender.titleLabel?.text ?? "").date()) { [weak self] dateStr in
            guard let self = self else { return }
            sender.isSelected = true
            sender.setTitle(dateStr, for: .normal)
            self.model.endTime = dateStr
            if self.timeStartBtn.isSelected,
               let startDate = self.model.startTime.date(),
               let endDate = self.model.endTime.date() {
                // 判断时间是否正确
                if endDate < startDate {
                    sender.isSelected = false
                    sender.setTitle(timeEndPlaceholder, for: .normal)
                    self.model.endTime = ""
                    ToastHud.showToastAction(message: "endTimeCannotEarlierThanStartTime".homeLocalizable())
                    self.timeSeparator.textColor = .hexStrToColor("#999999")
                } else {
                    self.timeSeparator.textColor = .black
                }
            }
            self.updateBottomBtnState()
        }
    }
    
    func showPickerDate(_ selectDate: Date?, completion: ((String) -> Void)?) {
        view.endEditing(true)
        
        let curVc = UIViewController.gt.topCurController()
        
        let dataPicker = CusDatePickView()
        curVc?.definesPresentationContext = true
        dataPicker.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        dataPicker.picker.reloadAllComponents()
        
        curVc?.present(dataPicker, animated: true) {
            dataPicker.picker.selectRow(0, inComponent: 0, animated: true)
            dataPicker.picker.selectRow((self.currentDateCom.month!) - 1, inComponent: 1, animated:   true)
            dataPicker.picker.selectRow((self.currentDateCom.day!) - 1, inComponent: 2, animated: true)
        }
        
        /// 回调显示方法
        dataPicker.callbackDateBlock = { date in
            completion?(date.dateStr())
        }
    }
    
}
