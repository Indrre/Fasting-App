//
//  NameEditView.swift
//  Fasting App
//
//  Created by indre zibolyte on 02/02/2022.
//

import Foundation
import UIKit

class NameEditView: UIView, UITextFieldDelegate {
    
    //=============================================
    // MARK: Properties
    //=============================================
    
    //    var name: String = ""
    
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
        label.text = "What's your name?"
        label.textAlignment = .center
        label.textColor = .stdText
        return label
    }()
    
    let texfield: UITextField = {
        let view = UITextField()
        view.layer.cornerRadius = 5
        view.layer.borderWidth = 1.5
        view.layer.borderColor = UIColor.infoLineColor?.cgColor
        view.textAlignment = .center
        view.placeholder = "Your name"
        view.font = UIFont(name: "Montserrat-Light", size: 20)
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
    
    //=================================
    // MARK: Callbacks
    //=================================
    
    var callback: ((_ name: String) -> Void)?
    var dismiss: (() -> Void)?
    
    //=================================
    // MARK: Initialization
    //=================================
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .stdBackground
        
        addSubview(homeIndicatorBar)
        homeIndicatorBar.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.width.equalTo(60)
            $0.height.equalTo(5)
            $0.centerX.equalToSuperview()
        }
        
        addSubview(topLabel)
        topLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(70)
            $0.centerX.width.equalToSuperview()
        }
        
        addSubview(texfield)
        texfield.snp.makeConstraints {
            $0.width.equalToSuperview().inset(25)
            $0.top.equalToSuperview().offset(150)
            $0.height.equalTo(50)
            $0.centerX.equalToSuperview()
        }
        
        addSubview(selectButton)
        selectButton.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.left.right.equalToSuperview().inset(15)
            $0.top.equalTo(texfield.snp.bottom).offset(100)
        }
        
        addSubview(cancelButton)
        cancelButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.size.equalTo(selectButton)
            $0.top.equalTo(selectButton.snp.bottom).offset(15)
        }
        texfield.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //=============================================
    // MARK: Helpers
    //=============================================
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        texfield.endEditing(true)
        return true
    }
    
    @objc func saveButtonPressed() {
        if let name = texfield.text {
            callback?(name)
        }
    }
    
    @objc func cancelButtonPressed() {
        dismiss?()
    }
    
}
