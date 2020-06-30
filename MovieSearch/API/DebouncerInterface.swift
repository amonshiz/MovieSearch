//
//  DebouncerInterface.swift
//  MovieSearch
//
//  Created by Andrew Monshizadeh on 6/30/20.
//  Copyright © 2020 Andrew Monshizadeh. All rights reserved.
//

import Foundation

protocol DebouncerInterface {
    /*
     * Debouncers are based around coalescing events based on time, so require
     * that instances init with a time interval
     */
    init(interval: TimeInterval)

    typealias EventHandler = () -> ()
    /*
     * Allows users to add new handlers for when the Debouncer has coalesced
     * events. Each time the Debouncer determines it is appropriate to send the
     * event, it will do so to each of the added handlers.
     */
    func add(_ eventHandler: @escaping EventHandler)

    /*
     * Notify the Debouncer that an event has occured and it should begin the
     * coalescence process.
     */
    func trigger()
}
