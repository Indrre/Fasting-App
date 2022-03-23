//
//  FastViewModel.swift
//  Fasting App
//
//  Created by indre zibolyte on 11/03/2022.
//

import Foundation
import UIKit
import SnapKit
import Firebase

class FastViewModel {
    
    // =============================================
    // MARK: Properties
    // =============================================
    
    var data: [Fast]?
    var days: [Date] = []
    var lastSevenDays: [Fast] = []
    var average: String = ""
    
    var timerData: [Fast] {
        return FastService.data
    }
    
    var timerLapsed: TimeInterval?
    var hours: String?
    
    var fastTimerData: Fast? {
        didSet {
            timerLapsed = (TimeInterval(fastTimerData?.timeLapsed ?? 0) / TimeInterval(fastTimerData?.timeSelected ?? 0))
            hours = "\(Int(fastTimerData?.timeLapsed ?? 0) / 60 / 60)h"
            refreshController?()
        }
    }
    
    var fastModel: FastModel {
        return FastModel(
            graphModel: graphModel,
            timerLapsed: timerLapsed,
            hours: hours
        )
    }
    
    var graphModel: TimeBarModel {
        let maximumTimeSelected = Float(lastSevenDays.compactMap({ return $0.timeSelected }).max() ?? 0)
        let maximumTimeLapsed = Float(lastSevenDays.compactMap({ return $0.timeLapsed }).max() ?? 0)
        
        return TimeBarModel(
            graph: lastSevenDays.compactMap { item in
                return GraphBarViewModel(
                    startTime: item.start,
                    endTime: item.end,
                    barValue: Float(item.timeSelected),
                    maxValue: maximumTimeSelected
                )
            },
            maximumTimeLapsed: maximumTimeLapsed,
            averageHours: average
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
        FastService.startObservingFast(self)
        FastService.start()
        FastService.fetchAllFasts()
        refreshController?()
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
        
        days.forEach { date in
            let entry = timerData.first(
                where: {
                    Calendar.current.isDate(
                        Date(timeIntervalSince1970: $0.end ?? .today),
                        inSameDayAs: date
                    )
                }
            )
            
            if let entry = entry {
                lastSevenDays.append(entry)
            } else {
                lastSevenDays.append(
                    Fast(
                        start: date.timeIntervalSince1970,
                        end: date.timeIntervalSince1970,
                        timeSelected: 0
                    )
                )
            }
        }
        
        let sum = lastSevenDays.compactMap({ return $0.timeLapsed }).reduce(0, +)
        average = "\(Int(sum) / Int(timerData.count) / 60 / 60)h"
    }
    
}

// =================================
// MARK: TemplateObserver
// =================================

extension FastViewModel: FastServiceObserver {
    
    func fastServiceRefreshedData() {
        setupSevenDays()
        refreshController?()
    }
    
    func fastServiceFastUpdated(_ fast: Fast?) {
        self.fastTimerData = fast
    }
    
}

// =================================
// MARK: UITableViewDelegate
// =================================

extension FastView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        FastService.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FastViewCell", for: indexPath) as? ViewCell else { fatalError("unable to create cells") }
        cell.textLabel?.font = UIFont(name: "Montserrat-ExtraLight", size: 2)
        
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "E, d MMM"
        
        cell.lblDate.text = dayTimePeriodFormatter.string(from: Date(timeIntervalSince1970: (FastService.data[indexPath.row].end ?? .today)))
        
        cell.lblValue.text = String("\(Int(FastService.data[indexPath.row].timeLapsed / 60 / 60))h")
        //
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            let data = FastService.data[indexPath.row]
            let id = data.id
            guard let uid = Auth.auth().currentUser?.uid else { return }
            REF_FASTS.child(uid).child(id).removeValue { (error, _) in
                if error != nil {
                    debugPrint("DEBUG: Error while trying to delete:  \(String(describing: error))")
                }
            }
            FastService.data.removeAll(where: {$0.id == data.id})
            FastService.fetchAllFasts()
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            tableView.reloadData()
        }
    }
}
