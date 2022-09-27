//
//  FastService.swift
//  Fasting App
//
//  Created by indre zibolyte on 02/03/2022.
//

import Foundation
import Firebase

private let kCurrentFastId: String = "com.fastlog.current_fast_id"

protocol FastServiceObserver: AnyObject {
    func fastServiceFastUpdated(_ fast: Fast?)
    func fastServiceRefreshedData()
}

class FastService {
    
    static var data = [Fast]() {
        didSet {
            observers.forEach {
                $0.observer?.fastServiceRefreshedData()
            }
            return data.sort(by: { $0.end ?? .today > $1.end ?? .today })
        }
    }
    
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
        for (point, wrapper) in observers.enumerated() {
            if wrapper.isValid && wrapper.observer === observer {
                idx = point
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
                if error != nil {
                    debugPrint("DEBUG: Error Fetching Fast: \(String(describing: error))")
                } else {
                    self.currentFast = fast
                }
            }
    }
    
    class func fetchAllFasts() {
        Service.shared.fetchFasts { fasts, error in
                if error != nil {
                    debugPrint("DEBUG: Error Fetching Fasts: \(String(describing: error))")
                } else {
                    guard let fasts = fasts else { return}
                    data = fasts
                }
            }
    }
    
    class func updateFast(_ fast: Fast) {
        self.currentFast = fast
        
        if currentFast?.start == 0 {
            self.currentFast = nil
        } else {
            Service.shared.updateFast(fast)
            if currentFast?.end != nil {
                self.currentFast = nil
            }
        }
    }
}
