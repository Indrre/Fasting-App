//
//  FastViewModel.swift
//  Fasting App
//
//  Created by indre zibolyte on 11/03/2022.
//

import Foundation
import UIKit
import SnapKit

class FastViewModel {
    
    // =============================================
    // MARK: Properties
    // =============================================
    
    var data: [Fast]?
    var days: [Date] = []
    var lastSevenDays: [Fast] = []
    var average: String = ""
    let currentFast = FastService.currentFast
    
    var timerData: [Fast] {
        var data = FastService.data
        data.removeAll(where: {$0.start == nil})
        return data
    }
    
    var fastData: [Fast] {
        return FastService.data
            .sorted(by: { $0.start ?? .today > $1.start ?? .today })
    }
    
    var timerLapsed: TimeInterval?
    var hours: String?
    
    var fastTimerData: Fast? {
        didSet {
            let fast = FastService.currentFast
            if fast == nil {
                timerLapsed = nil
                hours = nil
                refreshController?()
            }
            if fast?.start != nil {
                timerLapsed = (TimeInterval(fastTimerData?.timeLapsed ?? 0) / TimeInterval(fastTimerData?.timeSelected ?? 0))
                hours = "\(Int(fastTimerData?.timeLapsed ?? 0) / 60 / 60)h"
                refreshController?()
            }
        }
    }
    
    var fastModel: FastModel {
        return FastModel(
            graphModel: graphModel,
            timerLapsed: timerLapsed,
            hours: hours,
            currentFast: currentFast,
            fastData: fastData,
            updateFast: { [ weak self ] fast in
                self?.updateFast(fast: fast)
            }
        )
    }
    
    var graphModel: FastBarModel {
        let maximumTimeSelected = Float(lastSevenDays.compactMap({ return $0.timeSelected }).max() ?? 0)
        let maximumTimeLapsed = Float(lastSevenDays.compactMap({ return $0.timeLapsed }).max() ?? 0)

        return FastBarModel(
            timerGraph: lastSevenDays.compactMap { item in
                return TimeGraphBarViewModel(
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
        for idx in 1..<daysInWeek {
            var component = DateComponents()
            component.day = -idx
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

        if sum != 0 {
            average = "\(Int(sum) / 7 / 60 / 60)h average"
        }
    }
    
    func updateFast(fast: Fast) {
    FastService.updateFast(fast)

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
