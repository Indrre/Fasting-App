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
    
    var lastSevenDays: [Water] = []
    var days: [Date] = []
    var average: String = ""
    
    var waterData: [Water] {
        return WaterService.data
    }
    
    var water: Water? {
        didSet {
            label = "\(count * 250)ml"
            refreshController?()
        }
    }
    
    var waterModel: WaterModel {
        return WaterModel(
            dotCount: count,
            label: label,
            presentPicker: {  [ weak self ] in
                self?.presentWaterPicker()
            },
            graphModel: graphModel
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
}

// =================================
// MARK: TemplateObserver
// =================================

extension WaterViewModel: WaterServiceObserver {
    func waterServiceRefreshedData() {
        setupSevenDays()
        refreshController?()
    }
    
    func waterServiceWaterUpdated(_ water: Water?) {
        self.water = water
    }
}

extension WaterMainView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WaterService.data.count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WaterCell", for: indexPath) as? WaterCell else { fatalError("unable to create cells") }
        cell.textLabel?.font = UIFont(name: "Montserrat-ExtraLight", size: 2)

        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "E, d MMM"
    
        let currentModel = WaterService.data[indexPath.row + 1] 
        cell.model = WaterViewCellViewModel(
            waterCount: currentModel.count ?? 0,
            dateString: dayTimePeriodFormatter.string(from: Date(timeIntervalSince1970: (currentModel.date ?? TimeInterval.today))),
            totalCount: "\((currentModel.count ?? 0) * 250)ml"
        )
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            let data = WaterService.data[indexPath.row]
            let id = data.id
            guard let uid = Auth.auth().currentUser?.uid else { return }
            REF_WATER.child(uid).child(id).removeValue { (error, _) in
                if error != nil {
                    debugPrint("DEBUG: Error while trying to delete water:  \(String(describing: error))")
                }
            }
            WaterService.data.removeAll(where: {$0.id == data.id})
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            tableView.reloadData()
        }
    }
}
