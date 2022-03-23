//
//  TimeBarView.swift
//  Fasting App
//
//  Created by indre zibolyte on 15/03/2022.
//

import Foundation
import UIKit

struct TimeBarModel {
    
    let graph: [GraphBarViewModel]
    let maximumTimeLapsed: Float
    let averageHours: String
    
}

struct GraphBarViewModel {
    
    let startTime: TimeInterval?
    let endTime: TimeInterval?
    let barValue: Float
    let maxValue: Float
    
}

class TimeBarView: UIView {
    
    // ========================================
    // MARK: Properties
    // ========================================
    
    var stackViewHeight: CGFloat = 100
    
    // ========================================
    // MARK: Components
    // ========================================
    
    let selectionStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.alignment = .fill
        view.spacing = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let fastStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.alignment = .fill
        view.spacing = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let averageView: UIView = {
        let view = UIView()
        view.backgroundColor = .stdText
        view.alpha = 0.3
        return view
    }()
    
    let lblAverage: UILabel = {
        let view = UILabel()
        view.textColor = .stdText
        view.textAlignment = .right
        view.font = UIFont(name: "Montserrat-ExtraLight", size: 13)
        return view
    }()
    
    var model: TimeBarModel? {
        didSet {
            updateViews()
        }
    }
    
    // ========================================
    // MARK: Initialization
    // ========================================
    
    override init(frame: CGRect) {
        super.init(frame: .zero)

        addSubview(selectionStackView)
        selectionStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
            $0.height.equalTo(stackViewHeight)
        }
        
        addSubview(fastStackView)
        fastStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
            $0.height.equalTo(selectionStackView)
        }
        
        addSubview(averageView)
        averageView.snp.makeConstraints {
            $0.height.equalTo(1.5)
            $0.leading.equalTo(selectionStackView)
            $0.trailing.equalTo(selectionStackView).offset(100)
            $0.centerY.equalToSuperview()
        }
        
        addSubview(lblAverage)
        lblAverage.snp.makeConstraints {
            $0.trailing.equalTo(averageView)
            $0.top.equalTo(averageView.snp.bottom).offset(4)
        }
        
        updateViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // ========================================
    // MARK: Helpers
    // ========================================
    
    func createTimeSelectedBars() {
        model?.graph.forEach { item in
            selectionStackView.addArrangedSubview(
                createFastBar(
                    graph: item,
                    maxNum: model?.maximumTimeLapsed ?? 0
                )
            )
        }
    }
    
    func createTimeLapsedBars() {
        model?.graph.forEach { item in
            fastStackView.addArrangedSubview(
                createFastBar(
                    graph: item,
                    maxNum: model?.maximumTimeLapsed ?? 0,
                    isTimeLapsed: true
                )
            )
        }
    }
    
    func createFastBar(
        graph: GraphBarViewModel,
        maxNum: Float,
        isTimeLapsed: Bool = false) -> UIView {
            let container = UIView()
            let lblDay = UILabel()
            lblDay.text = (graph.endTime ?? .today).dayCharacter.lowercased()
            lblDay.font = UIFont.systemFont(ofSize: 10)
            lblDay.textAlignment = .center
            lblDay.textColor = .stdText
            
            let bar = UIView()
            let barColor: UIColor? = isTimeLapsed ? .fastColor : .fastSelectedColor
            bar.backgroundColor = barColor
            bar.layer.cornerRadius = 5
            
            let hack = UIView()
            hack.backgroundColor = barColor
            
            container.addSubview(lblDay)
            
            lblDay.snp.makeConstraints {
                $0.leading.trailing.bottom.equalToSuperview()
            }
            
            var barValue = graph.barValue
            if isTimeLapsed {
                if let end = graph.endTime {
                    barValue = Float(end - (graph.startTime ?? 0))
                } else {
                    barValue = Float(Date().timeIntervalSince1970 - (graph.startTime ?? 0))
                }
            }
            
            let percentage = barValue == 0 && maxNum == 0 ? 0 : CGFloat(barValue/maxNum)
            var barHeight = stackViewHeight * percentage
            
            if (barValue == maxNum && percentage > 0) || barHeight > stackViewHeight {
                barHeight = stackViewHeight
            }
            
            container.addSubview(bar)
            bar.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(barHeight == 0 ? 1 : barHeight)
                $0.width.equalTo(10)
                $0.bottom.equalTo(lblDay.snp.top).offset(-5)
            }
            
            container.addSubview(hack)
            hack.snp.makeConstraints {
                $0.height.equalTo(barHeight == 0 ? 0 : 4)
                $0.leading.trailing.bottom.equalTo(bar)
            }
            return container
        }
        
    func updateViews() {
        lblAverage.text = model?.averageHours
        selectionStackView.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        fastStackView.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        
        createTimeSelectedBars()
        createTimeLapsedBars()
    }
    
}
