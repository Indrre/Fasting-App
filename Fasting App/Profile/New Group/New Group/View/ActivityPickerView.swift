//
//  ActivityPickerView.swift
//  Fasting App
//
//  Created by indre zibolyte on 06/02/2022.
//

import Foundation
import UIKit

struct ActivityPickerModel {
    var activity: String?
    let callback: ((_ ativity: String) -> Void?)
}


class ActivityPickerView: UIView {
    
    //=============================================
    // MARK: Properties
    //=============================================
    
    weak var delegate: ModalViewControllerDelegate?
    
    var activity: String = "Inactive"
        
    var activityArray = ["Inactive (less than 30 mins)", "Moderate (between 30-60 mins)", "Active (between 60-150 mins)"]
    
    lazy var homeIndicatorBar: UIImageView = {
        let view = UIImageView()
        view.tintColor = .stdText
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
        label.text = "Activity"
        return label
    }()
    
    lazy var activityPicker: UIPickerView = {
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
    
    var model: ActivityPickerModel {
        didSet {
            activity = model.activity ?? "Inactive (less than 30 mins)"
        }
    }
    
    //=================================
    // MARK: Callbacks
    //=================================
    
    var callback: ((_ activity: String) -> Void)?
    
    //=============================================
    // MARK: Initialization
    //=============================================
    
    init(model: ActivityPickerModel) {
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
            $0.top.equalToSuperview().offset(40)
            $0.centerX.width.equalToSuperview()
        }

        addSubview(activityPicker)
        activityPicker.snp.makeConstraints {
            $0.height.equalTo(100)
            $0.top.equalTo(topLabel.snp.bottom).offset(10)
            $0.left.right.equalToSuperview().inset(15)
        }
        
        addSubview(selectButton)
        selectButton.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.left.right.equalToSuperview().inset(15)
            $0.top.equalTo(activityPicker.snp.bottom).offset(30)
        }
        
        addSubview(cancelButton)
        cancelButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.size.equalTo(selectButton)
            $0.top.equalTo(selectButton.snp.bottom)
        }
        
        activityPicker.reloadAllComponents()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //========================================
    // MARK: Helpers
    //========================================
    
    @objc func saveButtonPressed() {
        
        if activity == activityArray[0] {
            activity = "Inactive"
        } else if activity == activityArray[1] {
            activity = "Moderate"
        } else {
            activity = "Active"
        }
        
        model.callback(activity)
        delegate?.modalClose()
    }
    
    @objc func cancelButtonPressed() {
        delegate?.modalClose()
    }
}

//=============================================
// MARK: UIPickerViewDataSource
//=============================================

//extension ActivityPickerView: UIPickerViewDataSource, UIPickerViewDelegate {
//    
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return activityArray.count
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return activityArray[row]
//    }
//    
//    internal func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        activity = activityArray[row]
//        
//    }
//}
