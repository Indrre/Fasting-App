//
//  FastMonthlyBarView.swift
//  Fasting App
//
//  Created by indre zibolyte on 11/03/2022.
//

import Foundation
import UIKit

class FastMonthlyBarView: UIView {
    
    // ========================================
    // MARK: Properties
    // ========================================
    
    var days: [Date] = []
    var fastArray: [Float] = []
    var highest: Float = 0

//    var timerData: [FastModel] {
//        return FastStore.shared.data
//    }
//
//    var month: [FastModel] = []
    
//    var maxNum: Float {
//        return Float(month.compactMap({ return $0.timeLapsed }).max() ?? 0)
//    }
    
//    var average: Float {
//        if timerData.isEmpty {
//            return 0
//        } else {
//            let sum = month.compactMap({ return $0.timeLapsed }).reduce(0, +)
//            return Float(sum) / Float(timerData.count)
//        }
//    }
    
    var totalHours: Float {
        let sum = fastArray.reduce(0, +)
        return sum
    }
    
    var stackViewHeight: CGFloat = 120
    
    // ========================================
    // MARK: Components
    // ========================================
    
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    let fastStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.alignment = .fill
        view.spacing = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let lblTopLabel: UILabel = {
        let view = UILabel()
        view.textColor = .stdText
        view.textAlignment = .right
        view.font = UIFont(name: "Montserrat-ExtraLight", size: 9)
        return view
    }()
    
    let lblMiddleLabel: UILabel = {
        let view = UILabel()
        view.textColor = .stdText
        view.textAlignment = .right
        view.font = UIFont(name: "Montserrat-ExtraLight", size: 9)
        return view
    }()
    
    let lblBottomLabel: UILabel = {
        let view = UILabel()
        view.textColor = .stdText
        view.textAlignment = .right
        view.font = UIFont(name: "Montserrat-ExtraLight", size: 9)
        return view
    }()
    
    let lblZeroLabel: UILabel = {
        let view = UILabel()
        view.textColor = .stdText
        view.textAlignment = .right
        view.text = "0h"
        view.font = UIFont(name: "Montserrat-ExtraLight", size: 9)
        return view
    }()
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .stdText
        view.alpha = 0.3
        return view
    }()
    
    // ========================================
    // MARK: Initialization
    // ========================================

    override init(frame: CGRect) {
        super.init(frame: .zero)

        addSubview(scrollView)
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 5)
        scrollView.snp.makeConstraints {
            $0.size.equalToSuperview()
        }
        
        scrollView.addSubview(fastStackView)
        fastStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview()
        }
        
        setupMonth()
        createFastBars()
        addSideHourLabel()
        
        layoutIfNeeded()
        
        let scrollOffset = CGPoint(x: scrollView.contentSize.width - scrollView.bounds.size.width, y: 0)
        scrollView.setContentOffset(scrollOffset, animated: true)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // ========================================
    // MARK: Helpers
    // ========================================
    
    @objc func updateViews() {
        fastStackView.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        fastArray.removeAll()
        setupMonth()
        createFastBars()
    }

    func setupMonth() {
        
//        month = []
        
        let dateComponents = DateComponents()
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!

        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
      
        let today = Date()
        let daysInMonth: Int = numDays

        // Starting your day array with today included
         days = [today]

        // This loop will start from yesterday and append the array with the previous day
        for i in 1..<daysInMonth - 1 {
            var component = DateComponents()
            component.day = -i
            if let newDate = calendar.date(byAdding: component, to: today) {
                days.insert(newDate, at: 0)
            }
        }
        
//        days.forEach { date in
//            let entry = timerData.first(
//                where: {
//                    Calendar.current.isDate(
//                        Date(timeIntervalSince1970: $0.end ?? .today),
//                        inSameDayAs: date
//                    )
//                }
//            )
//            if let entry = entry {
//                month.append(entry)
//            } else {
//                month.append(
//                    FastModel(
//                        start: date.timeIntervalSince1970,
//                        end: date.timeIntervalSince1970,
//                        timeSelected: 0
//                    )
//                )
//            }
//        }
    }

    @objc func createFastBars() {
//        if FastStore.shared.data.isEmpty {
//            return
//        } else {
//            month.forEach {
//                var totalFast: Float
//                if let end = $0.end {
//                    totalFast = Float(end - $0.start)
//                    fastArray.append(totalFast)
//                } else {
//                    totalFast = Float(Date().timeIntervalSince1970 - $0.start)
//                    fastArray.append(totalFast)
//                }
//                let bar = createFastBar(model: $0, backgroundColor: .fastColor, barValue: totalFast)
//
//                fastStackView.addArrangedSubview(bar)
//            }
//            print("Array \(fastArray)")
//        }
    }
    
//    func createFastBar(model: FastModel, backgroundColor: UIColor, barValue: Float) -> UIView {
//        
//        let dateFormat = DateFormatter()
//        dateFormat.dateFormat = "d MMM"
//        
//        let container = UIView()
//        let lblDay = UILabel()
//        lblDay.text = dateFormat.string(from: Date(timeIntervalSince1970: model.end ?? .today))
//        lblDay.font = UIFont.systemFont(ofSize: 10)
//        lblDay.textAlignment = .center
//        lblDay.textColor = .stdText
//        lblDay.numberOfLines = 0
//
//        let bar = UIView()
//        bar.backgroundColor = backgroundColor
//        bar.layer.cornerRadius = 5
//
//        let hack = UIView()
//        hack.backgroundColor = backgroundColor
//        hack.layer.cornerRadius = 3
//
//        container.addSubview(lblDay)
//        
//        lblDay.snp.makeConstraints {
//            $0.centerX.bottom.equalToSuperview()
//            $0.width.equalTo(20)
//        }
//        
//        let barValue = barValue
//        let ratio = barValue/(maxNum > 0 ? maxNum : 1)
//        let height = stackViewHeight * CGFloat(ratio)
//        
//        container.addSubview(bar)
//        bar.snp.makeConstraints {
//            $0.leading.trailing.equalToSuperview()
//            $0.height.equalTo(height == 0 ? 1 : height)
//            $0.width.equalTo(10)
//            $0.bottom.equalTo(lblDay.snp.top).offset(-5)
//        }
//
//        container.addSubview(hack)
//        hack.snp.makeConstraints {
//            $0.height.equalTo(height == 0 ? 0 : 5)
//            $0.leading.trailing.bottom.equalTo(bar)
//        }
//
//        return container
//    }
    
    private func addSideHourLabel() {

        highest = fastArray.max() ?? 0

        addSubview(lblTopLabel)
        lblTopLabel.snp.makeConstraints {
            $0.right.equalToSuperview().offset(30)
            $0.bottom.equalToSuperview().inset(145)
        }
        addSubview(lblMiddleLabel)
        lblMiddleLabel.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.right.equalTo(lblTopLabel)
            $0.top.equalTo(lblTopLabel.snp.bottom).offset(15)
        }

        addSubview(lblBottomLabel)
        lblBottomLabel.snp.makeConstraints {
            $0.right.equalTo(lblTopLabel)
            $0.top.equalTo(lblMiddleLabel.snp.bottom).offset(15)
        }

        addSubview(lblZeroLabel)
        lblZeroLabel.snp.makeConstraints {
            $0.right.equalTo(lblTopLabel)
            $0.bottom.equalToSuperview().inset(20)
        }

        addSubview(lineView)
        lineView.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.height.equalTo(fastStackView)
            $0.right.equalTo(lblTopLabel.snp.left).offset(-5)
        }

        let topLabel = highest/60/60
        let bottomLabel = topLabel / 3
        let middleLabel = bottomLabel * 2

        lblTopLabel.text = "\(Int(topLabel))h"
        lblBottomLabel.text = "\(Int(bottomLabel))h"
        lblMiddleLabel.text = "\(Int(middleLabel))h"
    }
}
