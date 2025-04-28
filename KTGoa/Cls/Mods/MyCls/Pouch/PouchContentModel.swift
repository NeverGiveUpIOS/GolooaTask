//
//  PouchContentModel.swift
//  Golaa
//
//  Created by Cb on 2024/5/23.
//

import Foundation

class PouchContentModel: JsonModelProtocol {
    required init() {}
    var type: PouchContentType = .agent
    var model: HomeBalanceAccount = HomeBalanceAccount()
    
    static func createForType(_ type: PouchContentType, model: HomeBalanceModel) -> PouchContentModel {
        let result = PouchContentModel()
        result.type = type
        if type == .task {
            result.model = model.taskAcc
        } else if type == .agent {
            result.model = model.agentAcc
        } else if type == .ensure {
            result.model = model.depositAcc
        } else if type == .coin {
            result.model = model.goldAcc
        }
        return result
    }
    
}
