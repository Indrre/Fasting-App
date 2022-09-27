//
//  Service.swift
//  Fasting App
//
//  Created by indre zibolyte on 23/01/2022.
//

import Firebase
import UIKit

// =================================
// MARK: - DatabaseRefs
// =================================

let DBREF = Database.database().reference()
let REFUSERS = DBREF.child("users")
let REFFASTS = DBREF.child("fasts")
let REFWATER = DBREF.child("water")
let REFWEIGHT = DBREF.child("weight")

// =================================
// MARK: - Shared Service
// =================================

struct Service {
    
    static var shared = Service()
    var image = UIImage()
    
    // MARK: - User
    
    func fetchUserData(uid: String, completion: @escaping(User) -> Void) {
        REFUSERS.child(uid).observeSingleEvent(of: .value) { (returningData) in
            guard let dictionary = returningData.value as? [String: Any] else { return }
            
            let uid = returningData.key
            let user = User(uid: uid, dictionary: dictionary)
            
            completion(user)
        }
    }
    
    func updateUserValues(values: [String: Any]) {
        // Sets and updates database with values
        guard let uid = Auth.auth().currentUser?.uid else { return }
        REFUSERS.child(uid).updateChildValues(values)
    }
    
    // MARK: - Water
    
    func fetchWaterData(id: String, completion: @escaping ((Water?, Error?) -> Void)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let path = String(format: "%@/%@", uid, id)
        REFWATER.child(path).observeSingleEvent(of: .value) { (returningData) in
            guard let dictionary = returningData.value as? [String: Any] else { return }
            let date = dictionary["date"] as? TimeInterval ?? nil
            let count = dictionary["count"] as? Int ?? 0
            
            let object = Water(
                id: id,
                date: date ?? 0,
                count: count
            )
            completion(object, nil)
        }
        
    }
    
    func updateWater(_ water: Water) {
        // Sets and updates database with values
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let params: [String: Any] = [
            "date": water.date as Any,
            "count": water.count ?? 0
        ]
        
        let path = String(format: "%@/%@", uid, water.id)
        REFWATER.child(path).updateChildValues(params)
        WaterService.fetchAllWater()
    }
    
    mutating func fetchAllWater(
        completion: @escaping (([Water]?, Error?) -> Void)) {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            REFWATER.child(uid).observeSingleEvent(of: .value) { (returningData) in
                guard let dictionary = returningData.value as? [String: Any] else {
                    return
                }
                
                let array = dictionary.keys.compactMap { key in
                    return Water(
                        id: key,
                        data: dictionary[key] as? [String: Any] ?? [:])
                }
                completion(array, nil)
            }
        }
    
    // MARK: - Fast
    
    func updateUserFast(values: [String: Any]) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        REFFASTS.child(uid).updateChildValues(values)
    }
    
    mutating func fetchFasts(
        completion: @escaping (([Fast]?, Error?) -> Void)) {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            REFFASTS.child(uid).observeSingleEvent(of: .value) { (returningData) in
                guard
                    let dictionary = returningData.value as? [String: Any] else {
                    return
                }
                let array = dictionary.keys.compactMap { key in
                    return Fast(
                        id: key,
                        data: dictionary[key] as? [String: Any] ?? [:]
                    )
                }
                completion(array, nil)
            }
        }
    
    /**
     Fetch an individual fast from the database
     - Parameter id: String
     - Parameter completion: @escaping ((Fast?, Error?) -> Void)
     */
    func fetchFast(
        id: String,
        completion: @escaping ((Fast?, Error?) -> Void)) {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            let path = String(format: "%@/%@", uid, id)
            REFFASTS.child(path).observeSingleEvent(of: .value) { (returningData) in
                
                guard let dictionary = returningData.value as? [String: Any] else { return }
                let start = dictionary["start"] as? TimeInterval ?? nil
                let timeSelected = dictionary["timeSelected"] as? TimeInterval ?? nil
                
                let object = Fast(
                    id: id,
                    start: start,
                    end: dictionary["end"] as? TimeInterval,
                    timeSelected: timeSelected ?? 0
                )
                completion(object, nil)
            }
        }
    
    /**
     Save/Update fast to the database
     - Parameter fast: Fast
     */
    func updateFast(_ fast: Fast) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        var params: [String: Any] = [
            "start": fast.start as Any,
            "timeSelected": fast.timeSelected
        ]
        
        if let end = fast.end { params["end"] = end }
        
        let path = String(format: "%@/%@", uid, fast.id)
        REFFASTS.child(path).updateChildValues(params)
    }
    
// MARK: - Weight
    
    func updateUserWeight(_ weight: Weight) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let unit = weight.unit else { return }
        let params: [String: Any] = [
            "date": weight.date as Any,
            "count": weight.count ?? 0,
            "unit": unit
        ]
        
        let path = String(format: "%@/%@", uid, weight.id)
        REFWEIGHT.child(path).updateChildValues(params)
        WeightService.fetchAllWeight()
    }
    
    func fetchWeight(id: String, completion: @escaping ((Weight?, Error?) -> Void)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let path = String(format: "%@/%@", uid, id)
        
        REFWEIGHT.child(path).observeSingleEvent(of: .value) { ( returningData) in
            guard let dictionary = returningData.value as? [String: Any] else { return }
            
            let date = dictionary["date"] as? TimeInterval ?? nil
            let count = dictionary["count"] as? Int
            let unit = dictionary["unit"] as? String ?? ""
            
            let object = Weight(
                id: id,
                date: date,
                count: count,
                unit: unit
            )
            completion(object, nil)
        }
    }
    
    mutating func fetchAllWeight(
        completion: @escaping (([Weight]?, Error?) -> Void)) {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            REFWEIGHT.child(uid).observeSingleEvent(of: .value) { (returningData) in
                guard let dictionary = returningData.value as? [String: Any] else {
                    return
                }
                
                let array = dictionary.keys.compactMap { key in
                    return Weight(
                        id: key,
                        data: dictionary[key] as? [String: Any] ?? [:])
                }
                completion(array, nil)
            }
        }
}
