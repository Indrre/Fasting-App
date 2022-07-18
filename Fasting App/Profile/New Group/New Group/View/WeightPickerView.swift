//
//  WeightPickerView.swift
//  Fasting App
//
//  Created by indre zibolyte on 06/02/2022.
//

import Foundation
import UIKit

struct WeightPickerModel {
    var mesureUnit: Unit?
    var firstWeightUnit: Int?
    var secondWeightUnit: Int?
    let callback: ((_ mesureUnits: String?, _ weight: Double) -> Void?)
}

enum Unit: String, CaseIterable {
    case kilograms, stones
}

extension Unit {
    
    var abbrev: String {
        switch self {
        case .kilograms:
            return "kg"
        default:
            return "st"
        }
    }
}

class WeightPickerView: UIView {
    
    // =============================================
    // MARK: Properties
    // =============================================
    
    weak var delegate: ModalViewControllerDelegate?
    var firstWeightUnit: Int?
    var secondWeightUnit: Int?
    var kilograms = 0
    var grams = 0
    var stones = 0
    var pounds = 0
    var totalGramsEntered = 0
    var totalPoundsEntered = 0
    var weightUnit: String?
    
    var units: [Unit] = [.kilograms, .stones]
    
    var selectedUnit: Unit = .kilograms {
        didSet {
            weightPicker.reloadAllComponents()
        }
    }
    
    var kgArray = Array(0...300)
    var gramsArray = [0, 100, 200, 300, 400, 500, 600, 700, 800, 900]
    var stoneArray = Array(0...99)
    var poundArray = Array(0...13)
    
    lazy var mesureUnitControl: UISegmentedControl = {
        let view = UISegmentedControl(items: units.compactMap({ $0.rawValue }))
        view.selectedSegmentIndex = 0
        view.layer.cornerRadius = 9
        view.layer.masksToBounds = true
        view.addTarget(self, action: #selector(mesureUnitChanged), for: .valueChanged)
        return view
    }()
    
    lazy var homeIndicatorBar: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "home-indicator-bar")?.withRenderingMode(.alwaysTemplate)
        view.clipsToBounds = true
        view.layer.cornerRadius = 3
        view.backgroundColor = .homeIndicatorColor
        return view
    }()
    
    let topLabel: UILabel = {
        let label = UILabel()
        label.font =  UIFont(name: "Montserrat-SemiBold", size: 24)
        label.textAlignment = .center
        label.textColor = .stdText
        label.text = "Weight"
        return label
    }()
    
    lazy var weightPicker: UIPickerView = {
        let view = UIPickerView()
        view.tintColor = .stdText
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    lazy var selectButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .timeColor
        view.layer.cornerRadius = 10
        view.setTitle("Save", for: .normal)
        view.titleLabel?.font = UIFont(name: "Montserrat-Medium", size: 18)
        view.setTitleColor(.white, for: .normal)
        view.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        return view
    }()
    
    lazy var cancelButton: UIButton = {
        let view = UIButton()
        view.setTitle("Cancel", for: .normal)
        view.titleLabel?.font = UIFont(name: "Montserrat-Medium", size: 18)
        view.setTitleColor(.stdText, for: .normal)
        view.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        return view
    }()
    
    var model: WeightPickerModel {
        didSet {
            selectedUnit = model.mesureUnit ?? .kilograms
            firstWeightUnit = model.firstWeightUnit
            secondWeightUnit = model.secondWeightUnit
            mesureUnitControl.selectedSegmentIndex = Unit.allCases.firstIndex(of: selectedUnit) ?? 0
            loadPicker()
            weightPicker.reloadAllComponents()
        }
    }
    
    // =============================================
    // MARK: Initialization
    // =============================================
    
    init(model: WeightPickerModel) {
        self.model = model
        super.init(frame: .zero)
        backgroundColor = .blackWhiteBackground
        
        addSubview(homeIndicatorBar)
        homeIndicatorBar.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.width.equalTo(60)
            $0.height.equalTo(5)
            $0.centerX.equalToSuperview()
        }
        
        addSubview(topLabel)
        topLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(50)
            $0.centerX.width.equalToSuperview()
        }
        
        addSubview(mesureUnitControl)
        mesureUnitControl.snp.makeConstraints {
            $0.top.equalTo(topLabel.snp.bottom).offset(15)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(200)
            $0.height.equalTo(30)
        }
        
        addSubview(weightPicker)
        weightPicker.snp.makeConstraints {
            $0.height.equalTo(170)
            $0.top.equalTo(topLabel.snp.bottom).offset(50)
            $0.left.right.equalToSuperview().inset(15)
        }
        
        addSubview(selectButton)
        selectButton.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.left.right.equalToSuperview().inset(15)
            $0.top.equalTo(weightPicker.snp.bottom).offset(5)
        }
        
        addSubview(cancelButton)
        cancelButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.size.equalTo(selectButton)
            $0.top.equalTo(selectButton.snp.bottom).offset(5)
        }
        
        mesureUnitControl.selectedSegmentIndex = Unit.allCases.firstIndex(of: selectedUnit) ?? 0
        weightPicker.reloadAllComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // ========================================
    // MARK: Helpers
    // ========================================
    
    @objc func saveButtonPressed() {
        
        if selectedUnit == .kilograms {
            
            if kilograms == 0 {
                kilograms = Int(firstWeightUnit!) * 1000
                totalGramsEntered = kilograms + grams
            }
            if grams == 0 {
                grams = Int(secondWeightUnit ?? 0)
                totalGramsEntered = kilograms + grams
            }
            
            model.callback("kg", Double(totalGramsEntered))
        } else {
            if stones == 0 {
                stones = Int(firstWeightUnit!) * 14
                totalPoundsEntered = stones + pounds
            }
            if pounds == 0 {
                pounds = Int(secondWeightUnit!)
                totalPoundsEntered = stones + pounds
            }
            model.callback("st", Double(totalPoundsEntered))
        }
        
        if selectedUnit == .kilograms {
            selectedUnit = units[0]
        } else {
            totalPoundsEntered = Int(Double(totalPoundsEntered) * 454)
        }
        delegate?.modalClose()
    }
    
    @objc func cancelButtonPressed() {
        delegate?.modalClose()
    }
    
    @objc func mesureUnitChanged(sender: UISegmentedControl) {
        selectedUnit = units[sender.selectedSegmentIndex]
        loadPicker()
    }
    
    func loadPicker() {
        
        if selectedUnit == .kilograms {
            weightPicker.selectRow(
                kgArray.firstIndex(of: model.firstWeightUnit ?? 0) ?? 0,
                inComponent: 1,
                animated: true
            )
            
            weightPicker.selectRow(
                gramsArray.firstIndex(of: model.secondWeightUnit ?? 0) ?? 0,
                inComponent: 3,
                animated: true
            )
        } else {
            weightPicker.selectRow(
                stoneArray.firstIndex(of: model.firstWeightUnit ?? 0) ?? 0,
                inComponent: 1,
                animated: true
            )
            debugPrint("DRBUG: model.firstWeightUnit \(model.firstWeightUnit)")
            weightPicker.selectRow(
                poundArray.firstIndex(of: model.secondWeightUnit ?? 0) ?? 0,
                inComponent: 3,
                animated: true
            )
        }
        weightPicker.reloadAllComponents()
    }
}
