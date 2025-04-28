//
//  HomeTaskListInfo.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/7/27.
//

import UIKit

struct HomeTaskListInfo: Codable {
    var code: Int = 0
    var data: HomeTaskInfo?
    var status: String = ""
}

struct HomeTaskInfo: Codable {
    var list: [TaskListInfo]?
}

struct TaskListInfo: Codable {
    
    var cover = ""
    var intro = ""
    var name = ""
    var endTime = Double(0)
    var startTime = Double(0)
    var receiveCount = 0
    var count = 0
    
}
