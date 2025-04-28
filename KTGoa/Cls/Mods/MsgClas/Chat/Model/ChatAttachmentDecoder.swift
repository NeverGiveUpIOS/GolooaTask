//
//  ChatCustomDecoder.swift
//  Golaa
//
//  Created by chenkaisong on 2024/5/24.
//

class ChatMainDecoder: NSObject, NIMCustomAttachment, JsonModelProtocol {
    
    var code: Int = 0
    var type: ChatCusMsgType = .gift
    var msg: String = ""
    
    func encode() -> String {
        let jsonstring = self.toJSONString()
        return jsonstring ?? ""
    }
    
    required override init() {
        super.init()
    }
}

class ChatAttachmentDecoder: NSObject, NIMCustomAttachmentCoding, HandyJSON {
    
    func decodeAttachment(_ content: String?) -> (any NIMCustomAttachment)? {
        
        debugPrint("自定义消息的数据类型:\(content ?? "")")
        
        guard let content = content, let mainDecoder = ChatMainDecoder.deserialize(from: content) else { return nil }

        switch mainDecoder.type {
        case .gift:
            let model = GiftCustomAttachMent.deserialize(from: content)
            return model
        case .task:
            let model = TaskCustomAttachMent.deserialize(from: content)
            return model
        default:
            return nil
        }
        
    }
    
    required override init() {
        super.init()
    }
    
}

enum ChatCusMsgType: Int, HandyJSONEnum {
    case task =  600
    case gift =  800
    case other =  10000
}
