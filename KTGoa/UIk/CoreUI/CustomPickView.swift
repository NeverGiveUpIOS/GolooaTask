//
//  CustomPickView.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/8/9.
//

import UIKit

@objcMembers public class CustomPickViewStyle: NSObject {
    /// 取消的颜色
    public var cancleColor: UIColor = UIColor.hexStrToColor("#2C2D2E")
    /// 确定的颜色
    public var sureColor: UIColor = UIColor.hexStrToColor("#426BF2")
}

public typealias PickerViewSelectedBackClosure = (_ resultStr: String) -> ()

public class CustomPickView : UIView {
    /// 样式
    fileprivate var style: CustomPickViewStyle = CustomPickViewStyle()
    /// 界面消失
    public var dismissClosure: (() -> Void)?
    /// 确定按钮的闭包
    public var rowAndComponentCallBack: PickerViewSelectedBackClosure?
    /// 选择的内容
    fileprivate var blockContent: String = ""
    /// 取消
    lazy var cancelButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 16, y: 16, width: screW / 2.0 - 16, height: 26))
        button.setTitle("cancel".globalLocalizable(), for: .normal)
        button.setTitleColor(style.cancleColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        return button
    }()
    
    /// 确定
    lazy var confirmButton: UIButton = {
        let button = UIButton(frame: CGRect(x: screW / 2.0, y: 16, width: screW / 2.0 - 16, height: 26))
        button.setTitle("confirm".globalLocalizable(), for: .normal)
        button.setTitleColor(style.sureColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        button.contentHorizontalAlignment = .right
        button.addTarget(self, action: #selector(confirmAction), for: .touchUpInside)
        return button
    }()
    
    /// window
    var keyWindow : UIWindow?
    
    /// 背景色
    lazy var bgView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: screH - 274 - safeAreaBt, width: screW, height: 274 + safeAreaBt))
        view.backgroundColor = UIColor.white
        view.gt.addCorner(conrners: [.topLeft, .topRight], radius: 20)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.alpha = 0.0
        self.bgView.alpha = 0.0
        self.backgroundColor = UIColor.black.withAlphaComponent(0.47)
        self.gt.addGestureTap { tap in
            self.hide()
        }
        if (keyWindow == nil) {
            self.keyWindow = UIViewController.gt.keyWindow
        }
        addSubview(bgView)
        bgView.addSubview(cancelButton)
        bgView.addSubview(confirmButton)
        
    }
    
    public convenience init(frame: CGRect, dataSource: [String], inComponent component: Int = 0, style: CustomPickViewStyle = CustomPickViewStyle()) {
        self.init(frame: frame)
        if (dataSource.count != 0) {
            blockContent = dataSource.first ?? ""
            let picker = PickerViewBuilder(frame: CGRect(x: 0, y: 60, width: screW, height: bgView.frame.size.height - 60 - safeAreaBt - 20), dataSource: dataSource, inComponent: component, contentCallBack:{ [weak self] (resultStr) in
                guard let weakSelf = self else {
                    return
                }
                weakSelf.blockContent = resultStr
            })
            picker.rowAndComponentCallBack = {[weak self](resultStr) in
                guard let weakSelf = self else {
                    return
                }
                weakSelf.blockContent = resultStr
            }
            bgView.addSubview(picker)
        } else {
            assert(dataSource.count != 0, "dataSource is not allowed to be nil")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - 基本事件
extension CustomPickView {
    //MARK: 弹出视图
    func show() {
        keyWindow?.addSubview(self)
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 1.0
            self.bgView.alpha = 1.0
        }) { (isFinished) in
            
        }
    }
    
    //MARK: 界面消失
    @objc func hide() {
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0.0
            self.bgView.alpha = 0.0
        }) { (isFinished) in
            self.removeFromSuperview()
            self.dismissClosure?()
        }
    }
    
    //MARK: 取消
    /// 取消
    @objc func cancelAction() {
        hide()
    }
    
    //MARK: 确定
    /// 确定
    @objc func confirmAction() {
        self.rowAndComponentCallBack?(blockContent)
        hide()
    }
}

class PickerViewBuilder: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    /// 选择内容回调
    fileprivate var rowAndComponentCallBack: PickerViewSelectedBackClosure?
    /// 当前选中的row
    lazy var currentSelectRow: Int = 0
    /// 资源数组
    lazy var dataArray: [String] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, dataSource: [String], inComponent component: Int = 0, contentCallBack: PickerViewSelectedBackClosure?) {
        self.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.dataArray = dataSource
        self.delegate = self
        self.dataSource = self
        currentSelectRow = component
        self.selectRow(component, inComponent: 0, animated: true)
        self.reloadAllComponents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        // pickerView.backgroundColor = .brown
        var pickerLabel = view as? UILabel
        if pickerLabel == nil {
            
            pickerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: screW - 20, height: 30))
            pickerLabel?.textAlignment = .center
            if currentSelectRow == row {
                pickerLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
                pickerLabel?.textColor = UIColor.hexStrToColor("#2C2D2E")
            } else {
                pickerLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
                pickerLabel?.textColor = UIColor.hexStrToColor("#7C828C")
            }
        }
        pickerLabel?.text = dataArray[row]
        
        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 33
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentSelectRow = row
        rowAndComponentCallBack?(dataArray[currentSelectRow])
        self.reloadAllComponents()
    }
}
