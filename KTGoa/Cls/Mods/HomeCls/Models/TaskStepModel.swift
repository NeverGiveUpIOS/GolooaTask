//
//  TaskStepModel.swift
//  Golaa
//
//  Created by duke on 2024/5/16.
//

import UIKit

enum TaskStepType {
    case add  // 添加步骤
    case addLast  // 添加步骤(只有完成，没有加号)
    case edit // 编辑步骤
    case step // 后台返回的步骤（图片和文本）
    case finish // 完成步骤
    
    var cellId: String {
        switch self {
        case .add, .addLast:
            return NSStringFromClass(TaskStepAddCell.self)
        default:
            return NSStringFromClass(TaskStepCell.self)
        }
    }
}

class TaskStepModel: HandyJSON {
    required init() {}
    
    var explain = ""
    var icon = ""
    
    // 扩展字段
    var stepNum = 1
    var type: TaskStepType = .step
    var image: UIImage?
    var isShowDelete = false
    
    var cellHeight: CGFloat {
        var height = 0.0
        switch type {
        case .add, .addLast:
            height += 33
        case .edit:
            let text = explain.isEmpty ? "editTaskImageAndTextInstructions".homeLocalizable() : explain
            let textSize = text.boundingRect(with: CGSize(width: screW - 74 - 15, height: CGFloat(MAXFLOAT)), options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [.font: UIFontReg(13)], context: nil).size
            let textHeight = textSize.height + 10
            height += textHeight
            height += 12
            height += 120
            height += 34
        case .step:
            let text = explain
            let textSize = text.boundingRect(with: CGSize(width: screW - 74 - 15, height: CGFloat(MAXFLOAT)), options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [.font: UIFontReg(13)], context: nil).size
            let textHeight = textSize.height + 10
            height += textHeight
            height += 12
            if image == nil, icon.isEmpty {
                height += 20
            } else {
                height += 120
            }
            height += 34
        case .finish:
            height += 34
        }
        
        return height
    }
    
    func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &explain, name: "desc")
        mapper.specify(property: &icon, name: "img")
    }
}
