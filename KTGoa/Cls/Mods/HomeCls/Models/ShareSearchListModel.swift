//
//  ShareSearchListModel.swift
//  Golaa
//
//  Created by duke on 2024/5/22.
//

import UIKit

class ShareSearchListModel: HandyJSON {
    required init() {}
    
    var id = ""
    var avatar = ""
    var name = ""
    // 群人数
    var count = 0
    // 扩展字段
    var isSelected = false
    
    func mapping(mapper: HelpingMapper) {
      mapper <<< avatar <-- ["avatar", "icon"]
      mapper <<< name <-- ["nickname", "name"]
    }
}
