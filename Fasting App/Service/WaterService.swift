//
//  WaterService.swift
//  Fasting App
//
//  Created by indre zibolyte on 27/03/2022.
//

import Foundation
import FirebaseAuth
import SwiftUI

protocol WaterServiceObserver: AnyObject {
    func waterServiceWaterUpdated(_ water: Water?)
    func waterServiceRefreshedData()
}

class WaterService {
    
    static var data = [Water]() {
        didSet {
            observers.forEach {
                $0.observer?.waterServiceRefreshedData()
            }
            return data.sort(by: { $0.date ?? .today > $1.date ?? .today })
        }
    }
    
    fileprivate struct _WaterServiceObserver {
        weak var observer: WaterServiceObserver?
        
        var isValid: Bool {
            return observer != nil
        }
    }
    
    /**
     Appends a `SocketObserver` delegate to the Singleton store
     */
    public class func startObservingWater(_ observer: WaterServiceObserver) {
        let obs = _WaterServiceObserver(observer: observer)
        observers.append(obs)
    }
    
    /**
     Removes a `SocketObserver` delegate from the Singleton store
     */
    public class func stopObserving(_ observer: WaterServiceObserver) {
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
    
    static private var observers: [_WaterServiceObserver] = []
    
    static var currentWater = Water(date: TimeInterval.today, count: 0) {
        didSet {
            observers.forEach {
                $0.observer?.waterServiceWaterUpdated(currentWater)
            }
        }
    }
    
    // ==================================================
    // MARK: Helpers
    // ==================================================
    
    class func start() {
        let id = "\(Int(TimeInterval.today))"
        Service.shared.fetchWaterData(
            id: id) { water, error in
            if error != nil {
                debugPrint("DEBUG: Error Fetching current water: - \(String(describing: error))")
            } else {
                self.currentWater = water!
            }
        }
    }
    
    class func fetchAllWater() {
        Service.shared.fetchAllWater { water, error in
            if error != nil {
                debugPrint("DEBUG: Error Fetching water data: \(String(describing: error))")
            } else {
                guard let allWater = water else { return }
                data = allWater
            }
        }
    }
    
    class func updateWater(_ water: Water) {
        self.currentWater = water
        Service.shared.updateWater(water)
    }
}



// ToDo:

// Water views does not refresh
// Weight views does not refresh

// ScrollView for all the views

// preload pickers
// RingView
// backgroubd
// light / dark mode
// Touchable view - rich to give a new coude to top bouncing
// background gradient
