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
    
    lazy var model: PickerViewModel = {
        let model = PickerViewModel()
        model.refreshController = { [weak self] in
            self?.setup()
        }
        return model
    }()
    
    // =======================================
    // MARK: Initialization
    // =======================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.viewDidLoad()
       
    }
    
    // =============================================
    // MARK: Helpers
    // =============================================
    
    func setup() {
        agePicker.model = model.ageViewModel
        weightPicker.model = model.weightModel
        heightPicker.model = model.heightModel
        genderPicker.model = model.genderModel
        activityPicker.model = model.activityModel
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
