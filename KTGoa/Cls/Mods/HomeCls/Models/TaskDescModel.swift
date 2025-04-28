//
//  TaskDescModel.swift
//  Golaa
//
//  Created by duke on 2024/5/20.
//

import UIKit

enum TaskDescRecStatus: Int, HandyJSONEnum {
    case canRec = 0         // 可领取
    case reced = 1          // 已领取
    case unrec = 2          // 不可领取
}

class TaskDescUser: HandyJSON {
    required init() {}
    var pubName = ""
    var name = ""
    var id = ""
    var avatar = ""
    
    func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &pubName, name: "publishName")
    }
}

class TaskDescModel: HandyJSON {
    required init() {}
    // 任务总数
    var num = 0
    var img = ""
    var startDate = 0
    var endDate = 0
    var id = 0
    var iro = ""
    // 是否为任务发布者
    var isOwr = false
    // 领取任务是否开启审核
    var isReVery = false
    // 是否已担保
    var isSecity = false
    var name = ""
    var jiage = 0.00
    var jiageDes = ""
    // 已领取数量
    var recCount = 0
    // 领取人数
    var recNum = 0
    var recStatus: TaskDescRecStatus = .canRec
    var steps: [TaskStepModel] = []
    // 任务剩余时间（秒数），为0时代表已结束
    var surSec = 0
    // 任务剩余数量
    var surCount = 0
    // 类型：0=注册；
    var type = 0
    var traLink = ""
    var user = TaskDescUser()
    var userId = ""
    var isStart = false // 是否已开始
    var status = 0 // 任务状态：2=进行中；3=已结束；
    
    // 扩展字段
    var surTime: String {
        var surTime = ""
        let hours = (surSec / 3600) % 24
        let minutes = (surSec / 60) % 60
        let seconds = surSec % 60
        let day = surSec / 86400
        surTime.append(String(format: "%02d", minutes))
        surTime.append(":")
        surTime.append(String(format: "%02d", seconds))
        if hours > 0 {
            surTime.insert(contentsOf: ":", at: surTime.startIndex)
            surTime.insert(contentsOf: String(format: "%02d", hours), at: surTime.startIndex)
        }
        if day > 0 {
            surTime.insert(contentsOf: ":", at: surTime.startIndex)
            surTime.insert(contentsOf: String(format: "%02d", day), at: surTime.startIndex)
        }
        return surTime
    }
    
    func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &num, name: "count")
        mapper.specify(property: &img, name: "cover")
        mapper.specify(property: &startDate, name: "startTime")
        mapper.specify(property: &endDate, name: "endTime")
        mapper.specify(property: &iro, name: "intro")
        mapper.specify(property: &isOwr, name: "isOwner")
        mapper.specify(property: &isReVery, name: "isReceiveVerify")
        mapper.specify(property: &isSecity, name: "isSecurity")
        mapper.specify(property: &jiage, name: "price")
        mapper.specify(property: &jiageDes, name: "price_")
        mapper.specify(property: &recCount, name: "receiveCount")
        mapper.specify(property: &recNum, name: "receiveNum")
        mapper.specify(property: &recStatus, name: "receiveStatus")
        mapper.specify(property: &surSec, name: "surplusSecond")
        mapper.specify(property: &surCount, name: "surplusCount")
        mapper.specify(property: &traLink, name: "traceLink")
        mapper.specify(property: &isStart, name: "begin")
    }
}
