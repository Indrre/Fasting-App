//
//  WeightViewModel.swift
//  Fasting App
//
//  Created by indre zibolyte on 17/04/2022.
//

import Foundation
import UIKit
import Firebase

class WeightViewModel {
    
    // =============================================
    // MARK: Properties
    // =============================================
    
    let pickerType = PersonalInfo.weight
    var lblCurrentWeight: String?
    var graphLabel: String?
    var dataSet: [Dataset]?
    var currentWeight = WeightService.currentWeight
    
    var graphData: [Weight] {
        var data = WeightService.data
            .sorted(by: { $1.date ?? .today > $0.date ?? .today })
        data.removeAll(where: {$0.count == 0})
        return data
    }
    
    var data: [Weight] {
        var data = WeightService.data
            .sorted(by: { $0.date ?? .today > $1.date ?? .today })
        data.removeAll(where: {$0.count == 0})
        return data
    }
    
    var weight: Weight? {
        didSet {
            getWeight()
            refreshController?()
        }
    }
    
    var weightModel: WeightModel {
        return WeightModel(
            weight: lblCurrentWeight ?? "0.0",
            data: data,
            callBack: { [ weak self ] in
                self?.presentWeightPicker()
            },
            dataSet: dataSet ?? [],
            loadGraph: { [weak self ] in
                self?.loadGraph()
            },
            currentWeight: currentWeight,
            updateWeight: { [ weak self ] weight in
                self?.updateWeight(weight: weight)
            }
        )
    }
    
    // =============================================
    // MARK: Callbacks
    // =============================================
    
    var refreshController: (() -> Void)?
    var presentPickerController: ((UIViewController) -> Void)?
    
    // =============================================
    // MARK: Helpers
    // =============================================
    
    func viewDidLoad() {
        WeightService.startObservingWeight(self)
        WeightService.start()
        WeightService.fetchAllWeight()
        refreshController?()
    }
    
    func refresh() {
        var weight = currentWeight
        weight.count = 0
        updateWeight(weight: weight)
        WeightService.start()
        WeightService.fetchAllWeight()
        loadGraph()
        refreshController?()
    }
    
    func loadGraph() {
        dataSet = graphData.compactMap({
            return Dataset(value: Double($0.count ?? 0), timestamp: Int($0.date ?? TimeInterval.today))
        })
    }
    
    func presentWeightPicker() {
        let controller = UserSettingsProfilePickerController()
        controller.modalPresentationStyle = .overFullScreen
        controller.setupPickerView(type: pickerType)
        presentPickerController?(controller)
    }
    
    func getWeight() {
        let weight = WeightService.currentWeight
        guard let weightUnit = weight.unit else { return }
        guard let userWeight = weight.count else { return }
        
        if weightUnit == "kg" {
            let calculations = Double(userWeight) / Double(1000)
            
            let label = String(format: "%.1f", calculations)
            lblCurrentWeight = "\(label)kg"
        } else {
            
            var pounds = (Double(userWeight) * 0.00220462)
            var numberOfStones = 0.0
            while pounds > 14 {
                pounds -= 14
               numberOfStones += 1
            }
            
            let numbetOfPounds = pounds.rounded()
            lblCurrentWeight = "\(Int(numberOfStones))st \(Int(numbetOfPounds))lb"
        }
    }
    
    func updateWeight(weight: Weight) {
        WeightService.currentWeight.count = 0
    }
}

// =================================
// MARK: TemplateObserver
// =================================

extension WeightViewModel: WeightServiceObserver {
    func weightServiceCurrentWeightUpdated(_ weight: Weight?) {
        self.weight = weight
        refreshController?()
    }
    
    func weightServiceAllWeightUpdated() {
        loadGraph()
        refreshController?()
        
        if data.count == 0 {
            presentWeightPicker()
        }
    }
}
