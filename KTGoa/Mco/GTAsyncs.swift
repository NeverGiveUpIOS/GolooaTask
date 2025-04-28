//
//  GTAsyncs.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/8/1.
//

import Foundation

public typealias GTTask = () -> Void

// MARK: - 延迟事件
public struct GTAsyncs {
    /// 异步做一些任务
    /// - Parameter GTTask: 任务
    @discardableResult
    public static func async(_ GTTask: @escaping GTTask) -> DispatchWorkItem {
        return _asyncDelay(0, GTTask)
    }
    
    /// 异步做任务后回到主线程做任务
    /// - Parameters:
    ///   - GTTask: 异步任务
    ///   - mainGTTask: 主线程任务
    @discardableResult
    public static func async(_ GTTask: @escaping GTTask,
                             _ mainGTTask: @escaping GTTask) -> DispatchWorkItem{
        return _asyncDelay(0, GTTask, mainGTTask)
    }
    
    /// 异步延迟(子线程执行任务)
    /// - Parameter seconds: 延迟秒数
    /// - Parameter GTTask: 延迟的block
    @discardableResult
    public static func asyncDelay(_ seconds: Double,
                                  _ GTTask: @escaping GTTask) -> DispatchWorkItem {
        return _asyncDelay(seconds, GTTask)
    }
    
    /// 异步延迟回到主线程(子线程执行任务，然后回到主线程执行任务)
    /// - Parameter seconds: 延迟秒数
    /// - Parameter GTTask: 延迟的block
    /// - Parameter mainGTTask: 延迟的主线程block
    @discardableResult
    public static func asyncDelay(_ seconds: Double,
                                  _ GTTask: @escaping GTTask,
                                  _ mainGTTask: @escaping GTTask) -> DispatchWorkItem {
        return _asyncDelay(seconds, GTTask, mainGTTask)
    }
}

// MARK: - 私有的方法
extension GTAsyncs {
    
    /// 延迟任务
    /// - Parameters:
    ///   - seconds: 延迟时间
    ///   - GTTask: 任务
    ///   - mainGTTask: 任务
    /// - Returns: DispatchWorkItem
    fileprivate static func _asyncDelay(_ seconds: Double,
                                        _ GTTask: @escaping GTTask,
                                        _ mainGTTask: GTTask? = nil) -> DispatchWorkItem {
        let item = DispatchWorkItem(block: GTTask)
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + seconds,
                                          execute: item)
        if let main = mainGTTask {
            item.notify(queue: DispatchQueue.main, execute: main)
        }
        return item
    }
}
