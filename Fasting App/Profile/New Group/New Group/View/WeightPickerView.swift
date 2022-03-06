//
//  WeightPickerView.swift
//  Fasting App
//
//  Created by indre zibolyte on 06/02/2022.
//

import Foundation
import UIKit

struct WeightPickerModel {
    var mesureUnit: String?
    var weight: String?
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
    
    //=============================================
    // MARK: Properties
    //=============================================
    
    weak var delegate: ModalViewControllerDelegate?
    var weight: String?
    var kilograms = 0
    var grams = 0
    var stones = 0
    var pounds = 0
    var totalGramsEntered = 0
    var totalPoundsEntered = 0
    
    var units: [Unit] = [.kilograms, .stones]
    
    var selectedUnit: Unit = .kilograms {
        didSet {
            weightPicker.reloadAllComponents()
        }
    }
    
    var kgArray = Array(0...300)
    var gramsArray = [0, 100, 200, 300, 400, 500, 600, 700, 800, 900]
    var stoneArray = Array(0...99)
    var poundArray = Array(0...14)
    
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
            weight = model.weight
        }
    }
    
    //=============================================
    // MARK: Initialization
    //=============================================
    
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
    
    
    //========================================
    // MARK: Helpers
    //========================================
    
    @objc func saveButtonPressed() {
        
        if selectedUnit == .kilograms {
            
            model.callback("kg", Double(totalGramsEntered))
        } else {
            model.callback("st", Double(totalPoundsEntered))
        }
        
        if selectedUnit == .kilograms {
            selectedUnit = units[0]
        } else {
            totalPoundsEntered = Int(Double(totalPoundsEntered * 454))
        }
        delegate?.modalClose()
    }
    
    @objc func cancelButtonPressed() {
        delegate?.modalClose()
    }
    
    @objc func mesureUnitChanged(sender: UISegmentedControl) {
        selectedUnit = units[sender.selectedSegmentIndex]

        weightPicker.selectRow(0, inComponent: 1, animated: true)
        weightPicker.selectRow(0, inComponent: 3, animated: true)
    }
}
//=============================================
// MARK: UIPickerViewDataSource
//=============================================

//extension WeightPickerView: UIPickerViewDataSource, UIPickerViewDelegate {
//    
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        4
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        
//        switch selectedUnit {
//        case .kilograms:
//            if component == 0 {
//                return 1 //KG header
//            } else if component == 1 {
//                return kgArray.count //kilograms
//            } else if component == 2 {
//                return 1 //grams header
//            } else {
//                return gramsArray.count //grams
//            }
//        default:
//            if component == 0 {
//                return 1 //stone header
//            } else if component == 1 {
//                return 100 //stones
//            } else if component == 2 {
//                return 1 //pound header
//            } else {
//                return 15 //inches
//            }
//        }
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent componentKG: Int) -> String? {
//        switch selectedUnit {
//        case .kilograms:
//            if componentKG == 0 {
//                return "kg:" //header
//            } else if componentKG == 1 {
//                return String(format: "%d", kgArray[row]) //value
//            } else if componentKG == 2 {
//                return "g:" //header
//            } else if componentKG == 3 {
//                return String(format: "%d", gramsArray[row]) //value
//            }
//        default:
//            if componentKG == 0 {
//                return "st:" //header
//            } else if componentKG == 1 {
//                return String(format: "%d", stoneArray[row]) //value
//            } else if componentKG == 2 {
//                return "lbs:" //header
//            } else if componentKG == 3 {
//                return String(format: "%d", kgArray[row]) //value
//            }
//        }
//        return nil
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        
//        switch selectedUnit {
//        case .kilograms:
//            if component == 1 {
//                kilograms = row * 1000
//            } else {
//                grams = row  * 100
//            }
//            totalPoundsEntered = 0
//            totalGramsEntered = kilograms + grams
//        default:
//            if component == 1 {
//                stones = row * 14
//            } else {
//                pounds = row
//            }
//            totalGramsEntered = 0
//            totalPoundsEntered = stones + pounds
//        }
//    }
//}
