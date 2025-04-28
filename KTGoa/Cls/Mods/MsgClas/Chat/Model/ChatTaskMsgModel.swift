//
//  ChatTaskMsgModel.swift
//  Golaa
//
//  Created by chenkaisong on 2024/5/16.
//

class TaskCustomAttachMent: NSObject, NIMCustomAttachment, JsonModelProtocol {
    
    var code: Int = 0
    var type: ChatCusMsgType = .task
    var msg: TaskCustomModel?
    
    func encode() -> String {
        let jsonstring = self.toJSONString()
        return jsonstring ?? ""
    }
    
    required override init() {
        super.init()
    }
}

class TaskCustomModel: JsonModelProtocol {
    
    /// 任务名称
    var title: String = ""
    /// 任务单价
    var content: String = ""
    /// 任务图片
    var cover: String = ""
    /// 任务id
    var id: String = ""

    required  init() {
    }
    
}
