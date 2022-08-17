//
//  HeightPickerView.swift
//  Fasting App
//
//  Created by indre zibolyte on 06/02/2022.
//

import Foundation
import UIKit

struct HeightPickerModel {
    var mesureUnit: String?
    var firstHeightUnit: Int?
    var secondHeightUnit: Int?
    let callback: ((_ mesureUnits: String, _ heightFirstValue: Int, _ heightSecondCalue: Int) -> Void?)
}

class HeightPickerView: UIView {
    
    // =============================================
    // MARK: Properties
    // =============================================
    
    weak var delegate: ModalViewControllerDelegate?
    
    var meters: Int?
    var centimeters: Int?
    var feet: Int?
    var inches: Int?
    var height: String?
    var firstUnit: Int?
    var secondUnit: Int?
    var units = ["metrics", "imperial"]
    var selectedUnits = "metrics"
    
    var meterArray = [0, 1, 2]
    var cmArray = Array(0...99)
    var feetArray = Array(0...9)
    var inchArray = Array(0...11)
    
    lazy var mesureUnitControl: UISegmentedControl = {
        let view = UISegmentedControl(items: units)
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
        label.text = "Height"
        return label
    }()
    
    lazy var heightPicker: UIPickerView = {
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
        view.setTitle("Select", for: .normal)
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
    
    var model: HeightPickerModel {
        didSet {
            selectedUnits = model.mesureUnit ?? "metrics"
            firstUnit = model.firstHeightUnit
            secondUnit = model.secondHeightUnit
            if model.mesureUnit == "m" {
                selectedUnits = units[0]
            } else {
                selectedUnits = units[1]
            }
            mesureUnitControl.selectedSegmentIndex = units.firstIndex(of: selectedUnits) ?? 0
            
            loadPicker()
            
            heightPicker.reloadAllComponents()
        }
    }
    
    // =============================================
    // MARK: Initialization
    // =============================================
    
    init(model: HeightPickerModel) {
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

        addSubview(heightPicker)
        heightPicker.snp.makeConstraints {
            $0.height.equalTo(170)
            $0.top.equalTo(topLabel.snp.bottom).offset(50)
            $0.left.right.equalToSuperview().inset(15)
        }
        
        addSubview(selectButton)
        selectButton.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.left.right.equalToSuperview().inset(15)
            $0.top.equalTo(heightPicker.snp.bottom).offset(5)
        }

        addSubview(cancelButton)
        cancelButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.size.equalTo(selectButton)
            $0.top.equalTo(selectButton.snp.bottom).offset(5)
        }
        
        heightPicker.reloadAllComponents()
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // ========================================
    // MARK: Helpers
    // ========================================
    
    func loadPicker() {
        if selectedUnits == units[0] {
            heightPicker.selectRow(
                meterArray.firstIndex(of: model.firstHeightUnit ?? 0) ?? 0,
                inComponent: 1,
                animated: true
            )
            
            heightPicker.selectRow(
                cmArray.firstIndex(of: model.secondHeightUnit ?? 0) ?? 0,
                inComponent: 3,
                animated: true
            )
        } else {
            heightPicker.selectRow(
                feetArray.firstIndex(of: model.firstHeightUnit ?? 0) ?? 0,
                inComponent: 1,
                animated: true
            )
            
            heightPicker.selectRow(
                inchArray.firstIndex(of: model.secondHeightUnit ?? 0) ?? 0,
                inComponent: 3,
                animated: true
            )
        }
        heightPicker.reloadAllComponents()
    }
    
    @objc func saveButtonPressed() {
        calculateHeight()
        delegate?.modalClose()
    }
    
    @objc func cancelButtonPressed() {
        delegate?.modalClose()
    }
    
    @objc func mesureUnitChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            selectedUnits = "metrics"
            heightPicker.reloadAllComponents()

        default:
            selectedUnits = "imperial"
            heightPicker.reloadAllComponents()
        }
        loadPicker()
    }
    
    func calculateHeight() {
        var unit = ""
        var first = 0
        var second = 0
        if let meters = meters {
            first = meters
        } else {
            first = model.firstHeightUnit ?? 0
        }
        if let centimeters = centimeters {
            second = centimeters
        } else {
            second = model.secondHeightUnit ?? 0
        }
        
        if selectedUnits == "metrics" {
            if let meters = meters {
                first = meters
            } else {
                first = model.firstHeightUnit ?? 0
            }
            if let centimeters = centimeters {
                second = centimeters
            } else {
                second = model.secondHeightUnit ?? 0
            }
            unit = "m"
        } else {
            if let feet = feet {
                first = feet
            } else {
                first = model.firstHeightUnit ?? 0
            }
            if let inches = inches {
                second = inches
            } else {
                second = model.secondHeightUnit ?? 0
            }
            unit = "feet"
        }
        model.callback("m", first, second )
        debugPrint("DRBUG: UNIT \(unit)")
        debugPrint("DRBUG: FIRST  \(first)")
        debugPrint("DRBUG: SECOND \(second)")

//        if selectedUnits == "metrics" {
//            model.callback("m", meters, centimeters )
//        } else {
//            model.callback("feet", feet, inches)
//        }
    }
}
