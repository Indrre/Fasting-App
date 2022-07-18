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
    var currentWeight: String?
    var graphLabel: String?
    var dataSet: [Dataset]?
    
    var graphData: [Weight] {
        return WeightService.data
            .sorted(by: { $1.date! > $0.date! })
    }
    
    var data: [Weight] {
        return WeightService.data
            .sorted(by: { $0.date! > $1.date! })
    }
    
    var weight: Weight? {
        didSet {
            getWeight()
            refreshController?()
        }
    }
    
    var weightModel: WeightModel {
        return WeightModel(
            weight: currentWeight ?? "0.0",
            data: data,
            callBack: { [ weak self ] in
                self?.presentWeightPicker()
            },
            dataSet: dataSet ?? [],
            loadGraph: { [weak self ] in
                self?.loadGraph()
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
        WeightService.fetchAllWeight()
        WeightService.start()
//        refreshController?()
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
            currentWeight = "\(label)kg"
        } else {
            
            var pounds = (Double(userWeight) * 0.00220462)
            var numberOfStones = 0.0
            while pounds > 14 {
                pounds -= 14
               numberOfStones += 1
            }
            
            let numbetOfPounds = pounds.rounded()
            currentWeight = "\(Int(numberOfStones))st \(Int(numbetOfPounds))lb"
        }
    }
}

// =================================
// MARK: TemplateObserver
// =================================

extension WeightViewModel: WeightServiceObserver {
    func weightServiceWeightUpdated(_ weight: Weight?) {
        self.weight = weight
        refreshController?()
    }
    
    func weightServiceRefreshedData() {
        loadGraph()
        refreshController?()
    }
    
}

extension WeightMainView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WeightService.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeightCell", for: indexPath) as? WeightCell else { fatalError("unable to create cells") }
        cell.textLabel?.font = UIFont(name: "Montserrat-ExtraLight", size: 2)
        cell.selectionStyle = .none

        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "E, d MMM"
        
        let weight = WeightService.currentWeight
        
        let data = model?.data[indexPath.row]
        if weight.unit == "kg" {
            let calculations = Double(data?.count ?? 0) / Double(1000)
            
            let label = String(format: "%.1f", calculations)
            count = "\(label)kg"
        } else {
            
            var pounds = (Double(data?.count ?? 0) * 0.00220462)
            var numberOfStones = 0.0
            while pounds > 14 {
                pounds -= 14
               numberOfStones += 1
            }
            
            let numbetOfPounds = pounds.rounded()
            count = "\(Int(numberOfStones))st \(Int(numbetOfPounds))lb"
        }
        cell.model = WeightCellModel(
            date: dayTimePeriodFormatter.string(from: Date(timeIntervalSince1970: (data?.date ?? TimeInterval.today) + 1)),
            value: count!
        )
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            
            let data = model?.data[indexPath.row]
            guard let id = data?.id else { return }
            guard let uid = Auth.auth().currentUser?.uid else { return }
            REF_WEIGHT.child(uid).child(id).removeValue { (error, _) in
                if error != nil {
                    debugPrint("DEBUG: Error while trying to delete water:  \(String(describing: error))")
                }
            }
            
            WeightService.data.removeAll(where: {$0.id == data?.id})
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            tableView.reloadData()
            
            if WeightService.currentWeight.id == data?.id {
                WeightService.currentWeight.count = 0
            }
        }
    }
}
