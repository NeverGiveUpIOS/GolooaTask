//
//  GTBas.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/7/23.
//

import UIKit
import Foundation

public protocol GTCompble {}

public struct GTBas<Base> {
    
    let bas: Base
    
    init(_ base: Base) {
        self.bas = base
    }
}

public extension GTCompble {
    
    static var gt: GTBas<Self>.Type {
        get{ GTBas<Self>.self }
        set {}
    }
    
    var gt: GTBas<Self> {
        get { GTBas(self) }
        set {}
    }
    
}

internal protocol GTProComble {
    
    associatedtype T
    
    typealias StCallBack = ((T?) -> ())
    var stCallBack: StCallBack?  { get set }
    
}

