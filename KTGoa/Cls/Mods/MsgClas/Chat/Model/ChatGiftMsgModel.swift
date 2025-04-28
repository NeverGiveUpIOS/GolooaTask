//
//  ChatGiftCustomDecoder.swift
//  Golaa
//
//  Created by chenkaisong on 2024/5/23.
//

class GiftCustomAttachMent: NSObject, NIMCustomAttachment, HandyJSON {
    
    var code: Int = 0
    var type: ChatCusMsgType = .gift
    var msg: GiftMsgItemModel?
    
    func encode() -> String {
        let jsonstring = self.toJSONString()
        return jsonstring ?? ""
    }
    
    required override init() {
        super.init()
    }
}

class GiftMsgItemModel: JsonModelProtocol {
    
    var amount = ""
    var eventType = ""
    var num = ""
    var gift: GiftItemModel?
    
    required init() {
    }
}

class GiftItemModel: JsonModelProtocol {
    
    var actIsScreen = ""
    var chatOpen = ""
    var coin = ""
    var icon = ""
    var id = ""
    var isAvgView = ""
    var name = ""
    var quick = ""
    var sendCount = ""
    var url = ""
    var vipLevel = ""
    var isSelected = false
    
    required init() {
    }
}
