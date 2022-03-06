//
//  Fast.swift
//  Fasting App
//
//  Created by indre zibolyte on 23/02/2022.
//

import Foundation

struct Fast {
    
    let id: String
    var start: TimeInterval?
    var end: TimeInterval?
    var timeSelected: TimeInterval
    
    init(
        id: String = UUID().uuidString,
        start: TimeInterval? = nil,
        end: TimeInterval? = nil,
        timeSelected: TimeInterval) {
            self.id = id
            self.start = start
            self.end = end
            self.timeSelected = timeSelected
        }
    
}

extension Fast {
    
    mutating func updateStart(interval: TimeInterval) {
        start = interval
    }
    
    mutating func updateEnd(interval: TimeInterval) {
        end = interval
    }
    
    mutating func updateTimeSelected(interval: TimeInterval) {
        timeSelected = interval
    }
    
    var timeLapsed: TimeInterval {
        // If user has added end time return the difference
        if let end = end {
            return end - (start ?? 0)
        }
        return Date().timeIntervalSince1970 - (start ?? 0)
    }
    
}
