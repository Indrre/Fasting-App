//
//  FastView.swift
//  Fasting App
//
//  Created by indre zibolyte on 11/03/2022.
//

import Foundation
import UIKit
import SnapKit

struct FastModel {
    let timerLapsed: TimeInterval?
    let hours: String?
}

class FastView: UIView {
    
    // ========================================
    // MARK: Properties
    // ========================================
    
    var timerLapsed: TimeInterval?
    
    lazy var horizontalTimerView: HorizontalTimerView = {
        let view = HorizontalTimerView()
        view.model = HorizontalTimerModel(
            timerLapsed: timerLapsed,
            hours: "0h")
        return view
    }()
    
    var model: FastModel {
        didSet {
            horizontalTimerView.timerLapsed = model.timerLapsed
            horizontalTimerView.lblHours.text = model.hours
        }
    }

    // ========================================
    // MARK: Initialization
    // ========================================
    
    init(model: FastModel) {
        self.model = model
        super.init(frame: .zero)
        
        backgroundColor = .stdBackground
        
        addSubview(horizontalTimerView)
        horizontalTimerView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.right.left.equalToSuperview().offset(15)
            $0.height.equalTo(150)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // ========================================
    // MARK: Helpers
    // ========================================
    
}
