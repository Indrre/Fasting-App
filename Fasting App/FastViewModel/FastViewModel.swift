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
    
    var timerLapsed: TimeInterval?
    var hours: String?
    
    var fast: Fast? {
        didSet {
            timerLapsed = (TimeInterval(fast?.timeLapsed ?? 0) / TimeInterval(fast?.timeSelected ?? 0))
            hours = "\(Int(fast?.timeLapsed ?? 0) / 60 / 60)h"
            refreshController?()
        }
    }
    
    var fastModel: FastModel {
        return FastModel(
            timerLapsed: timerLapsed,
            hours: hours
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
        UserService.refreshUser()
        FastService.start()
    }
      
}

// =================================
// MARK: TemplateObserver
// =================================

extension FastViewModel: FastServiceObserver {
    func fastServiceFastUpdated(_ fast: Fast?) {
        self.fast = fast
    }
}
