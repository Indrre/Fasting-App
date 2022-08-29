//
//  SettingsView.swift
//  Fasting App
//
//  Created by indre zibolyte on 29/08/2022.
//

import Foundation
import UIKit

struct SettingsModel {
    let signOut: (() -> Void?)
    let email: (() -> Void?)
    let delete: ((UIAlertController) -> Void?)
    let proceedeToDeletion: (() -> Void?)
}

class SettingsView: UIView {
    
    // =============================================
    // MARK: Properties
    // =============================================
    
    lazy var btnDelete: UIButton = {
        let view = UIButton()
        view.backgroundColor = .red
        view.layer.cornerRadius = 10
        view.setTitle("Delete account", for: .normal)
        view.titleLabel?.font = UIFont(name: "Montserrat-Medium", size: 18)
        view.setTitleColor(.white, for: .normal)
        view.addTarget(self, action: #selector(actionSheet), for: .touchUpInside)
        return view
    }()
    
    lazy var btnContact: UIButton = {
        let view = UIButton()
        view.backgroundColor = .timeColor
        view.layer.cornerRadius = 10
        view.setTitle("Contact us", for: .normal)
        view.titleLabel?.font = UIFont(name: "Montserrat-Medium", size: 18)
        view.setTitleColor(.white, for: .normal)
        view.addTarget(self, action: #selector(email), for: .touchUpInside)
        return view
    }()
    
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
    
    var model: SettingsModel?
    
    // =================================
    // MARK: Callbacks
    // =================================
    
    var action: (() -> Void)?
    
    // ========================================
    // MARK: Initialization
    // ========================================
    
    init(model: SettingsModel) {
        self.model = model
        super.init(frame: .zero)
        
        
        addSubview(btnDelete)
        btnDelete.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(safeAreaLayoutGuide).offset(40)
            $0.width.equalToSuperview().inset(20)
        }
                
        addSubview(btnSignOut)
        btnSignOut.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(40)
            $0.width.equalToSuperview().inset(20)
        }
        
        addSubview(btnContact)
        btnContact.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.center.equalToSuperview()
//            $0.bottom.equalTo(btnSignOut.snp.top).offset(40)
            $0.width.equalToSuperview().inset(20)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func signOut() {
        model?.signOut()
    }
    
    @objc func email() {
        model?.email()
    }
    
    @objc func actionSheet() {
        let actionSheet = UIAlertController(
            title: nil,
            message: "Are you sure you want to delete your account? All your data will be permanently erased!",
            preferredStyle: .actionSheet
        )
        
        actionSheet.addAction(
            UIAlertAction(
                title: "Delete",
                style: .default,
                handler: { _ in
                    self.deleteAccount()
                }
            )
        )
        actionSheet.addAction(
            UIAlertAction(
                title: "Cancel",
                style: .cancel,
                handler: nil
            )
        )
        actionSheet.view.tintColor = UIColor.stdText
        model?.delete(actionSheet)
    }
    
    func deleteAccount() {
        model?.proceedeToDeletion()
    }
        
}
