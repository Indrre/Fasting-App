//
//  UserSettingsProfilePickerController.swift
//  Fasting App
//
//  Created by indre zibolyte on 06/02/2022.
//

import Foundation
import UIKit

class UserSettingsProfilePickerController: ModalViewController {
    
    // =============================================
    // MARK: Components
    // =============================================
    
    lazy var profileSettingsView: ProfileSettingsView = {
        return ProfileSettingsView(model: model.profileSettingsModel)
    }()

    
    
    lazy var model: ProfileSettingViewModel = {
        let model = ProfileSettingViewModel()
        model.rerefreshController = { [weak self] in
            self?.setup()
        }
        model.presentController = { [weak self] type in
            self?.setupPickerView(type: type)
        }
    return model
}()
    
    //=============================================
    // MARK: Components
    //=============================================

    lazy var agePicker: AgePickerView = {
        let view = AgePickerView(model: model.ageViewModel)
        view.delegate = self
        view.layer.cornerRadius = 20
        return view
    }()
    
    lazy var weightPicker: WeightPickerView = {
        let view = WeightPickerView(model: model.weightModel)
        view.delegate = self
        view.layer.cornerRadius = 20
        return view
    }()
    
    lazy var heightPicker: HeightPickerView = {
        let view = HeightPickerView(model: model.heightModel)
        view.delegate = self
        view.layer.cornerRadius = 20
        return view
    }()
    
    lazy var genderPicker: GenderPickerView = {
        let view = GenderPickerView(model: model.genderModel)
        view.delegate = self
        view.layer.cornerRadius = 20
        return view
    }()
    
    lazy var activityPicker: ActivityPickerView = {
        let view = ActivityPickerView(model: model.activityModel)
        view.delegate = self
        view.layer.cornerRadius = 20
        return view
    }()
    
    //=======================================
    // MARK: Initialization
    //=======================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
    }
    
    //=============================================
    // MARK: Helpers
    //=============================================
    
    func setup() {
        profileSettingsView.model = model.profileSettingsModel
    }
}

extension UserSettingsProfilePickerController: ModalViewControllerDelegate {
    func modalClose() {
        dismissModal()
    }
    
    func setupPickerView(type: PersonalInfo) {
        switch type {
        case .age:
            view.addSubview(agePicker)
            agePicker.snp.makeConstraints {
                bottomConstraint = $0.bottom.equalToSuperview().inset(50).constraint
                $0.height.equalTo(400)
                $0.left.right.equalToSuperview().inset(10)
            }
        case .weight:
            view.addSubview(weightPicker)
            weightPicker.snp.makeConstraints {
                bottomConstraint = $0.bottom.equalToSuperview().inset(50).constraint
                $0.height.equalTo(450)
                $0.left.right.equalToSuperview().inset(10)
            }
        case .height:
            view.addSubview(heightPicker)
            heightPicker.snp.makeConstraints {
                bottomConstraint = $0.bottom.equalToSuperview().inset(50).constraint
                $0.height.equalTo(450)
                $0.left.right.equalToSuperview().inset(10)
            }
        case .gender:
            view.addSubview(genderPicker)
            genderPicker.snp.makeConstraints {
                bottomConstraint = $0.bottom.equalToSuperview().inset(50).constraint
                $0.height.equalTo(350)
                $0.left.right.equalToSuperview().inset(10)
            }
        case .activity:
            view.addSubview(activityPicker)
            activityPicker.snp.makeConstraints {
                bottomConstraint = $0.bottom.equalToSuperview().inset(50).constraint
                $0.height.equalTo(350)
                $0.left.right.equalToSuperview().inset(10)
            }
        }
    }
}
