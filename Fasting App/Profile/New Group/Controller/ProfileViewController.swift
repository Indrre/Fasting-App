//
//  ProfileViewController.swift
//  Fasting App
//
//  Created by indre zibolyte on 29/01/2022.
//

import Foundation

import UIKit
import MessageUI
import FirebaseAuth


class ProfileViewController: ViewController, MFMailComposeViewControllerDelegate {
    
    // =============================================
    // MARK: Components
    // =============================================
    
    lazy var profileSettingsView: ProfileSettingsView = {
        return ProfileSettingsView(model: model.profileSettingsModel)
    }()
    
    // =============================================
    // MARK: Properties
    // =============================================
    
    lazy var model: ProfileSettingViewModel = {
        let model = ProfileSettingViewModel()
        model.refreshController = { [weak self] in
            self?.setup()
        }
        model.presentActionSheet = { [weak self] controller in
            self?.present(
                controller,
                animated: true,
                completion: nil
            )
        }
        model.presentNameEditController = { [weak self] controller in
            controller.modalPresentationStyle = .overFullScreen
            self?.present(
                controller,
                animated: true,
                completion: nil
            )
        }
        model.presentImageEditController = { [weak self] controller in
            controller.modalPresentationStyle = .overFullScreen
            self?.present(
                controller,
                animated: true,
                completion: nil
            )
        }
        model.presentPickerController = { [weak self] controller in
            controller.modalPresentationStyle = .overFullScreen
            self?.present(
                controller,
                animated: false,
                completion: nil
            )
        }
        model.presentSettings = { [weak self] controller in
            self?.navigationController?
                .pushViewController(
                    controller,
                    animated: true)
        }
        model.startSpinning = { [weak self] in
            self?.profileSettingsView.activityView.startAnimating()
        }
        model.stopSpinning = { [weak self] in
            self?.profileSettingsView.activityView.stopAnimating()
        }
        return model
    }()
    
    // =============================================
    // MARK: Initialization
    // =============================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.viewDidLoad()
        
        setNavigationBarItem()
        
        view.addSubview(profileSettingsView)
        profileSettingsView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        profileSettingsView.activityView.stopAnimating()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: self, action: nil)
        navigationItem.backBarButtonItem = backButton
        
        navigationController?.navigationBar.tintColor = .stdText
        setLargeTitleDisplayMode(.never)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileSettingsView.stackView.layoutIfNeeded()
        profileSettingsView.scrollView.contentSize = CGSize(
            width: view.frame.size.width,
            height: profileSettingsView.stackView.frame.size.height
        )
    }
    
    // =============================================
    // MARK: Helpers
    // =============================================
    
    func setup() {
        profileSettingsView.model = model.profileSettingsModel
    }
    
//    @objc func takeToSettings() {
//        let controller = SettingsViewController()
//        navigationController?.pushViewController(controller, animated: true)
//    }
    
    func setNavigationBarItem() {
        let navigationArrow = UIButton(type: .system)
        navigationArrow.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        navigationArrow.setImage(UIImage(named: "navigation-arrow"), for: .normal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: navigationArrow)
        
        let delete = UIAction(title: "Delete account", image: UIImage(systemName: "trash"), attributes: .destructive) { (_) in
         
            let actionSheet = UIAlertController(
                title: nil,
                message: "Are you sure you want to delete your account? All your data will be permanently erased!",
                preferredStyle: .actionSheet
            )
            
            actionSheet.addAction(
                UIAlertAction(
                    title: "Delete",
                    style: .destructive,
                    handler: { _ in
                        self.proceedeToDeletion()
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
            self.present(actionSheet, animated: true, completion: nil)
        }
        let contact = UIAction(title: "Contact us", image: UIImage(systemName: "square.and.pencil")) { (_) in
            self.sendEmail()
        }
        
        let logOut = UIAction(title: "Log Out", image: UIImage(systemName: "iphone.and.arrow.forward")) { (_) in
            self.signOut()
        }
        
        let menu = UIMenu(title: "", children: [delete, contact, logOut])
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: nil, image: UIImage(systemName: "gear"), primaryAction: nil, menu: menu)
        
    }
    
    func showActionSheetController() {
//        let actionSheet = UIAlertController(title: nil, message: "Please select to edit", preferredStyle: .actionSheet)
//        actionSheet.addAction(UIAlertAction(title: "Image", style: .default, handler: {(_) -> Void in self.takeToSettings() }))
//        actionSheet.addAction(UIAlertAction(title: "Name", style: .default, handler: {(_) -> Void in self.takeToSettings()}))
//        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {(_) -> Void in }))
//        present(actionSheet, animated: true, completion: nil)
//        actionSheet.view.tintColor = UIColor.stdText
    }
    
    @objc func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self as? MFMailComposeViewControllerDelegate
            mail.setToRecipients(["izi2dev.app@gmail.com"])
            present(mail, animated: true)
        } else {
            debugPrint("Cannot send email")
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            UserService.removeUserDefaults()
            presentLoginController()
        } catch {
            debugPrint("DEBUG: Error Signing Out")
        }
    }
    
    func presentLoginController() {
        let controller = LoginViewController()
        navigationController?
            .pushViewController(
                controller,
                animated: true
            )
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
        UserService.removeUserDefaults()
        
        presentLoginController()
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
                    self.proceedeToDeletion()
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

    }
    
//    func deleteAccount() {
//        model?.proceedeToDeletion()
//    }
}
