//
//  SafeDictionary.swift
//  Golaa
//
//  Created by Cb on 2024/5/29.
//

import Foundation

class SafeDictionary<Key: Hashable, Value> {
    private var infos: [Key: Value] = [:]
    private let lock = NSLock()

    func setValue(_ value: Value, for key: Key) {
        lock.lock()
        defer { lock.unlock() }
        infos[key] = value
    }

    func value(for key: Key) -> Value? {
        lock.lock()
        defer { lock.unlock() }
        return infos[key]
    }

    func resetRequestState(_ state: Value, for key: Key) {
        lock.lock()
        defer { lock.unlock() }
        infos[key] = state
    }
}
