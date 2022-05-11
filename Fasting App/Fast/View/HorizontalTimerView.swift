//
//  HorizontalTimerView.swift
//  Fasting App
//
//  Created by indre zibolyte on 11/03/2022.
//

import Foundation
import UIKit
import SnapKit

class HorizontalTimerView: UIView {
    
    // ========================================
    // MARK: Components
    // ========================================
    
    private let barOffset: CGFloat = 10
    var timerLapsedViewWidth: Constraint?
    
    let lblToday: UILabel = {
        var label = UILabel()
        label.font =  UIFont(name: "Montserrat-Light", size: 14)
        label.text = "Today"
        label.textColor = UIColor.stdText
        return label
    }()
    
    let barContainerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()
    
     let timerView: UIView = {
        let view = UIView()
        view.backgroundColor = .fastSelectedColor
        view.layer.cornerRadius = 13
        return view
    }()
    
    let timerIcon: UIImageView = {
        let view = UIImageView()
        view.tintColor = .bottomBackground
        view.image = UIImage(named: "timer-icon-large")?.withRenderingMode(.alwaysTemplate)
        view.clipsToBounds = true
        return view
    }()
    
    var lblHours: UILabel = {
        var label = UILabel()
        label.font =  UIFont(name: "Montserrat-Medium", size: 16)
        label.textColor = UIColor.stdText
        return label
    }()
    
    let timerLapsedView: UIView = {
        let view = UIView()
        view.backgroundColor = .fastColor
        view.layer.cornerRadius = 13
        return view
    }()

    var timerLapsed: TimeInterval? {
        didSet {
            calculateTimerLength(percentage: timerLapsed ?? 0)
        }
    }
    
    // =============================================
    // MARK: Initialization
    // =============================================
    
    init() {
        super.init(frame: .zero)
        
        addSubview(lblToday)
        lblToday.snp.makeConstraints {
            $0.top.left.equalToSuperview()
            $0.size.equalTo(50)
        }
        
        addSubview(barContainerView)
        barContainerView.snp.makeConstraints {
            $0.height.equalTo(22)
            $0.right.equalToSuperview().inset(120)
            $0.top.equalTo(lblToday.snp.bottom).offset(10)
            $0.left.equalToSuperview()
        }
        
        barContainerView.addSubview(timerView)
        timerView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(-barOffset)
            $0.right.top.bottom.equalToSuperview()
        }
        
        barContainerView.addSubview(timerLapsedView)
        timerLapsedView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(-10)
            $0.bottom.top.equalToSuperview()
            timerLapsedViewWidth = $0.width.equalTo(0).constraint
        }
        
        addSubview(lblHours)
        lblHours.snp.makeConstraints {
            $0.left.equalTo(timerView.snp.right).offset(10)
            $0.centerY.equalTo(timerView)
        }
        
        addSubview(timerIcon)
        timerIcon.snp.makeConstraints {
            $0.right.equalToSuperview().inset(5)
            $0.bottom.equalTo(timerView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // ========================================
    // MARK: Helpers
    // ========================================
    
    func calculateTimerLength(percentage: TimeInterval) {
        var width = (barContainerView.frame.size.width * CGFloat(percentage)) + barOffset
        if width > barContainerView.frame.size.width {
            width = barContainerView.frame.size.width + barOffset
        }

        timerLapsedViewWidth?.update(offset: width)
        layoutIfNeeded()
    }
}
