//
//  PouchDetailModel.swift
//  Golaa
//
//  Created by Cb on 2024/5/23.
//

import Foundation

class PouchDetailModel: JsonModelProtocol {
    required init() {}
    
    // 流水ID
    var id = ""
    
    // 时间
    var addTime_ = ""

    // 内容中需要高亮的文本
    var highlight = ""

    // 描述内容
    var content = ""

    // 本次流水关联的任务ID
    var taskId = ""

    // 资金流向：1=收入；0=不变；-1=支出；
    var flow = ""
    
    var amountDetail = 0

    var amountDesc = ""

    var contentSize: CGSize = CGSize(width: screW - 15 * 2.0, height: 63)
    
    var amountColor: UIColor {
        flow == "1" ? UIColor.hexStrToColor("#2697FF") : (flow == "-1" ? UIColor.hexStrToColor("#F96464") : UIColor.hexStrToColor("#000000"))
    }
    
    func setAttrContent() {
        let range = (content as NSString).range(of: highlight)
        let attr = NSMutableAttributedString(string: content, attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.hexStrToColor("#000000")])
        attr.addAttributes([.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.hexStrToColor("#F99F35")], range: range)
        attrContent = attr
    }
    
    var attrContent: NSAttributedString = NSAttributedString(string: "")
    
    func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &amountDetail, name: "tradeAmount")
        mapper.specify(property: &amountDesc, name: "tradeAmount_")
    }

    func configureContentSize() {
        let width = (screW - 15 * 2.0)
        let height = getContentHeight() + 23 + 20
        let rowHeight = height > 63 ? height : 63
        setAttrContent()
        debugPrint("configureHeight = \(height)")
        let size: CGSize = CGSize(width: width, height: rowHeight)
        contentSize = size
    }
    
    func getDisplayContentSize(row: Int, total: Int) -> CGSize {
        let width = contentSize.width
        let rowHeight = contentSize.height
        if total == 1 {
            return CGSize(width: width, height: rowHeight + 20)
        } else if row == 0 {
            return CGSize(width: width, height: rowHeight + 10)
        } else if row == total - 1 {
            return CGSize(width: width, height: rowHeight + 10)
        }
        return contentSize
    }
    
    private func getContentHeight() -> CGFloat {
        let amountWidth = amountDesc.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 20), options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [.font: UIFont.boldSystemFont(ofSize: 16)], context: nil).size.width
        let width = (screW - 15 * 4.0 - 5 - amountWidth)
        let textSize = content.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [.font: UIFontReg(13)], context: nil).size
        return textSize.height
    }

}
