//
//  Water.swift
//  Fasting App
//
//  Created by indre zibolyte on 27/03/2022.
//

import Foundation

struct Water {
    
    var id: String
    var date: TimeInterval?
    var count: Int?
    
   init(
    id: String = "\(Int(TimeInterval.today))", // "\(1657702382)", 
    date: TimeInterval? = nil,
    count: Int? = nil) {
        self.id = id
        self.date = date
        self.count = count
    }
    
    init(id: String, data: [String: Any]) {
         self.id = id
         self.date = data["date"] as? TimeInterval
         self.count = data["count"] as? Int

     }
    
    let data = [Water]()

}

extension Water {
    
    var barValue: Float {
        return Float(count ?? 0)
    }
    
    mutating func increase() {
        guard var count = count else { return }
        count += 1
    }
    
    mutating func decrease() {
        guard var count = count else { return }
        count -= 1
    }
    
    mutating func replace(count: Int) {
        self.count = count
    }
    
}
