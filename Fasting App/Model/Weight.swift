//
//  Weight.swift
//  Fasting App
//
//  Created by indre zibolyte on 17/04/2022.
//

import Foundation

struct Weight {
    
    var id: String
    var date: TimeInterval?
    var count: Int?
    var unit: String?
    
    init(
     id: String = "\(Int(TimeInterval.today))",
     date: TimeInterval? = nil,
     count: Int? = nil,
     unit: String) {
         self.id = id
         self.date = date
         self.count = count
         self.unit = unit
     }
     init(id: String, data: [String: Any]) {
          self.id = id
          self.date = data["date"] as? TimeInterval
          self.count = data["count"] as? Int
          self.unit = data["unit"] as? String
      }
     let data = [Weight]()
    
}
