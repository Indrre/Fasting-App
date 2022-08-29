//
//  SettingsViewModel.swift
//  Fasting App
//
//  Created by indre zibolyte on 29/08/2022.
//

import Foundation
import UIKit
import FirebaseAuth

class SettingsViewModel {
    
    var settingsModel: SettingsModel {
        return SettingsModel(
            signOut: { [weak self] in
                self?.signOut()
            }, email: { [ weak self ] in
                self?.presentEmail?()
            }, delete: { [ weak self ] actionSheet in
                self?.prsentActionSheet?(actionSheet)
            }, proceedeToDeletion: { [ weak self ] in
                self?.proceedeToDeletion()
            }
        )
    }
    
    // =================================
    // MARK: Callbacks
    // =================================
    
    var refreshController: (() -> Void)?
    var presentLogin: ((UIViewController) -> Void)?
    var presentEmail: (() -> Void)?
    var prsentActionSheet: ((UIAlertController) -> Void)?
    // =============================================
    // MARK: Helpers
    // =============================================
    
    func viewDidLoad() {
        refreshController?()
    }
    
    // =============================================
    // MARK: Helpers
    // =============================================
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            presentLoginController()
        } catch {
            debugPrint("DEBUG: Error Signing Out")
        }
    }
    
    func presentLoginController() {
        let controller = LoginViewController()
        presentLogin?(controller)
    }
    
    func proceedeToDeletion() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let user = Auth.auth().currentUser else { return }
    
        DB_REF.child("users").child(uid).removeValue()
        DB_REF.child("fasts").child(uid).removeValue()
        DB_REF.child("water").child(uid).removeValue()
        DB_REF.child("weight").child(uid).removeValue()

        user.delete { error in
          if let error = error {
            debugPrint("DEBUG: ERROR WHILE DELETING USER AUTH \(error)")
          } else {
            debugPrint("DEBUG: USER REMOVED SUCCESSFULLY!")
          }
        }
        
        presentLoginController()
    }
}
