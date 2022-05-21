//
//  DataSet.swift
//  Fasting App
//
//  Created by indre zibolyte on 17/04/2022.
//

import Foundation

public struct Dataset {
    
    public let value: Double
    public let timestamp: Int
    
    public init(value: Double, timestamp: Int) {
        self.value = value
        self.timestamp = timestamp
    }
    
}

extension Dataset: Comparable {
    
    public static func < (lhs: Dataset, rhs: Dataset) -> Bool {
        return lhs.value < rhs.value
    }
    
    public static func == (lhs: Dataset, rhs: Dataset) -> Bool {
        return lhs.value == rhs.value
    }
    
}
