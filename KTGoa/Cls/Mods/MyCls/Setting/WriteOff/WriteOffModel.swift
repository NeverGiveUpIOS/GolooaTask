//
//  WriteOffModel.swift
//  Golaa
//
//  Created by Cb on 2024/5/17.
//

import Foundation

class WriteOffModel {
    var title = ""
    var font: UIFont = .systemFont(ofSize: 14)
    var textColor = UIColor.black
    var attrText = NSMutableAttributedString()
    
    static func create(_ index: Int, title: String) -> WriteOffModel {
        let model = WriteOffModel()
        model.title = title
        if index == 0 || index == 3 {
            model.font = .boldSystemFont(ofSize: 18)
            model.textColor = UIColor.black
        } else if index > 3 {
            model.font = .boldSystemFont(ofSize: 14)
            model.textColor = UIColor.hexStrToColor("#FF3C3C")
        } else {
            model.font = .systemFont(ofSize: 14)
            model.textColor = UIColor.black
        }
        
//        let apText = NSMutableAttributedString(string: model.title)
//        apText.yy_font = model.font
//        apText.yy_color = model.textColor
//        if index == 1 {
//            let range = (model.title as NSString).range(of: "contactService".meLocalizable())
//            apText.yy_setTextHighlight(range, color: UIColor.hexColor("#2697FF"), backgroundColor: .clear) { _, attr, _, _ in
//                JKPrint(attr)
//                RoutinStore.pushOnlineService()
//            }
//        }
//        model.attrText.append(apText)
        return model
    }
}
