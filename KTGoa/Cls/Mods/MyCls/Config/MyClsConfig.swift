//
//  MyClsConfig.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/8/8.
//

import UIKit

enum PouchContentType: CaseIterable {
    case task
    case ensure
    case coin
    case agent

    var rawValue: String {
        switch self {
        case .task:
            return "taskEarnings".meLocalizable()
        case .ensure:
            return "deposit".meLocalizable()
        case .coin:
            return "coinEarnings".meLocalizable()
        case .agent:
            return "agencyEarnings".meLocalizable()
        }
    }
    
    func showTextColor(totalAmt: Double) -> UIColor {
        switch self {

        case .task:
            return UIColor.hexStrToColor("#000000")
        case .ensure:
            return totalAmt < 0 ? UIColor.hexStrToColor("#F96464") : UIColor.hexStrToColor("#2697FF")
        case .coin:
            return UIColor.hexStrToColor("#000000")
        case .agent:
            return UIColor.hexStrToColor("#000000")
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .task:
            return UIColor.hexStrToColor("#000000")
        case .ensure:
            return UIColor.hexStrToColor("#F96464")
        case .coin:
            return UIColor.hexStrToColor("#000000")
        case .agent:
            return UIColor.hexStrToColor("#000000")
        }
    }
    
    static func caseModel(_ model: HomeBalanceModel) -> [PouchContentModel] {
        allCases.map({ PouchContentModel.createForType($0, model: model) })
    }
}

public protocol SectionModelType {
    associatedtype Item

    var items: [Item] { get }

    init(original: Self, items: [Item])
}
