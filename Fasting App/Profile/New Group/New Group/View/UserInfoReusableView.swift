//
//  UserInfoReusableView.swift
//  Fasting App
//
//  Created by indre zibolyte on 02/02/2022.
//
//

import Foundation
import UIKit

struct ProfileInfoModel {
    
//    let type: PersonalInfo
    let name: String
    var value: String?
    let action: (() -> Void)?
    
    init(
        name: String,
        value: String? = nil,
        action: (() -> Void)? = nil) {
            self.name = name
            self.value = value
            self.action = action
        }
}

class UserInfoReusableView: UIView {
    
    // =============================================
    // MARK: Properties
    // =============================================
    
    let lblName: UILabel = {
        let view = UILabel()
        view.textColor = .stdText
        view.font = UIFont(name: "Montserrat-Light", size: 20)
        return view
    }()
    
    lazy var editIcon: UIButton = {
        var editButton = UIButton()
        editButton.setImage(UIImage(named: "profile-info-edit"), for: .normal)
        editButton.addTarget(self, action: #selector(editButtonPressed), for: .touchUpInside)
        return editButton
    }()
    
    var lblValue: UILabel = {
        let view = UILabel()
        view.textColor = .stdText
        view.font = UIFont(name: "Montserrat-Light", size: 20)
        return view
    }()
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .infoLineColor
        return view
    }()
    
    var model: ProfileInfoModel? {
        didSet {
            guard let model = model else { return }
            
            lblName.text = model.name
            lblValue.text = model.value
            callback = model.action
        }
    }
    
    // =============================================
    // MARK: Callback
    // =============================================
    
     var callback: (() -> Void)?
    
    // =============================================
    // MARK: Initialization
    // =============================================
    
    init() {
        super.init(frame: .zero)
        
        addShadow()
        
        addSubview(lblName)
        lblName.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(15)
            $0.left.equalToSuperview().offset(15)
        }
        
        addSubview(editIcon)
        editIcon.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-15)
            $0.size.equalTo(25)
            $0.centerY.equalToSuperview()
        }
        
        addSubview(lblValue)
        lblValue.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(editIcon.snp.left).offset(-15)
        }
        
        addSubview(lineView)
        lineView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.left.right.equalToSuperview().inset(15)
            $0.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // =============================================
    // MARK: Helpers
    // =============================================

    @objc func editButtonPressed() {
        model?.action?()
    }
}
