//
//  PersonalInfo.swift
//  Fasting App
//
//  Created by indre zibolyte on 24/02/2022.
//

import Foundation

public enum PersonalInfo: String {
    case age, weight, height, gender, activity
}


extension PersonalInfo {
    
    var title: String {
        return rawValue.capitalized
    }
    
}
