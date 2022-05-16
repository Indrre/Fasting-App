//
//  MainTileView.swift
//  Fasting App
//
//  Created by indre zibolyte on 22/02/2022.
//

import Foundation
import UIKit

struct MainTileModel {
    var fastHours: String
    var water: String
    var weight: String
    var calories: String
    let takeToFast: (() -> Void?)
    let takeToWater: (() -> Void?)
    let takeToWeight: (() -> Void?)
    let presentEditPicker: (() -> Void?)
    let state: State
}

class MainTileView: UIView {
    
    // =============================================
    // MARK: Properties
    // =============================================
        
    var buttonState: State? {
        didSet {
            
            if buttonState == .running {
                btnEditTimer.isHidden = false
            } else {
                btnEditTimer.isHidden = true
            }
        }
    }
    
    var lblToday: UILabel = {
        var label = UILabel()
        label.font =  UIFont(name: "Montserrat-ExtraLight", size: 17)
        label.text = "Today"
        label.textColor = UIColor.stdText
        label.textAlignment = .left
        return label
    }()
    
    lazy var btnEditTimer: UIButton = {
        var editButton = UIButton()
        editButton.titleLabel?.font = UIFont(name: "Montserrat-ExtraLight", size: 17)
        editButton.setTitleColor(.stdText, for: .normal)
        editButton.setTitle("Edit Timer", for: .normal)
        editButton.addTarget(self, action: #selector(presentDayPicker), for: .touchUpInside)
        return editButton
    }()
    
    let lblStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 150
        return view
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
        view.model = HomeTileModel(
            icon: "timer-icon-small",
            title: "Fast",
            color: .fastColor,
            value: "0h",
            action: { [weak self] in
                self?.presentFastController()
            }
        )
        return view
    }()
    
    lazy var waterTile: HomeTileView = {
        let view = HomeTileView()
        view.model = HomeTileModel(
            icon: "water-icon",
            title: "Water",
            color: .waterColor,
            value: "Test",
            action: { [weak self] in
                self?.presentWaterController()
            }
        )
        return view
    }()
    
    lazy var weightTile: HomeTileView = {
        let view = HomeTileView()
        view.model = HomeTileModel(
            icon: "weight-icon-small",
            title: "Weight",
            color: .weightColor,
            value: "Test",
            action: { [weak self] in
                self?.presentWeightController()
            }
        )
        return view
    }()
    
    lazy var calorieTile: HomeTileView = {
        let view = HomeTileView()
        view.model = HomeTileModel(
            icon: "calorie-icon",
            title: "Calories",
            color: .calorieColor,
            value: "357kcal",
            action: { [weak self] in
//                self?.presentWeightController()
            }
        )
        return view
    }()
    
    var model: MainTileModel {
        didSet {
            fastTile.value = model.fastHours
            waterTile.value = model.water
            weightTile.value = model.weight
            calorieTile.value = model.calories
            buttonState = model.state
        }
    }
    
    // =================================
    // MARK: Callbacks
    // =================================
    
    var action: (() -> Void)?
        
    // =============================================
    // MARK: Initialization
    // =============================================
    
    init(model: MainTileModel) {
        self.model = model
        super.init(frame: .zero)
        
        addSubview(lblStackView)
        lblStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(50)
        }
        
        lblStackView.addArrangedSubview(lblToday)
        lblStackView.addArrangedSubview(btnEditTimer)

        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(lblStackView.snp.bottom).offset(15)
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
    
    func presentFastController() {
        model.takeToFast()
    }
    
    func presentWaterController() {
        model.takeToWater()
    }
    
    func presentWeightController() {
        model.takeToWeight()
    }
    
    @objc func presentDayPicker() {
        model.presentEditPicker()
    }
    
}
