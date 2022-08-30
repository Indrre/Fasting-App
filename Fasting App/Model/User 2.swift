//
//  User.swift
//  Fasting App
//
//  Created by indre zibolyte on 23/01/2022.
//

import Foundation
import UIKit

struct User {
    
    let email: String
    let uid: String
    let fullName: String
    let imageURL: String?
    let age: Int?
    let weight: Double?
    let weightUnit: String?
    let heightFirstUnit: Double?
    let heightSecondUnit: Double?
    let heightMsureUnit: String?
    let gender: String?
    let activity: String?
    let timeSelected: Int?
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.email = dictionary["email"] as? String ?? ""
        self.fullName = dictionary["fullName"] as? String ?? ""
        self.imageURL = dictionary["imageURL"] as? String ?? ""
        self.age = dictionary["age"] as? Int ?? 18
        self.weight = dictionary["weight"] as? Double ?? 0
        self.weightUnit = dictionary["weightUnit"] as? String ?? "kg"
        self.heightFirstUnit = dictionary["heightFirstUnit"] as? Double ?? 0
        self.heightSecondUnit = dictionary["heightSecondUnit"] as? Double ?? 0
        self.heightMsureUnit = dictionary["heightUnit"] as? String ?? "m"
        self.gender = dictionary["gender"] as? String ?? "Female"
        self.activity = dictionary["activity"] as? String ?? "Inactive"
        self.timeSelected = dictionary["timeSelected"] as? Int

    }
}
