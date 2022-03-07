//
//  LaunchViewController.swift
//  Fasting App
//
//  Created by indre zibolyte on 06/03/2022.
//

import UIKit
import SnapKit
import AuthenticationServices
import FirebaseAuth

class LaunchViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .stdBackground
        
        checkIfUserIsLogedIn()
    }
    
    // =============================================
    // MARK: - Helpers
    // =============================================
    
    @objc func checkIfUserIsLogedIn() {
        if Auth.auth().currentUser?.uid == nil {
            presentLogin()
        } else {
            presentMainContoller()
        }
    }
    
    func presentMainContoller() {
        navigationController?.pushViewController(MainViewController(), animated: false)
    }
    
    func presentLogin() {
        navigationController?.pushViewController(LoginViewController(), animated: true)
    }
}
