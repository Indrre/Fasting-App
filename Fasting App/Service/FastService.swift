//
//  FastService.swift
//  Fasting App
//
//  Created by indre zibolyte on 02/03/2022.
//

import Foundation
import Firebase
import FirebaseAuth

// This is the protocol for the service

private let kCurrentFastId: String = "com.fastlog.current_fast_id"

protocol FastServiceObserver: AnyObject {
    func fastServiceFastUpdated(_ fast: Fast?)
}

class FastService {
    
    fileprivate struct _FastServiceObserver {
        weak var observer: FastServiceObserver?
        
        var isValid: Bool {
            return observer != nil
        }
    }
    
    /**
     Appends a `SocketObserver` delegate to the Singleton store
     */
    public class func startObservingFast(_ observer: FastServiceObserver) {
        let obs = _FastServiceObserver(observer: observer)
        observers.append(obs)
    }
    
    /**
     Removes a `SocketObserver` delegate from the Singleton store
     */

    public class func stopObserving(_ observer: FastServiceObserver) {
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
    
    static private var observers: [_FastServiceObserver] = []
    
    static var currentFast: Fast? {
        didSet {
            UserDefaults.standard.set(
                currentFast?.id,
                forKey: kCurrentFastId
            )
            
            print("CURRENT ID: \(currentFast?.id)")
            observers.forEach {
                $0.observer?.fastServiceFastUpdated(currentFast)
            }
        }
    }
    
    class func start() {
        guard
            let id = UserDefaults.standard.string(forKey: kCurrentFastId) else { return }
        
        Service.shared.fetchFast(
            id: id) { fast, error in
                self.currentFast = fast
            }
    }
    
    class func updateFast(_ fast: Fast) {
        self.currentFast = fast
        Service.shared.updateFast(fast)
    }
    
    class func updateEnd(_ fast: Fast) {
        self.currentFast = nil
        Service.shared.updateFast(fast)
        print("DEBUG: ending fast")
    }
    
}
