//
//  MainTileView.swift
//  Fasting App
//
//  Created by indre zibolyte on 22/02/2022.
//

import Foundation
import UIKit

struct MainTileViewModel {
    var fastHours: String
    var waterValue: String
    var weightvalue: String
    var calorieValue: String
    let callback: (() -> Void?)
}

class MainTileView: UIView {
    
    // =============================================
    // MARK: Properties
    // =============================================
    
    var lblToday: UILabel = {
        var label = UILabel()
        label.font =  UIFont(name: "Montserrat-ExtraLight", size: 17)
        label.text = "Today"
        label.textColor = UIColor.stdText
        label.textAlignment = .left
        return label
    }()
    
    let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 20
        return view
    }()
    
    lazy var horizontalStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 20
        view.clipsToBounds = false
        view.addArrangedSubview(fastTile)
        view.addArrangedSubview(waterTile)
        return view
    }()
    
    lazy var secondHorizontalStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 20
        view.addArrangedSubview(weightTile)
        view.addArrangedSubview(calorieTile)
        return view
    }()
    
    lazy var fastTile: HomeTileView = {
        let view = HomeTileView()
        view.model = HomeTileViewViewModel(
            icon: "timer-icon-small",
            title: "Fast",
            color: .fastColor,
            value: "Test",
            action: { [weak self] in
//                self?.takeToTotalFast()
            }
        )
        return view
    }()
    
    lazy var waterTile: HomeTileView = {
        let view = HomeTileView()
        view.model = HomeTileViewViewModel(
            icon: "water-icon",
            title: "Water",
            color: .waterColor,
            value: "Test",
            action: { [weak self] in
//                self?.takeToWater()
            }
        )
        return view
    }()
    
    lazy var weightTile: HomeTileView = {
        let view = HomeTileView()
        view.model = HomeTileViewViewModel(
            icon: "weight-icon-small",
            title: "Weight",
            color: .weightColor,
            value: "Test",
            action: { [weak self] in
//                self?.takeToWeight()
            }
        )
        return view
    }()
    
    lazy var calorieTile: HomeTileView = {
        let view = HomeTileView()
        view.model = HomeTileViewViewModel(
            icon: "calorie-icon",
            title: "Calories",
            color: .calorieColor,
            value: "357kcal",
            action: { [weak self] in
//                self?.takeToCalories()
            }
        )
        return view
    }()
    
    var model: MainTileViewModel {
        didSet {
            fastTile.value = model.fastHours
            waterTile.value = model.waterValue
            weightTile.value = model.weightvalue
            calorieTile.value = model.calorieValue
        }
    }
    
    // =================================
    // MARK: Callbacks
    // =================================
    
    var action: (() -> Void)?
        
    // =============================================
    // MARK: Initialization
    // =============================================
    
    init(model: MainTileViewModel) {
        self.model = model
        super.init(frame: .zero)
        
        addSubview(lblToday)
        lblToday.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(15)
        }
        
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(lblToday).offset(40)
            $0.width.equalToSuperview().offset(-30)
        }
        stackView.addArrangedSubview(horizontalStackView)
        stackView.addArrangedSubview(secondHorizontalStackView)
        horizontalStackView.addArrangedSubview(fastTile)
        horizontalStackView.addArrangedSubview(waterTile)
        secondHorizontalStackView.addArrangedSubview(weightTile)
        secondHorizontalStackView.addArrangedSubview(calorieTile)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
