//
//  Routinable.swift
//  Golaa
//
//  Created by Cb on 2024/5/15.
//

import Foundation

protocol Routinable: UIViewController {
    func routerParam(param: Any?, router: RoutinRouter?)
    func routerDeinit()
}

extension Routinable {
    func routerParam(param: Any?, router: RoutinRouter? = nil) {}
    func routerDeinit() {}
}
