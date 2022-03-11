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

let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("users")
let REF_FASTS = DB_REF.child("fasts")

// =================================
// MARK: - Shared Service
// =================================

struct Service {
    
    static let shared = Service()
    var image = UIImage()
    
    func fetchUserData(uid: String, completion: @escaping(User) -> Void) {
        REF_USERS.child(uid).observeSingleEvent(of: .value) { (returningData) in
            guard let dictionary = returningData.value as? [String: Any] else { return }
        
            let uid = returningData.key
            let user = User(uid: uid, dictionary: dictionary)
            
            completion(user)
        }
    }
    
    func updateUserValues(values: [String: Any]) {
        // Sets and updates database with values
        guard let uid = Auth.auth().currentUser?.uid else { return }
        REF_USERS.child(uid).updateChildValues(values)
    }
    
    func updateUserFast(values: [String: Any]) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        REF_FASTS.child(uid).updateChildValues(values)
    }
    
    func fetchFasts(
        completion: @escaping (([Fast]?, Error?) -> Void)) {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            REF_FASTS.child(uid).observeSingleEvent(of: .value) { (returningData) in
                guard
                    let dictionary = returningData.value as? [String: Any],
                    let start = dictionary["start"] as? TimeInterval,
                    let timeSelected = dictionary["timeSelected"] as? TimeInterval else {
                        completion(nil, NSError(domain: "", code: 1000, userInfo: ["message": "missing fast"]))
                        return
                    }

//                let object = Fast(
//                    id: id,
//                    start: start,
//                    end: dictionary["end"] as? TimeInterval,
//                    timeSelected: timeSelected
//                )

//                completion(object, nil)
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
            REF_FASTS.child(path).observeSingleEvent(of: .value) { (returningData) in
                
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
        REF_FASTS.child(path).updateChildValues(params)
    }
    
}
