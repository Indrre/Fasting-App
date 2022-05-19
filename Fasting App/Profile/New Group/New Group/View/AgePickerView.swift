//
//  AgePickerView.swift
//  Fasting App
//
//  Created by indre zibolyte on 06/02/2022.
//

import Foundation
import UIKit

struct AgePickerModel {
    
    var value: Int?
//    let dataSource: UIPickerViewDataSource
//    let delegate: UIPickerViewDelegate
    let callback: ((_ age: Int) -> Void?)
    
}

class AgePickerView: UIView {
    
    // =============================================
    // MARK: Properties
    // =============================================
    
    weak var delegate: ModalViewControllerDelegate?
    
    var age: Int = 3
    
    var ageArray = Array(18...100)
    
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
        label.text = "Age"
        return label
    }()
    
    lazy var agePicker: UIPickerView = {
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
    
    var model: AgePickerModel {
        didSet {
            age = model.value ?? 0
        }
    }
    
    // =============================================
    // MARK: Initialization
    // =============================================
    
    init(model: AgePickerModel) {
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

        addSubview(agePicker)
        agePicker.snp.makeConstraints {
            $0.height.equalTo(180)
            $0.top.equalTo(topLabel.snp.bottom).offset(10)
            $0.left.right.equalToSuperview().inset(15)
        }
        
        addSubview(selectButton)
        selectButton.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.left.right.equalToSuperview().inset(15)
            $0.top.equalTo(agePicker.snp.bottom).offset(10)
        }
        
        addSubview(cancelButton)
        cancelButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.size.equalTo(selectButton)
            $0.top.equalTo(selectButton.snp.bottom)
        }
        
        agePicker.reloadAllComponents()
        agePicker.selectRow(
            ageArray.firstIndex(of: model.value ?? 0) ?? 0,
            inComponent: 0,
            animated: true
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // ========================================
    // MARK: Helpers
    // ========================================
    
    @objc func saveButtonPressed() {
        model.callback(age)
        delegate?.modalClose()
    }
    
    @objc func cancelButtonPressed() {
        delegate?.modalClose()
    }
}
