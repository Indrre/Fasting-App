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
    var value: String?
    let callback: ((_ mesureUnits: String?, _ heightFirstValue: Double, _ heightSecondCalue: Double) -> Void?)
}

class HeightPickerView: UIView {
    
    //=============================================
    // MARK: Properties
    //=============================================
    
    weak var delegate: ModalViewControllerDelegate?
    
    var meters: Int?
    var centimeters: Int?
    var feet: Int?
    var inches: Int?
    var totalHeight: Double?
    var height: String?
    var firstUnit: Double?
    var secondUnit: Double?
    var units = ["metrics", "imperial"]
    var selectedUnits = "metrics"
    
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
//            selectedUnits = model.mesureUnit ?? "metrics"
            height = model.value ?? "0.00"
        }
    }
    
    //=============================================
    // MARK: Initialization
    //=============================================
    
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
    
    //========================================
    // MARK: Helpers
    //========================================
    
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
        heightPicker.selectRow(0, inComponent: 1, animated: true)
        heightPicker.selectRow(0, inComponent: 3, animated: true)
    }
    
    func calculateHeight() {
        if selectedUnits == "metrics" {
            totalHeight = Double((meters ?? 0) * 100 + (centimeters ?? 0))
            model.callback("m", totalHeight!, 0)
        } else {
            model.callback("feet", Double(feet ?? 0), Double(inches ?? 0))
        }
        
    }
}

//=============================================
// MARK: UIPickerViewDataSource
//=============================================

//extension HeightPickerView: UIPickerViewDataSource, UIPickerViewDelegate {
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        4
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        
//        if selectedUnits == "metrics" {
//            if component == 0 {
//               return 1 //meter header
//            } else if component == 1 {
//                return 3 //meters
//            } else if component == 2 {
//               return 1 //centimeters header
//            } else {
//               return 100 //days
//            }
//        } else {
//            if component == 0 {
//               return 1 //feet header
//            } else if component == 1 {
//                return 10 //feet
//            } else if component == 2 {
//               return 1 //inches header
//            } else {
//               return 12 //inches
//            }
//        }
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        if selectedUnits == "metrics" {
//            if component == 0 {
//                return "m:" //header
//            } else if component == 1 {
//                return "\(row)" //value
//            } else if component == 2 {
//                return "cm:" //header
//            } else if component == 3 {
//                return "\(row)" //value
//            }
//        } else {
//            if component == 0 {
//                return "feet:" //header
//            } else if component == 1 {
//                return "\(row)" //value
//            } else if component == 2 {
//                return "inch:" //header
//            } else if component == 3 {
//                return "\(row)" //value
//            }
//        }
//        return nil
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        if selectedUnits == "metrics" {
//            if component == 1 {
//                meters = row
//                firstUnit = Double(meters ?? 0)
//            } else {
//                centimeters = row
//                secondUnit = Double(centimeters ?? 0)
//            }
//        } else {
//            if component == 1 {
//                feet = row
//                firstUnit = Double(feet ?? 0)
//            } else {
//                inches = row
//                secondUnit = Double(inches ?? 0)
//            }
//        }
//    }
//    
//}
