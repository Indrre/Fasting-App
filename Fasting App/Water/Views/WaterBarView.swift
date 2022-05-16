//
//  WaterBarView.swift
//  Fasting App
//
//  Created by indre zibolyte on 23/04/2022.
//

import Foundation
import UIKit

struct WaterBarModel {
    
    let waterGraph: [WaterGraphBarViewModel]
    let maximumWaterBar: Float
    let averageWater: String
    
}

struct WaterGraphBarViewModel {
    
    let date: TimeInterval?
    let barValue: Float
    let maxValue: Float
    
}

class WaterBarView: UIView {
    
    // ========================================
    // MARK: Properties
    // ========================================
    
    var stackViewHeight: CGFloat = 100
    
    // ========================================
    // MARK: Components
    // ========================================
    
    let stackView: UIStackView = {
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
    
    var model: WaterBarModel? {
        didSet {
            updateViews()
        }
    }
    
    // ========================================
    // MARK: Initialization
    // ========================================
    
    override init(frame: CGRect) {
        super.init(frame: .zero)

        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
            $0.height.equalTo(stackViewHeight)
        }
        
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
            $0.height.equalTo(stackView)
        }
        
        addSubview(averageView)
        averageView.snp.makeConstraints {
            $0.height.equalTo(1.5)
            $0.leading.equalTo(stackView)
            $0.trailing.equalTo(stackView).offset(150)
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
    
    func createWaterBars() {
        model?.waterGraph.forEach { item in
            stackView.addArrangedSubview(
                createWaterBar(
                    graph: item,
                    maxNum: model?.maximumWaterBar ?? 0
                )
            )
        }
    }
    
    func createWaterBar(
        graph: WaterGraphBarViewModel,
        maxNum: Float) -> UIView {
            let container = UIView()
            let lblDay = UILabel()
            lblDay.text = (graph.date ?? .today).dayCharacter.lowercased()
            lblDay.font = UIFont.systemFont(ofSize: 10)
            lblDay.textAlignment = .center
            lblDay.textColor = .stdText
            
            let bar = UIView()
            let barColor: UIColor? = .waterColor
            bar.backgroundColor = barColor
            bar.layer.cornerRadius = 5
            
            let hack = UIView()
            hack.backgroundColor = barColor
            
            container.addSubview(lblDay)
            lblDay.snp.makeConstraints {
                $0.leading.trailing.bottom.equalToSuperview()
            }

            let ratio = graph.barValue/(maxNum > 0 ? maxNum : 1)
            let height = stackViewHeight*CGFloat(ratio)

            container.addSubview(bar)
            bar.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(height == 0 ? 1 : height)
                $0.width.equalTo(10)
                $0.bottom.equalTo(lblDay.snp.top).offset(-5)
            }

            container.addSubview(hack)
            hack.snp.makeConstraints {
                $0.height.equalTo(height == 0 ? 0 : 4)
                $0.leading.trailing.bottom.equalTo(bar)
            }
            return container
        }
        
    func updateViews() {
        lblAverage.text = model?.averageWater
        stackView.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        
        createWaterBars()
    }
}
