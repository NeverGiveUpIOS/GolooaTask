//
//  ReleTaskTimeView.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/7/25.
//

import UIKit

class ReleTaskTimeView: UIView, GTNibLoadable {
    
    @IBOutlet weak var lineView: UILabel!
    @IBOutlet weak var startTimebtn: UIButton!
    @IBOutlet weak var endTimeBtn: UIButton!
    
    private let currentDateCom: DateComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
    var startDate: Date?
    var endDate: Date?
    
    var callResultStart: CallBackStringBlock?
    var callResultEnd: CallBackStringBlock?

    @IBAction func startTimeClick(_ sender: Any) {
        
       getTopController().view.gt.keyboardEnd()
        
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
        dataPicker.callbackDateBlock = { [weak self] date in
            self?.startTimeJy(date)
        }
    }
    
    @IBAction func endTimeClick(_ sender: Any) {
        
       getTopController().view.gt.keyboardEnd()
        
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
        dataPicker.callbackDateBlock = { [weak self] date in
            self?.endTimeJy(date)
        }
    }
    
    private func setDateForm(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    private func endTimeJy(_ endDate: Date) {
        
        let curDate = Date().timeIntervalSince1970
        let dateTwo = endDate.timeIntervalSince1970
        if curDate > dateTwo {
            ToastHud.showToastAction(message: "A hora de término não pode ser anterior à hora de início")
            self.endDate = nil
            endTimeBtn.title("Data de Término")
            endTimeBtn.textColor(.lightGray)
            endTimeBtn.font(UIFontReg(12))
            lineView.backgroundColor = .lightGray
            callResultEnd?("")
            return
        }
        
        guard let startDate = startDate else {
            self.endDate = endDate
            endTimeBtn.title(setDateForm(endDate))
            endTimeBtn.textColor(.black)
            endTimeBtn.font(UIFontSemibold(14))
            lineView.backgroundColor = .lightGray
            callResultEnd?(setDateForm(endDate))
            return
        }
        
        let dateOne = startDate.timeIntervalSince1970
        
        if dateOne > dateTwo {
            ToastHud.showToastAction(message: "A hora de término não pode ser anterior à hora de início")
            self.endDate = nil
            endTimeBtn.title("Data de Término")
            endTimeBtn.textColor(.lightGray)
            endTimeBtn.font(UIFontReg(12))
            lineView.backgroundColor = .lightGray
            callResultEnd?("")
        } else {
            self.endDate = endDate
            endTimeBtn.title(setDateForm(endDate))
            endTimeBtn.textColor(.black)
            endTimeBtn.font(UIFontSemibold(14))
            callResultEnd?(setDateForm(endDate))
        }
        
        chLineStat()
    }
    
    private func startTimeJy(_ startDate: Date) {
        
        guard let endDate = endDate else {
            self.startDate = startDate
            startTimebtn.title(setDateForm(startDate))
            startTimebtn.textColor(.black)
            startTimebtn.font(UIFontSemibold(14))
            lineView.backgroundColor = .lightGray
            callResultStart?(setDateForm(startDate))
            return
        }
        
        let dateTwo = endDate.timeIntervalSince1970
        let dateOne = startDate.timeIntervalSince1970
        
        if dateOne > dateTwo {
            ToastHud.showToastAction(message: " A hora de início não pode ser posterior à hora de término")
            lineView.backgroundColor = .lightGray
            self.startDate = nil
            startTimebtn.title("Data de Início")
            startTimebtn.textColor(.lightGray)
            startTimebtn.font(UIFontReg(12))
            callResultStart?("")
        } else {
            self.startDate = startDate
            startTimebtn.title(setDateForm(startDate))
            startTimebtn.textColor(.black)
            startTimebtn.font(UIFontSemibold(14))
            callResultStart?(setDateForm(startDate))
        }
        
        chLineStat()
    }
    
    private func chLineStat() {
        guard let _ = startDate, let _ = endDate else {
            lineView.backgroundColor = .lightGray
            return
        }
        lineView.backgroundColor = .black
    }
    
}
