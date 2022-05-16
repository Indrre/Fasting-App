//
//  WaterPickerView.swift
//  Fasting App
//
//  Created by indre zibolyte on 27/03/2022.
//

import Foundation
import UIKit

struct WaterPickerModel {
    var label: String
    let incrementWater: (() -> Void?)
    let decrementWater: (() -> Void?)
    let saveWater: (() -> Void?)
}

class WaterPickerView: UIView {
    
    // =============================================
    // MARK: Properties
    // =============================================
    
    lazy var homeIndicatorBar: UIImageView = {
        let view = UIImageView()
        view.tintColor = .stdText
        view.image = UIImage(named: "home-indicator-bar")?.withRenderingMode(.alwaysTemplate)
        view.clipsToBounds = true
        view.layer.cornerRadius = 3
        view.backgroundColor = .homeIndicatorColor
        return view
    }()
    
    let lblUpdateWater: UILabel = {
        let label = UILabel()
        label.font =  UIFont(name: "Montserrat-SemiBold", size: 24)
        label.text = "Update Water"
        label.textAlignment = .center
        label.textColor = .stdText
        return label
    }()
    
    let lblMessage: UILabel = {
        let label = UILabel()
        label.font =  UIFont(name: "Montserrat-ExtraLight", size: 14)
        label.numberOfLines = 0
        label.text = "Average glass of water is 250ml. How many glasses have you consumed today?"
        label.textAlignment = .center
        label.textColor = .stdText
        return label
    }()
    
    lazy var incrementButton: UIButton = {
        let view = UIButton()
        view.setTitle("+", for: .normal)
        view.backgroundColor = .waterColor
        view.titleLabel?.font = UIFont(name: "Montserrat-Medium", size: 30)
        view.addTarget(self, action: #selector(incrementWater), for: .touchUpInside)
        return view
    }()
    
    lazy var decrementButton: UIButton = {
        let view = UIButton()
        view.setTitle("-", for: .normal)
        view.backgroundColor = UIColor.waterColorLight
        view.titleLabel?.font = UIFont(name: "Montserrat-Medium", size: 30)
        view.addTarget(self, action: #selector(decrementWater), for: .touchUpInside)
        return view
    }()
    
    var lblWater: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "Montserrat-ExtraLight", size: 50)
        view.textAlignment = .center
        view.text = "0"
        return view
    }()
    
    lazy var saveButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .waterColor
        view.layer.cornerRadius = 10
        view.setTitle("Save", for: .normal)
        view.titleLabel?.font = UIFont(name: "Montserrat-Medium", size: 18)
        view.setTitleColor(.white, for: .normal)
        view.addTarget(self, action: #selector(saveWater), for: .touchUpInside)
        return view
    }()
    
    lazy var cancelButton: UIButton = {
        let view = UIButton()
        view.setTitle("Cancel", for: .normal)
        view.titleLabel?.font = UIFont(name: "Montserrat-Medium", size: 18)
        view.setTitleColor(.stdText, for: .normal)
        view.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        return view
    }()
    
    var model: WaterPickerModel {
        didSet {
            lblWater.text = model.label
        }
    }
    
    // =============================================
    // MARK: Callback
    // =============================================
    
    var dismiss: (() -> Void)?
    
    // =============================================
    // MARK: Initialization
    // =============================================
    
    init(model: WaterPickerModel) {
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
                
        addSubview(lblUpdateWater)
        lblUpdateWater.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(35)
        }
        
        addSubview(lblMessage)
        lblMessage.numberOfLines = 0
        lblMessage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(lblUpdateWater.snp.bottom).offset(20)
            $0.height.equalTo(70)
            $0.width.equalToSuperview().inset(15)
        }
        
        addSubview(lblWater)
        lblWater.snp.makeConstraints {
            $0.size.equalTo(70)
            $0.center.equalToSuperview()
        }
        
        setupButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // ========================================
    // MARK: Helpers
    // ========================================
    
    override func layoutSubviews() {
        super.layoutSubviews()
        incrementButton.layer.cornerRadius = incrementButton.frame.width/2
        decrementButton.layer.cornerRadius = decrementButton.frame.width/2
    }
    
    func setupButtons() {
        addSubview(decrementButton)
        decrementButton.snp.makeConstraints {
            $0.size.equalTo(68)
            $0.centerY.equalToSuperview()
            $0.right.equalTo(lblWater.snp.left).inset(-40)
        }
        
        addSubview(incrementButton)
        incrementButton.snp.makeConstraints {
            $0.size.equalTo(68)
            $0.centerY.equalToSuperview()
            $0.left.equalTo(lblWater.snp.right).offset(40)
        }
        
        addSubview(saveButton)
        saveButton.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.width.equalToSuperview().dividedBy(1.1)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(lblWater.snp.bottom).offset(40)
        }
        
        addSubview(cancelButton)
        cancelButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(saveButton.snp.bottom).offset(20)
        }
    }
    
    @objc func incrementWater() {
        model.incrementWater()
    }
    
    @objc func decrementWater() {
        model.decrementWater()
    }
    
    @objc func saveWater() {
        model.saveWater()
        dismiss?()
    }
    
    @objc func cancel() {
        dismiss?()
    }
    
}
