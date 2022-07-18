//
//  WeightService.swift
//  Fasting App
//
//  Created by indre zibolyte on 17/04/2022.
//

import Foundation
import UIKit

protocol WeightServiceObserver: AnyObject {
    func weightServiceWeightUpdated(_ weight: Weight?)
    func weightServiceRefreshedData()
}

class WeightService {
    
    static var data = [Weight]() {
        didSet {
            observers.forEach {
                $0.observer?.weightServiceRefreshedData()
            }
        }
    }
    
    fileprivate struct _WeightServiceObserver {
        weak var observer: WeightServiceObserver?
        
        var isValid: Bool {
            return observer != nil
        }
    }
    
    /**
     Appends a `SocketObserver` delegate to the Singleton store
     */
    public class func startObservingWeight(_ observer: WeightServiceObserver) {
        let obs = _WeightServiceObserver(observer: observer)
        observers.append(obs)
    }
    
    /**
     Removes a `SocketObserver` delegate from the Singleton store
     */
    public class func stopObserving(_ observer: WeightServiceObserver) {
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
    
    static private var observers: [_WeightServiceObserver] = []
    
    static var currentWeight = Weight(date: TimeInterval.today, count: 0, unit: "kg") {
        didSet {
            observers.forEach {
                $0.observer?.weightServiceWeightUpdated(currentWeight)
            }
        }
    }
    
    // ==================================================
    // MARK: Helpers
    // ==================================================
    
    class func start() {
        Service.shared.fetchWeight(id: "\(Int(TimeInterval.today))") { weight, error in
            if error != nil {
                debugPrint("DEBUG: Error Fetching weight data: \(String(describing: error))")
            } else if let weight = weight {
                self.currentWeight = weight
            }
        }
    }
    
    class func fetchAllWeight() {
        Service.shared.fetchAllWeight { weight, error in
            if error != nil {
                debugPrint("DEBUG: Error Fetching weight data: \(String(describing: error))")
            } else {
                guard let allWeight = weight else { return }
                data = allWeight
            }
        }
    }
}
