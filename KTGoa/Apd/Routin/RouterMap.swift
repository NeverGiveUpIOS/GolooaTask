//
//  RouterMap.swift
//  Golaa
//
//  Created by Cb on 2024/5/27.
//

import Foundation

// gl:///task/index
enum RouterMapType: CaseIterable {
    case htps
    case htp
    case gl
    
    var rawValue: String {
        switch self {
        case .htps:
            "https://"
        case .htp:
            "http://"
        case .gl:
            "gl://"
        }
    }
    
    var isGl: Bool { self == .gl }
    var isHtp: Bool { self == .htp || self == .htps }
    
    static var contents: [String] { allCases.map({ $0.rawValue }) }
}

extension RoutinStore {
    
    static func pushUrl(_ url: String) {
                
        if let result = RouterMapType.allCases.filter({ url.hasPrefix($0.rawValue) }).last {
            if result.isHtp {
                 RoutinStore.push(.webScene(.url(url)))
            } else {
                let lists = url.components(separatedBy: result.rawValue)
//                gl:///task/publish/view?id=${id}
                if lists.count > 1, let last = lists.last {
                    var first = lists[1]
                    var param: String?
                    if last.contains("?") {
                        let firstLists = last.components(separatedBy: "?")
                        first = firstLists[0]
                        
                        if firstLists.count > 1, let last = firstLists.last {
                            if !last.contains("&") && last.contains("=") {
                                let eqLists = last.components(separatedBy: "=")
                                if eqLists.count > 1, let paLast = eqLists.last {
                                    param = paLast
                                }
                            }
                        }
                    }
                    
                    if let last = RoutinRouter.urlPathCases.filter({ $0.urlPath == first }).last {
                        if last == .auth && (LoginTl.shared.userInfo?.isPublish ?? false ) { // 判断是否已经认证过
                            ToastHud.showToastAction(message: "youBaveIserified".msgLocalizable())
                            return
                        }
                        RoutinStore.push(last, param: param)
                    }
                }
            }
        }
    }
    
}
