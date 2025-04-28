//
//  TaskPublishModel.swift
//  Golaa
//
//  Created by duke on 2024/5/17.
//

import UIKit

class TaskPublishModel: NSObject {
    var name: String = ""
    var link: String = ""
    var logo: UIImage?
    var cover: String = ""
    var price: String = ""
    var intro: String = ""
    var startTime: String = ""
    var endTime: String = ""
    var count: Int = 0
    var stepArr: [TaskStepModel] = []
    var steps: String {
        let dict = stepArr
            .filter { $0.type == .edit }
            .map { model in
            var dict: [String: Any] = [:]
            dict["img"] = model.icon
            dict["desc"] = model.explain
            return dict
        }
        let json = dict.toJSON()
        return json ?? ""
    }
}
