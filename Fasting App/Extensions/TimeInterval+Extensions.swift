//
//  TimeInterval+Extensions.swift
//  Fasting App
//
//  Created by indre zibolyte on 25/01/2022.
//

import UIKit

extension TimeInterval {
    
    var timeString: String {
        let hours = Int(self) / 3600
        let minutes = Int(self) / 60 % 60
        let seconds = Int(self) % 60
        return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    var dayCharacter: String {
        let date = Date(timeIntervalSince1970: self)
        let day = Calendar.current.component(.weekday, from: date)
        switch day {
        case 1: return "S"
        case 2: return "M"
        case 3: return "T"
        case 4: return "W"
        case 5: return "T"
        case 6: return "F"
        case 7: return "S"
        default: return ""

        }
    }
}

public extension TimeInterval {
    
    static var today: TimeInterval {
        return Calendar.current.startOfDay(for: Date()).timeIntervalSince1970
    }
}
