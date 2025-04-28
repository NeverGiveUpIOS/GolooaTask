//
//  CusDatePickView.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/7/25.
//

import UIKit

class CusDatePickView: UIViewController {
    
    var callbackDateBlock: ((Date) -> Void)?
    
    /// 获取当前日期
    private var currentDateCom: DateComponents = Calendar.current.dateComponents([.year, .month, .day],   from: Date())
    
    lazy var contentView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: screH-274, width: screW, height: 274))
        view.backgroundColor = UIColor.white
        return view
    }()
    
    lazy var bagView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        return view
    }()
    
    var picker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubViews()
        
    }
    
    private func setupSubViews() {
        
        self.view.backgroundColor = UIColor.clear
        self.view.insertSubview(self.bagView, at: 0)
        self.modalPresentationStyle = .custom
        
        
        let sure = UIButton(type: .custom)
        sure.frame = CGRect(x: screW - 100, y: 10, width: 100, height: 20)
        sure.textColor(UIColorHex("#2697FF"))
        sure.title("complete".homeLocalizable())
        sure.addTarget(self, action: #selector(self.onClickSure), for: .touchUpInside)
        picker = UIPickerView(frame: CGRect(x: 0, y: sure.gt.bottom + 4, width: screW, height: 240))
        picker.delegate = self
        picker.dataSource = self
        picker.backgroundColor = UIColor.clear
        picker.clipsToBounds = true
        
        contentView.addSubview(sure)
        contentView.addSubview(picker)
        view.addSubview(self.contentView)
        sure.sizeToFit()
        
        transitioningDelegate = self as UIViewControllerTransitioningDelegate
        
        contentView.gt.addCorner(conrners: [.topLeft, .topRight], radius: 12)
    }
    
    @objc func onClickSure() {
        let dateString = String(format: "%02ld-%02ld-%02ld", self.picker.selectedRow(inComponent: 0) + (self.currentDateCom.year!), self.picker.selectedRow(inComponent: 1) + 1, self.picker.selectedRow(inComponent: 2) + 1)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        if self.callbackDateBlock != nil {
            self.callbackDateBlock!(dateFormatter.date(from: dateString) ?? Date())
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        let currentPoint = touches.first?.location(in: self.view)
        
        if !self.contentView.frame.contains(currentPoint ?? CGPoint()) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
}

// MARK: - PickerViewDelegate
extension CusDatePickView:UIPickerViewDelegate,UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 10
        } else if component == 1 {
            return 12
        } else {
            let year: Int = pickerView.selectedRow(inComponent: 0) + currentDateCom.year!
            let month: Int = pickerView.selectedRow(inComponent: 1) + 1
            let days: Int = howManyDays(inThisYear: year, withMonth: month)
            return days
        }
    }
    
    private func howManyDays(inThisYear year: Int, withMonth month: Int) -> Int {
        if (month == 1) || (month == 3) || (month == 5) || (month == 7) || (month == 8) || (month == 10) || (month == 12) {
            return 31
        }
        if (month == 4) || (month == 6) || (month == 9) || (month == 11) {
            return 30
        }
        if (year % 4 == 1) || (year % 4 == 2) || (year % 4 == 3) {
            return 28
        }
        if year % 400 == 0 {
            return 29
        }
        if year % 100 == 0 {
            return 28
        }
        return 29
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return screW / 3
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "\((currentDateCom.year!) + row)\("year".globalLocalizable())"
        } else if component == 1 {
            return "\(row + 1)\("month".globalLocalizable())"
        } else {
            return "\(row + 1)\("day".globalLocalizable())"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 1 {
            pickerView.reloadComponent(2)
        }
    }
        
}

extension CusDatePickView: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animated = DatePickerPreAnimate(type: .pres)
        return animated
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animated = DatePickerPreAnimate(type: .dis)
        return animated
    }
}


