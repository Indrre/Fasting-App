//
//  UserService.swift
//  Fasting App
//
//  Created by indre zibolyte on 25/01/2022.
//

import Foundation
import Firebase
import FirebaseAuth

// This is the protocol for the service
protocol UserServiceObserver: AnyObject {
    func userServiceUserUpdated(_ user: User?)
}

class UserService {
    
    fileprivate struct _UserServiceObserver {
        weak var observer: UserServiceObserver?
        
        var isValid: Bool {
            return observer != nil
        }
    }
    
    /**
     Appends a `SocketObserver` delegate to the Singleton store
     */
    public class func startObservingUser(_ observer: UserServiceObserver) {
        let obs = _UserServiceObserver(observer: observer)
        observers.append(obs)
    }
    
    /**
     Removes a `SocketObserver` delegate from the Singleton store
     */
    public class func stopObserving(_ observer: UserServiceObserver) {
        var idx: Int?
        for (i, wrapper) in observers.enumerated() {
            if wrapper.isValid && wrapper.observer === observer {
                idx = i
                break
            }
        }
        
        if let index = idx {
            observers.remove(at: index)
        }
    }
    
    // ==================================================
    // MARK: Properties
    // ==================================================
    
    static private var observers: [_UserServiceObserver] = []
    
    static var user: User? {
        didSet {
            observers.forEach {
                $0.observer?.userServiceUserUpdated(user)
            }
        }
    }
    
    class func refreshUser() {
        guard let currentID = Auth.auth().currentUser?.uid else { return }

        Service.shared.fetchUserData(uid: currentID) { user in
            self.user = user
        }
        
    }
}

// ==================================================
// MARK: Template Observer
// ==================================================


protocol TemplateObserver: AnyObject {
    func templateServiceUserUpdated(_ user: User?)
}

class TemplateService {
    
    fileprivate struct _TemplateObserver {
        weak var observer: TemplateObserver?
        
        var isValid: Bool {
            return observer != nil
        }
    }
    
    /**
     Appends a `SocketObserver` delegate to the Singleton store
     */
    public class func startObserving(_ observer: TemplateObserver) {
        let obs = _TemplateObserver(observer: observer)
        observers.append(obs)
    }
    
    /**
     Removes a `SocketObserver` delegate from the Singleton store
     */
    public class func stopObserving(_ observer: TemplateObserver) {
        var idx: Int?
        for (i, wrapper) in observers.enumerated() {
            if wrapper.isValid && wrapper.observer === observer {
                idx = i
                break
            }
        }
        
        if let index = idx {
            observers.remove(at: index)
        }
    }
    
    // ==================================================
    // MARK: Properties
    // ==================================================
    
    static private var observers: [_TemplateObserver] = []
    
    
    // ==================================================
    // MARK: Helpers
    // ==================================================
    
    
}
