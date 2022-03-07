//
//  TemplateService.swift
//  Fasting App
//
//  Created by indre zibolyte on 06/03/2022.
//

import Foundation

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
