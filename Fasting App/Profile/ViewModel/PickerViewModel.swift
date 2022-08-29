//
//  PickerViewModel.swift
//  Fasting App
//
//  Created by indre zibolyte on 03/06/2022.
//

import Foundation
import UIKit
class PickerViewModel {
    
    // =============================================
    // MARK: Properties
    // =============================================
    
    var age: Int?
    var firstWeightUnit: Int?
    var secondWeightUnit: Int?
    var firstHeightUnit: Int?
    var secondHeightUnit: Int?
    var weightUnit: Unit?
    var height: String?
    var heightUnit: String?
    var gender: String?
    var activity: String?
    
    var user: User? {
        didSet {
            firstHeightUnit = Int(user?.heightFirstUnit ?? 0)
            secondHeightUnit = Int(user?.heightSecondUnit ?? 0)
            getWeight()
            refreshController?()
        }
    }
        
    var data: [Weight] {
        return WeightService.data
            .sorted(by: { $0.date ?? .today > $1.date ?? .today })
    }
    
    var ageViewModel: AgePickerModel {
        return AgePickerModel(
            value: user?.age,
            callback: { [weak self] age in
                self?.saveAge(age: age)
            }
        )
    }
    
    var weightModel: WeightPickerModel {
        return WeightPickerModel(
            mesureUnit: weightUnit,
            firstWeightUnit: firstWeightUnit,
            secondWeightUnit: secondWeightUnit,
            callback: { [weak self] mesureUnit, weight in
                self?.saveWeight(mesureUnits: mesureUnit, value: weight)
            }
        )
    }
    
    var heightModel: HeightPickerModel {
        return HeightPickerModel(
            mesureUnit: user?.heightMsureUnit,
            firstHeightUnit: firstHeightUnit,
            secondHeightUnit: secondHeightUnit,
            callback: { [weak self] mesureUnit, firstUnit, secondUnit in
                self?.saveHeight(mesureUnits: mesureUnit, heightFirstUnit: firstUnit, heightSecondUnit: secondUnit)
            }
        )
    }
    
    var genderModel: GenderPickerModel {
        return GenderPickerModel(
            gender: user?.gender,
            callback: { [weak self] gender in
                self?.saveGender(gender: gender)
            }
        )
    }
    
    var activityModel: ActivityPickerModel {
        return ActivityPickerModel(
            activity: user?.activity,
            callback: { [weak self] activity in
                self?.saveActivity(activity: activity)
            }
        )
    }
    
    // =================================
    // MARK: Callbacks
    // =================================
    
    var refreshController: (() -> Void)?
    
    // =============================================
    // MARK: Helpers
    // =============================================
    
    func viewDidLoad() {
        UserService.startObservingUser(self)
        UserService.refreshUser()
    }
    
    func saveAge(age: Int) {
        self.age = age
        let values = ["age": age]
        Service.shared.updateUserValues(values: values as [String: Any])
        UserService.refreshUser()
    }
    
    func saveWeight(mesureUnits: String, value: Double) {
        var weight = WeightService.currentWeight
        if mesureUnits == "st" {
            let count = value * 453.592
            
            weight.count = Int(count)
        } else {
            weight.count = Int(value)
        }
        weight.unit = mesureUnits
        weight.id = "\(Int(TimeInterval.today))"
        weight.date = .today
        Service.shared.updateUserWeight(weight)
        WeightService.start()
    }
    
    func saveHeight(mesureUnits: String, heightFirstUnit: Int, heightSecondUnit: Int) {

        let values = [
            "heightUnit": mesureUnits,
            "heightFirstUnit": heightFirstUnit,
            "heightSecondUnit": heightSecondUnit] as [String: Any]
        Service.shared.updateUserValues(values: values as [String: Any])
        UserService.refreshUser()
    }
    
    func saveGender(gender: String) {
        let values = ["gender": gender] as [String: Any]
        Service.shared.updateUserValues(values: values as [String: Any])
        self.gender = gender
        UserService.refreshUser()
    }
    
    func saveActivity(activity: String) {
        let values = ["activity": activity] as [String: Any]
        Service.shared.updateUserValues(values: values as [String: Any])
        self.activity = activity
        UserService.refreshUser()
    }
        
    func getWeight() {
        
        var currentWeight: Weight?
        
        if data.count > 0 {
            currentWeight = data[0]
        } else {
            if data.count > 1 {
                currentWeight = data[1]
            }
        }
          
        guard let unit = currentWeight?.unit else { return }
        guard let userWeight = currentWeight?.count else { return }
        
        if unit == "kg" {
            weightUnit = Unit.kilograms
            firstWeightUnit = userWeight / 1000
            secondWeightUnit = userWeight % 1000
        } else {
            weightUnit = Unit.stones
            
            var pounds = (Double(userWeight) * 0.00220462)
            var numberOfStones = 0.0
            while pounds > 14 {
                pounds -= 14
                numberOfStones += 1
            }
            firstWeightUnit = Int(numberOfStones)
            let numberOfPounds = pounds.rounded()
            secondWeightUnit = Int(numberOfPounds)
        }
    }
}

// =================================
// MARK: TemplateObserver
// =================================

extension PickerViewModel: UserServiceObserver {
    
    func userServiceUserUpdated(_ user: User?) {
        self.user = user
    }
}
