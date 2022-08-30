////
////  SettingsViewController.swift
////  Fasting App
////
////  Created by indre zibolyte on 29/08/2022.
////
//
//import Foundation
//import UIKit
//import MessageUI
//
//class SettingsViewController: UIViewController {
//    
//    // =============================================
//    // MARK: Components
//    // =============================================
//    
//    lazy var settingsView: SettingsView = {
//        return SettingsView(model: model.settingsModel)
//    }()
//    
//    // =============================================
//    // MARK: Properties
//    // =============================================
//    
//    lazy var model: SettingsViewModel = {
//        let model = SettingsViewModel()
//        model.refreshController = { [ weak self ] in
//            self?.setup()
//        }
//        model.presentLogin = { [weak self] controller in
//            self?.navigationController?
//                .pushViewController(
//                    controller,
//                    animated: true
//                )
//        }
//        model.presentEmail = { [weak self]  in
//            self?.sendEmail()
//        }
//        model.prsentActionSheet = { [ weak self ] actionSheet in
//            self?.present(actionSheet, animated: true, completion: nil)
//        }
//        return model
//    }()
//    
//    // =============================================
//    // MARK: Initialization
//    // =============================================
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        model.viewDidLoad()
//        
//        view.backgroundColor = .stdBackground
//        
//        view.addSubview(settingsView)
//        settingsView.snp.makeConstraints {
//            $0.edges.equalTo(view.safeAreaLayoutGuide)
//        }
//    }
//    
//    // =============================================
//    // MARK: Helpers
//    // =============================================
//    
//    func setup() {
//        settingsView.model = model.settingsModel
//    }
//    
//    @objc func sendEmail() {
//        if MFMailComposeViewController.canSendMail() {
//        let mail = MFMailComposeViewController()
//        mail.mailComposeDelegate = self as? MFMailComposeViewControllerDelegate
//        mail.setToRecipients(["izi2dev.app@gmail.com"])
//            present(mail, animated: true)
//        } else {
//            debugPrint("Cannot send email")
//        }
//    }
//
//    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
//    controller.dismiss(animated: true)
//    }
//}
