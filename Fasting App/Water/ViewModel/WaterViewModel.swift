//
//  WaterViewModel.swift
//  Fasting App
//
//  Created by indre zibolyte on 26/03/2022.
//

import Foundation
import UIKit
import Firebase

class WaterViewModel {
    
    // =============================================
    // MARK: Properties
    // =============================================
    
    var label: String = "0 ml"
    var count: Int {
        return WaterService.currentWater.count ?? 0
    }
        
    var currentWater = WaterService.currentWater
    
    var lastSevenDays: [Water] = []
    var days: [Date] = []
    var average: String = ""
   
    var waterData: [Water] {
        var data =  WaterService.data
            .sorted(by: { $0.date ?? .today > $1.date ?? .today })
        data.removeAll(where: {$0.count == 0})
        return data
    }
    
    var water: Water? {
        didSet {
            label = "\(count * 250)ml"
            refreshController?()
        }
    }
    
    var waterModel: WaterModel {
        return WaterModel(
            waterData: waterData,
            dotCount: count,
            label: label,
            presentPicker: {  [ weak self ] in
                self?.presentWaterPicker()
            },
            graphModel: graphModel,
            currentWater: currentWater,
            updateWater: { [ weak self ] water in
                self?.updateWater(water: water)
            }
        )
    }
    
    var graphModel: WaterBarModel {
        let maximumWater = Float(lastSevenDays.compactMap({ return $0.count }).max() ?? 0)
        return WaterBarModel(
            waterGraph: lastSevenDays.compactMap { item in
                return WaterGraphBarViewModel(
                    date: item.date,
                    barValue: item.barValue,
                    maxValue: Float(item.barValue)
                )
            },
            maximumWaterBar: maximumWater,
            averageWater: average)
    }
    
    // =================================
    // MARK: Callbacks
    // =================================
    
    var refreshController: (() -> Void)?
    var presentPickerController: ((UIViewController) -> Void)?

    // =============================================
    // MARK: Helpers
    // =============================================
    
    func viewDidLoad() {
        WaterService.startObservingWater(self)
        WaterService.start()
        WaterService.fetchAllWater()
        refreshController?()
    }
    
    func presentWaterPicker() {
        let controller = WaterPickerViewController()
        controller.modalPresentationStyle = .overFullScreen
        presentPickerController?(controller)
    }
    
    func setupSevenDays() {
        lastSevenDays = []
        let calendar = Calendar.current
        let today = Date()
        let daysInWeek: Int = 7
        
        // Starting your day array with today included
        days = [today]
        
        // This loop will start from yesterday and append the array with the previous day
        for i in 1..<daysInWeek {
            var component = DateComponents()
            component.day = -i
            if let newDate = calendar.date(byAdding: component, to: today) {
                days.insert(newDate, at: 0)
            }
        }
        
        days.forEach {
            let date = $0
            
            // This will try and fetch a entry for the current date we are looking at
            let entry = waterData.first(
                where: { Calendar.current.isDate(Date(timeIntervalSince1970: $0.date ?? .today), inSameDayAs: date) }
            )
            
            if let entry = entry {
                // If we did find a entry then append to the lastSevenDays
                lastSevenDays.append(entry)
            } else {
                // If we didn't then create a new model and append
                lastSevenDays.append(Water(date: date.timeIntervalSince1970, count: 0))
            }
        }
        
        let sum = lastSevenDays.compactMap({ return $0.count }).reduce(0, +)
        if sum != 0 {
            if sum > 1 {
                average = "\(Int(sum) * 250 )ml average"
            }
        }
    }
    
    func updateWater(water: Water) {
        WaterService.currentWater.count = 0
    }
    
    func refresh() {
        var water = currentWater
        currentWater.id = "\(Int(TimeInterval.today))"
        currentWater.date = TimeInterval.today
        if currentWater.id != water.id {
            water.count = 0
        }
        updateWater(water: water)

        WaterService.start()
        WaterService.fetchAllWater()
        setupSevenDays()
    }
}

// =================================
// MARK: TemplateObserver
// =================================

extension WaterViewModel: WaterServiceObserver {
    func waterServiceAllWaterUpdated() {
        setupSevenDays()
        refreshController?()

        if waterData.count == 0 {
            presentWaterPicker()
        }
    }
    
    func waterServiceCurrectWaterUpdated(_ water: Water?) {
        self.water = water
        refreshController?()
    }
}
