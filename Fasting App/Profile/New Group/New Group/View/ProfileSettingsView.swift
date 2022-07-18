//
//  ProfileSettingsView.swift
//  Fasting App
//
//  Created by indre zibolyte on 31/01/2022.
//

import Foundation
import UIKit
import FirebaseAuth

struct ProfileSettingsModel {
    var profileImage: UIImage?
    var name: String
    var age: String?
    var weight: String?
    var height: String?
    var gender: String?
    var activity: String?
    let callback: (() -> Void?)
    let presentController: ((_ type: PersonalInfo) -> Void)?
    let signOut: (() -> Void?)
}

class ProfileSettingsView: UIView {
    
    // =============================================
    // MARK: Properties
    // =============================================
    
    let imageSize: CGFloat = 175
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.image = UIImage(named: "profile-pic")
        return view
    }()
    
    let lblName: UILabel = {
        let view = UILabel()
        view.textColor = .stdText
        view.text = "Name"
        view.font = UIFont(name: "Montserrat-Light", size: 30)
        return view
    }()
    
    lazy var pictureBtnEdit: UIButton = {
        let editButton = UIButton()
        editButton.titleLabel?.font = UIFont(name: "Montserrat-ExtraLight", size: 15)
        editButton.setTitleColor(.stdText, for: .normal)
        editButton.addTarget(self, action: #selector(editBtnPressed), for: .touchUpInside)
        return editButton
    }()
    
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 25
        return view
    }()
    
    let optionStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 25
        return view
    }()
    
    var availableOptions: [PersonalInfo] {
        return [.age, .weight, .height, .gender, .activity]
    }
    
    // COME BACK ANOTHER DAY
    var optionValues: [PersonalInfo: String] = [:]
    
    var optionViews: [UserInfoReusableView] {
        return availableOptions.compactMap { type in
            let view = UserInfoReusableView()
            view.model = ProfileInfoModel(
                name: type.title,
                value: optionValues[type],
                action: { [weak self] in
                    self?.showPicker(type: type)
                }
            )
            return view
        }
    }
    
    lazy var btnSignOut: UIButton = {
        let view = UIButton()
        view.backgroundColor = .timeColor
        view.layer.cornerRadius = 10
        view.setTitle("Sign Out", for: .normal)
        view.titleLabel?.font = UIFont(name: "Montserrat-Medium", size: 18)
        view.setTitleColor(.white, for: .normal)
        view.addTarget(self, action: #selector(signOut), for: .touchUpInside)
        return view
    }()
    
    func showPicker(type: PersonalInfo) {
        model.presentController?(type)
    }
    
    var model: ProfileSettingsModel {
        didSet {
            lblName.text = model.name
            imageView.image = model.profileImage
            
            optionValues[.age] = model.age
            optionValues[.weight] = model.weight
            optionValues[.height] = model.height
            optionValues[.gender] = model.gender
            optionValues[.activity] = model.activity
            refreshOptions()
        }
    }
    
    // =================================
    // MARK: Callbacks
    // =================================
    
    var action: (() -> Void)?
    
    // ========================================
    // MARK: Initialization
    // ========================================
    
    init(model: ProfileSettingsModel) {
        self.model = model
        super.init(frame: .zero)
            
        addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
            $0.size.equalTo(imageSize)
        }
        
        addSubview(lblName)
        lblName.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(15)
            $0.centerX.equalTo(imageView)
        }
        
        addSubview(pictureBtnEdit)
        pictureBtnEdit.setTitle("Edit", for: .normal)
        pictureBtnEdit.snp.makeConstraints {
            $0.top.equalTo(lblName.snp.bottom).offset(10)
            $0.centerX.equalTo(imageView)
        }
        
        addSubview(btnSignOut)
        btnSignOut.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(20)
            $0.width.equalToSuperview().inset(20)
        }
        
        addSubview(scrollView)
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(pictureBtnEdit.snp.bottom).offset(20)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-70)
        }

        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(10)
            $0.width.equalToSuperview().offset(-30)
            $0.bottom.equalToSuperview()
        }
        
        stackView.addArrangedSubview(optionStackView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.cornerRadius = imageView.frame.size.height/2
    }
    
    // =============================================
    // MARK: Helpers
    // =============================================
    
    func refreshOptions() {
        optionStackView.subviews.forEach { $0.removeFromSuperview() }
        
        optionViews.forEach { view in
            optionStackView.addArrangedSubview(view)
        }
    }
    
    @objc func editBtnPressed() {
        model.callback()
    }
    
    @objc func signOut() {
        model.signOut()
    }
}
