//
//  WaterPickerViewModel.swift
//  Fasting App
//
//  Created by indre zibolyte on 27/03/2022.
//

import Foundation
import UIKit

class WaterPickerViewModel {
    
    // =============================================
    // MARK: Properties
    // =============================================
    
    var newWater: Int = 0
    var label: String = "0"
    
    var water: Water? {
        didSet {
            newWater = water?.count ?? 0
            label = "\(newWater)"
            refreshController?()
        }
    }

    var waterPickerModel: WaterPickerModel {
        return WaterPickerModel(
            label: label,
            incrementWater: { [ weak self] in
                self?.incrementWater()
            },
            decrementWater: { [ weak self] in
                self?.decrementWater()
            },
            saveWater: { [ weak self] in
                self?.saveWater()
            }
        )
    }
    
    // =================================
    // MARK: Callbacks
    // =================================
    
    var refreshController: (() -> Void)?
    
    // =============================================
    // MARK: Helpers
    // =============================================
    
    func viewDidLoad() {
        WaterService.startObservingWater(self)
        WaterService.start()
        refreshController?()
    }
    
    func incrementWater() {
        newWater += 1
        label = String(newWater)
        refreshController?()
    }
    
    func decrementWater() {
        if newWater > 0 {
            newWater -= 1
        }
        label = String(newWater)
        refreshController?()

    }
    
    func saveWater() {
    var water = WaterService.currentWater
        water.count = newWater
        water.date = .today
        WaterService.updateWater(water)
    }
}

// =================================
// MARK: TemplateObserver
// =================================

extension WaterPickerViewModel: WaterServiceObserver {
    func waterServiceRefreshedData() {
        refreshController?()
    }
    
    func waterServiceWaterUpdated(_ water: Water?) {
        self.water = water
    }
}
