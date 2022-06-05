////
////  PickerView.swift
////  Fasting App
////
////  Created by indre zibolyte on 24/02/2022.
////
//
//import Foundation
//import UIKit
//
//class PickerView: UIView {
//    
//    // =============================================
//    // MARK: Properties
//    // =============================================
//    
//    weak var delegate: ModalViewControllerDelegate?
//    
//    var age: Int = 18
//        
//    var ageArray = Array(18...100)
//    
//    lazy var homeIndicatorBar: UIImageView = {
//        let view = UIImageView()
//        view.tintColor = .stdText
//        view.image = UIImage(named: "home-indicator-bar")?.withRenderingMode(.alwaysTemplate)
//        view.clipsToBounds = true
//        view.layer.cornerRadius = 3
//        view.backgroundColor = .homeIndicatorColor
//        return view
//    }()
//
//    let topLabel: UILabel = {
//        let label = UILabel()
//        label.font =  UIFont(name: "Montserrat-SemiBold", size: 24)
//        label.textAlignment = .center
//        label.textColor = .stdText
//        return label
//    }()
//    
//    lazy var picker: UIPickerView = {
//        let view = UIPickerView()
//        view.tintColor = .stdText
//        return view
//    }()
//    
//    lazy var selectButton: UIButton = {
//        let view = UIButton()
//        view.backgroundColor = .timeColor
//        view.layer.cornerRadius = 10
//        view.setTitle("Select", for: .normal)
//        view.titleLabel?.font = UIFont(name: "Montserrat-Medium", size: 18)
//        view.setTitleColor(.white, for: .normal)
//        view.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
//        return view
//    }()
//    
//    lazy var cancelButton: UIButton = {
//        let view = UIButton()
//        view.setTitle("Cancel", for: .normal)
//        view.titleLabel?.font = UIFont(name: "Montserrat-Medium", size: 18)
//        view.setTitleColor(.stdText, for: .normal)
//        view.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
//        return view
//    }()
//    
//    // =============================================
//    // MARK: Initialization
//    // =============================================
//    
//    init() {
//        super.init(frame: .zero)
//        
//        backgroundColor = .red
//                
//        addSubview(homeIndicatorBar)
//        homeIndicatorBar.snp.makeConstraints {
//            $0.top.equalToSuperview().offset(15)
//            $0.width.equalTo(60)
//            $0.height.equalTo(5)
//            $0.centerX.equalToSuperview()
//        }
//        
//        addSubview(topLabel)
//        topLabel.snp.makeConstraints {
//            $0.top.equalToSuperview().offset(40)
//            $0.centerX.width.equalToSuperview()
//        
//        }
//
//        addSubview(picker)
//        picker.snp.makeConstraints {
//            $0.height.equalTo(180)
//            $0.top.equalTo(topLabel.snp.bottom).offset(10)
//            $0.left.right.equalToSuperview().inset(15)
//        }
//        
//        addSubview(selectButton)
//        selectButton.snp.makeConstraints {
//            $0.height.equalTo(50)
//            $0.left.right.equalToSuperview().inset(15)
//            $0.top.equalTo(picker.snp.bottom).offset(10)
//        }
//        
//        addSubview(cancelButton)
//        cancelButton.snp.makeConstraints {
//            $0.centerX.equalToSuperview()
//            $0.size.equalTo(selectButton)
//            $0.top.equalTo(selectButton.snp.bottom)
//        }
//        
//        picker.reloadAllComponents()
//        picker.selectRow(
//            ageArray.firstIndex(of: age) ?? 0,
//            inComponent: 0,
//            animated: true
//        )
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    // ========================================
//    // MARK: Helpers
//    // ========================================
//    
//    @objc func saveButtonPressed() {
////        model.callback(age)
//        delegate?.modalClose()
//    }
//    
//    @objc func cancelButtonPressed() {
//        delegate?.modalClose()
//    }
//}
