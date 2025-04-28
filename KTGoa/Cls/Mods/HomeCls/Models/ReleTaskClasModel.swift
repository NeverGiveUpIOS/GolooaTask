//
//  ReleTaskClasModel.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/7/26.
//

import UIKit


struct ReleTaskClasModel {
    
    var taskName = ""
    var taskicon : UIImage?
    var taskDes = ""
    var taskStartTime = ""
    var taskEndTime = ""
    
    /// 是否完成
    var isCompletion = false
    
    var oneStep = ReleTaskClasStepModel()
    var twoStep = ReleTaskClasStepModel()
    var threeStep = ReleTaskClasStepModel()

}

struct ReleTaskClasStepModel {
    var taskDes = ""
    var taskIcon: UIImage?
}
