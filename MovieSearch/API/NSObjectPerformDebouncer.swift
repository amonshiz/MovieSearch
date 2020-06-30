//
//  NSObjectPerformDebouncer.swift
//  MovieSearch
//
//  Created by Andrew Monshizadeh on 6/30/20.
//  Copyright © 2020 Andrew Monshizadeh. All rights reserved.
//

import Foundation

class NSObjectPerformDebouncer: NSObject, DebouncerInterface {
    /// Interval, in seconds, that is used for coalescing events
    private let interval: TimeInterval

    required init(interval: TimeInterval) {
        self.interval = interval
        super.init()
    }

    private var handlers = [EventHandler]()
    func add(_ eventHandler: @escaping EventHandler) {
        handlers.append(eventHandler)
    }

    func trigger() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self._executeHandlers), object: nil)
        self.perform(#selector(self._executeHandlers), with: nil, afterDelay: interval)
    }

    @objc private func _executeHandlers() {
        handlers.forEach { $0() }
    }
}
