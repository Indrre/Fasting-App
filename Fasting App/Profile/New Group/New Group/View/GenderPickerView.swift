//
//  GenderPickerView.swift
//  Fasting App
//
//  Created by indre zibolyte on 06/02/2022.
//

import Foundation
import UIKit

struct GenderPickerModel {
    var gender: String?
    let callback: ((_ gender: String) -> Void?)
}

class GenderPickerView: UIView {
    
    // =============================================
    // MARK: Properties
    // =============================================
    
    weak var delegate: ModalViewControllerDelegate?
    
    var gender: String = "Female"
    
    var genderArray = ["Female", "Male", "Other"]
    
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
        label.text = "Gender"
        return label
    }()
    
    lazy var genderPicker: UIPickerView = {
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
    
    var model: GenderPickerModel {
        didSet {
            gender = model.gender ?? "Other"
            genderPicker.selectRow(
                genderArray.firstIndex(of: model.gender ?? "Other") ?? 2,
                inComponent: 0,
                animated: true
            )
        }
    }
    
    // =============================================
    // MARK: Initialization
    // =============================================
    
    init(model: GenderPickerModel) {
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

        addSubview(genderPicker)
        genderPicker.snp.makeConstraints {
            $0.height.equalTo(100)
            $0.top.equalTo(topLabel.snp.bottom).offset(10)
            $0.left.right.equalToSuperview().inset(15)
        }
        
        addSubview(selectButton)
        selectButton.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.left.right.equalToSuperview().inset(15)
            $0.top.equalTo(genderPicker.snp.bottom).offset(30)
        }
        
        addSubview(cancelButton)
        cancelButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.size.equalTo(selectButton)
            $0.top.equalTo(selectButton.snp.bottom)
        }
        
        genderPicker.reloadAllComponents()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // ========================================
    // MARK: Helpers
    // ========================================
    
    @objc func saveButtonPressed() {
        model.callback(gender)
        delegate?.modalClose()
    }
    
    @objc func cancelButtonPressed() {
        delegate?.modalClose()
    }
}
