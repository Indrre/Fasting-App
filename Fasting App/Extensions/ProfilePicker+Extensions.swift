//
//  ProfilePicker+Extensions.swift
//  Fasting App
//
//  Created by indre zibolyte on 25/03/2022.
//

import Foundation
import UIKit

// =================================
// MARK: Age Picker
// =================================

extension AgePickerView: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ageArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(format: "%d", ageArray[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        age = ageArray[row]
    }
}

// =================================
// MARK: Weight Picker
// =================================

extension WeightPickerView: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        4
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch selectedUnit {
        case .kilograms:
            if component == 0 {
                return 1 // KG header
            } else if component == 1 {
                return kgArray.count // kilograms
            } else if component == 2 {
                return 1 // grams header
            } else {
                return gramsArray.count // grams
            }
        default:
            if component == 0 {
                return 1 // stone header
            } else if component == 1 {
                return 100 // stones
            } else if component == 2 {
                return 1 // pound header
            } else {
                return 14 // pounds
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent componentKG: Int) -> String? {
        switch selectedUnit {
        case .kilograms:
            if componentKG == 0 {
                return "kg:" // header
            } else if componentKG == 1 {
                return String(format: "%d", kgArray[row]) // value
            } else if componentKG == 2 {
                return "g:" // header
            } else if componentKG == 3 {
                return String(format: "%d", gramsArray[row]) // value
            }
        default:
            if componentKG == 0 {
                return "st:" // header
            } else if componentKG == 1 {
                return String(format: "%d", stoneArray[row]) // value
            } else if componentKG == 2 {
                return "lb:" // header
            } else if componentKG == 3 {
                return String(format: "%d", poundArray[row]) // value
            }
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch selectedUnit {
        case .kilograms:
            if component == 1 {
                kilograms = kgArray[row] * 1000
            } else {
                grams = row  * 100
            }
            totalPoundsEntered = 0
            totalGramsEntered = kilograms + grams
        default:
            if component == 1 {
                stones = row * 14
            } else {
                pounds = row
            }
            totalGramsEntered = 0
            totalPoundsEntered = stones + pounds
        }
    }
}

// =================================
// MARK: Height Picker
// =================================

extension HeightPickerView: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        4
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if selectedUnits == "metrics" {
            if component == 0 {
               return 1 // meter header
            } else if component == 1 {
                return 3 // meters
            } else if component == 2 {
               return 1 // centimeters header
            } else {
               return 100 // days
            }
        } else {
            if component == 0 {
               return 1 // feet header
            } else if component == 1 {
                return 10 // feet
            } else if component == 2 {
               return 1 // inches header
            } else {
               return 12 // inches
            }
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if selectedUnits == "metrics" {
            if component == 0 {
                return "m:" // header
            } else if component == 1 {
                return "\(row)" // value
            } else if component == 2 {
                return "cm:" // header
            } else if component == 3 {
                return "\(row)" // value
            }
        } else {
            if component == 0 {
                return "feet:" // header
            } else if component == 1 {
                return "\(row)" // value
            } else if component == 2 {
                return "inch:" // header
            } else if component == 3 {
                return "\(row)" // value
            }
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if selectedUnits == "metrics" {
            if component == 1 {
                meters = row
                firstUnit = Int(meters ?? 0)
            } else {
                centimeters = row
                secondUnit = Int(centimeters ?? 0)

            }
        } else {
            if component == 1 {
                feet = row
                firstUnit = Int(feet ?? 0)
            } else {
                inches = row
                secondUnit = Int(inches ?? 0)
            }
        }
    }
    
}

// =================================
// MARK: Gender Picker
// =================================

extension GenderPickerView: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderArray[row]
    }
    
    internal func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        gender = genderArray[row]
    }
}

// =================================
// MARK: Activity Picker
// =================================

extension ActivityPickerView: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return activityArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return activityArray[row]
    }
    
    internal func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        activity = activityArray[row]
        
    }
}
