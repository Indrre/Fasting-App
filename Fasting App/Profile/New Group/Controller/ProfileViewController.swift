//
//  ProfileViewController.swift
//  Fasting App
//
//  Created by indre zibolyte on 29/01/2022.
//

import Foundation

import UIKit

class ProfileViewController: UIViewController {
    
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
        model.rerefreshController = { [weak self] in
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
        model.presentInageEditController = { [weak self] controller in
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
        return model
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.viewDidLoad()
        
        view.backgroundColor = .stdBackground

        view.addSubview(profileSettingsView)
        profileSettingsView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
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
    
    //=============================================
    // MARK: Helpers
    //=============================================
    
    func setNavigationBarItem() {
        let navigationArrow = UIButton(type: .system)
        navigationArrow.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        navigationArrow.setImage(UIImage(named: "navigation-arrow"), for: .normal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: navigationArrow)
    }
    
    func setup() {
        profileSettingsView.model = model.profileSettingsModel
    }
    
}
