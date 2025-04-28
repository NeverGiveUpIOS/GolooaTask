//
//  HomeListModel.swift
//  Golaa
//
//  Created by duke on 2024/5/14.
//

import UIKit

/*
 "count": 10000,
 "cover": "http://fulala.comn",
 "id": 1000,
 "name": "测试",
 "price": 20,
 "price_": "$20.00",
 "receiveCount": 0,
 "receiveNum": 0,
 "surplusCount": 10000,
 "type": 0,
 "userId": "d3"
 */
class HomeListModel: HandyJSON {
    required init() {}
    
    var num = 0
    var img = ""
    var id = 0
    var name = ""
    var intro = ""
    var pic = 0
    var picDes = ""
    
    var startTime = 0
    var endTime = 0
    
    var depositPic = 0
    var depositDes = ""
    var finishCount = ""
    var status = -1
    var statusDesc = ""
    
    var statusScene: ChorePublishScene { ChorePublishScene.caseStatus(status) ?? .all }
    var choreStatusScene: ChoreRecordScene { ChoreRecordScene.caseStatus(status) ?? .all }
    
    var settleDateDesc = ""
    var consumeDesc = ""
    
    var income = 0
    var incomeDesc = ""
    
    var receNum = 0
    var receCount = 0
    var isDanbao = false
    // 任务类型：0=推广注册
    var tpye = 0
    var userId = ""
    
    // 扩展字段
    var search = ""
    
    // 需要额外支付的担保金说明
    var supplyDeposit = ""
    
    var contentSize: CGSize = CGSize(width: (screW - 15 * 2.0), height: 187)
    
    func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &num, name: "count")
        mapper.specify(property: &img, name: "cover")
        mapper.specify(property: &pic, name: "price")
        mapper.specify(property: &picDes, name: "price_")
        mapper.specify(property: &depositPic, name: "depositPrice")
        mapper.specify(property: &depositDes, name: "depositPrice_")
        mapper.specify(property: &statusDesc, name: "status_")
        mapper.specify(property: &incomeDesc, name: "income_")
        mapper.specify(property: &receNum, name: "receiveNum")
        mapper.specify(property: &receCount, name: "receiveCount")
        mapper.specify(property: &isDanbao, name: "isSecurity")
        mapper.specify(property: &tpye, name: "type")
        mapper.specify(property: &consumeDesc, name: "consume_")
        mapper.specify(property: &settleDateDesc, name: "settleDate_")
    }
    
    func didFinishMapping() {
        if GlobalHelper.shared.inEndGid {
            picDes = ""
        }
    }
    
    func configureContentSize(_ isDetail: Bool = false) {
        let width = (screW - 15 * 2.0)
        let height = getContentHeight(isDetail)
        debugPrint("configureHeight = \(height)")
        let size: CGSize = CGSize(width: width, height: height)
        contentSize = size
    }
    
    private func getContentHeight(_ isDetail: Bool = false) -> CGFloat {
        if !supplyDeposit.isEmpty {
            let nameHeight = name.boundingRect(with: CGSize(width: screW - 15 * 4.0 - 66 - 12, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [.font: UIFont.boldSystemFont(ofSize: 14)], context: nil).size.height
            let spaceHeight = nameHeight > 17 ? 16.0 : 0
            
            let statusWidth = isDetail ? 0 : statusDesc.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 20), options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [.font: UIFont.systemFont(ofSize: 12)], context: nil).size.width + 4 + 15 + 5
            let width = (screW - 15 * 4.0 - 66 - 12 - statusWidth)
            let textSize = supplyDeposit.boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [.font: UIFontReg(11)], context: nil).size
            let height = textSize.height > 14 ? textSize.height - 20 + 187 : 187
            return height + spaceHeight
        }
        return 187
    }
    
}
