//
//  ToastView.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/7/24.
//

import UIKit

enum ShowInPosition: String {
    case top = "top"
    case center = "center"
    case bottom = "bottom"
}

struct ToastHud {
    
    //显示菊花
    static func showToastAction() {
        if Thread.main.isMainThread {
            toastView = self.currentToastView()
            toastView?.removeFromSuperview()
            guard let aWin = UIApplication.shared.delegate?.window else { return }
            aWin?.addSubview(toastView!)
            
            let indicatorView = toastView?.viewWithTag(10) as! UIActivityIndicatorView
            indicatorView.center = CGPoint.init(x: 70/2, y: 70/2)
            indicatorView.startAnimating()
            toastView?.frame = CGRect.init(x: (screW-70)/2, y: (screH-70)/2, width: 70, height: 70)
            toastView?.alpha = 1
        }else{
            DispatchQueue.main.async {
                self.showToastAction()
            }
            return
        }
    }
    
    //隐藏菊花
    static func hiddenToastAction() {
        if toastView != nil {
            DispatchQueue.main.async {
                let indicatorView = self.toastView?.viewWithTag(10) as! UIActivityIndicatorView
                indicatorView.stopAnimating()
                self.toastView?.alpha = 0
                self.toastView?.removeFromSuperview()
            }

        }
    }
    
    //默认显示消息-->center
    static func showToastAction(message : String, _ showtime : Double = 2.0) {
        self.showToast(message: message, position: .center, aShowTime: showtime)
    }
 
    //显示消息
    static func showToast(message : String?, position : ShowInPosition?, aShowTime : TimeInterval) {
        if Thread.current.isMainThread {
            toastLabel = self.currentToastLabel()
            toastLabel?.removeFromSuperview()
            
            guard let aWin = UIApplication.shared.delegate?.window else { return }
            aWin?.addSubview(toastLabel!)
            
            var width = self.stringText(aText: message, aFont: 16, isHeightFixed: true, fixedValue: 40)
            var height : CGFloat = 0
            if width > ( screW - 40) {
                width =  screW - 40
                height = self.stringText(aText: message, aFont: 16, isHeightFixed: false, fixedValue: width)
            }else{
                height = 40
            }
            
            var labFrame = CGRect.zero
            switch position {
            case .top:
                labFrame = CGRect.init(x: ( screW-width)/2, y: screH*0.15, width: width, height: height)
            case .center:
                labFrame = CGRect.init(x: ( screW-width)/2, y: screH*0.5, width: width, height: height)
            default:
                labFrame = CGRect.init(x: ( screW-width)/2, y: screH*0.85, width: width, height: height)
            }
       
            toastLabel?.frame = labFrame
            toastLabel?.text = message as String?
            toastLabel?.alpha = 1
            UIView.animate(withDuration: aShowTime, animations: {
                toastLabel?.alpha = 0;
            })
        }else{
            DispatchQueue.main.async {
                self.showToast(message: message, position: position, aShowTime: aShowTime)
            }
            return
        }
    }
        
    //显示(带菊花的消息)-->default center
    static func showIndicatorToastAction(message : String) {
        self.showIndicatorToast(message: message, position: .center, aShowTime: 10000)
    }
    
    
    //显示(带菊花的消息)
    static func showIndicatorToast(message : String?, position : ShowInPosition?, aShowTime : TimeInterval) {
        if Thread.current.isMainThread {
            toastIndicatorView = self.currentToastViewLabel()
            toastIndicatorView?.removeFromSuperview()
            guard let aWin = UIApplication.shared.delegate?.window else { return }
            aWin?.addSubview(toastIndicatorView!)
           
            var width = self.stringText(aText: message, aFont: 16, isHeightFixed: true, fixedValue: 40)
            var height : CGFloat = 0
            if width > ( screW - 40) {
                width =  screW - 40
                height = self.stringText(aText: message, aFont: 16, isHeightFixed: false, fixedValue: width)
            }else{
                height = 40
            }
            
            var labFrame = CGRect.zero
            switch position {
            case .top:
                labFrame = CGRect.init(x: ( screW-width)/2, y: screH*0.15, width: width, height: 60+height)
            case .center:
                labFrame = CGRect.init(x: ( screW-width)/2, y: screH*0.5, width: width, height: 60+height)
            default:
                labFrame = CGRect.init(x: ( screW-width)/2, y: screH*0.85, width: width, height: 60+height)
            }
    
            toastIndicatorView?.frame = labFrame
            toastIndicatorView?.alpha = 1
            
            let indicatorView = toastIndicatorView?.viewWithTag(10) as! UIActivityIndicatorView
            indicatorView.center = CGPoint.init(x: width/2, y: 70/2)
            indicatorView.startAnimating()
            
            let aLabel = toastIndicatorView?.viewWithTag(11) as! UILabel
            aLabel.frame = CGRect.init(x: 0, y: 60, width: width, height: height)
            aLabel.text = message as String?
        } else {
            DispatchQueue.main.async {
                self.showIndicatorToast(message: message, position: position, aShowTime: aShowTime)
            }
            return
        }
    }
    
    //隐藏(带菊花的消息)
    static func hiddenIndicatorToastAction() {
        if toastIndicatorView != nil {
            let indicatorView = toastIndicatorView?.viewWithTag(10) as! UIActivityIndicatorView
            indicatorView.stopAnimating()
            toastIndicatorView?.alpha = 0
            toastIndicatorView?.removeFromSuperview()
        }
    }
}

//MARK: init UI
extension ToastHud {
    
    static var toastView : UIView?
    static func currentToastView() -> UIView {
        objc_sync_enter(self)
        if toastView == nil {
            toastView = UIView.init()
            toastView?.backgroundColor = UIColor.darkGray
            toastView?.layer.masksToBounds = true
            toastView?.layer.cornerRadius = 5.0
            toastView?.alpha = 0
            
            let indicatorView = UIActivityIndicatorView.init(style: .whiteLarge)
            indicatorView.tag = 10
            indicatorView.hidesWhenStopped = true
            indicatorView.color = UIColor.white
            toastView?.addSubview(indicatorView)
        }
        objc_sync_exit(self)
        return toastView!
    }
    
    static var toastLabel : UILabel?
    static func currentToastLabel() -> UILabel {
        objc_sync_enter(self)
        if toastLabel == nil {
            toastLabel = UILabel.init()
            toastLabel?.backgroundColor = UIColor.darkGray
            toastLabel?.font = UIFont.systemFont(ofSize: 16)
            toastLabel?.textColor = UIColor.white
            toastLabel?.numberOfLines = 0;
            toastLabel?.textAlignment = .center
            toastLabel?.lineBreakMode = .byCharWrapping
            toastLabel?.layer.masksToBounds = true
            toastLabel?.layer.cornerRadius = 5.0
            toastLabel?.alpha = 0;
        }
        objc_sync_exit(self)
        return toastLabel!
    }
    
    static var toastIndicatorView : UIView?
    static func currentToastViewLabel() -> UIView {
        objc_sync_enter(self)
        if toastIndicatorView == nil {
            toastIndicatorView = UIView.init()
            toastIndicatorView?.backgroundColor = UIColor.darkGray
            toastIndicatorView?.layer.masksToBounds = true
            toastIndicatorView?.layer.cornerRadius = 5.0
            toastIndicatorView?.alpha = 0
            
            let indicatorView = UIActivityIndicatorView.init(style: .whiteLarge)
            indicatorView.tag = 10
            indicatorView.hidesWhenStopped = true
            indicatorView.color = UIColor.white
            toastIndicatorView?.addSubview(indicatorView)
            
            let aLabel = UILabel.init()
            aLabel.tag = 11
            aLabel.backgroundColor = UIColor.clear
            aLabel.font = UIFont.systemFont(ofSize: 16)
            aLabel.textColor = UIColor.white
            aLabel.textAlignment = .center
            aLabel.lineBreakMode = .byCharWrapping
            aLabel.layer.masksToBounds = true
            aLabel.layer.cornerRadius = 5.0
            aLabel.numberOfLines = 0;
            toastIndicatorView?.addSubview(aLabel)
        }
        objc_sync_exit(self)
        return toastIndicatorView!
    }
}

//MARK: config
extension ToastHud {
    
    //根据字符串长度获取对应的宽度或者高度
    static func stringText(aText : String?, aFont : CGFloat, isHeightFixed : Bool, fixedValue : CGFloat) -> CGFloat {
        var size = CGSize.zero
        if isHeightFixed == true {
            size = CGSize.init(width: CGFloat(MAXFLOAT), height: fixedValue)
        }else{
            size = CGSize.init(width: fixedValue, height: CGFloat(MAXFLOAT))
        }
        //返回计算出的size
        let resultSize = aText?.boundingRect(with: size, options: (NSStringDrawingOptions(rawValue: NSStringDrawingOptions.usesLineFragmentOrigin.rawValue | NSStringDrawingOptions.usesFontLeading.rawValue | NSStringDrawingOptions.truncatesLastVisibleLine.rawValue)), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: aFont)], context: nil).size
        if isHeightFixed == true {
            return resultSize!.width + 20
        } else {
            return resultSize!.height + 20
        }
    }
}
