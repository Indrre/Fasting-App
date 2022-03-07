//
//  NameEditController.swift
//  Fasting App
//
//  Created by indre zibolyte on 02/02/2022.
//

import Foundation
import SnapKit
import UIKit

class NameEditController: ModalViewController {
    
// =============================================
// MARK: Components
// =============================================

lazy var nameEditView: NameEditView = {
    let view = NameEditView()
    view.layer.cornerRadius = 20
    view.callback = { [weak self]  name in
        self?.updateName(name: name)
    }
    view.dismiss = { [weak self] in
        self?.dismiss()
    }
    return view
}()

override func viewDidLoad() {
    super.viewDidLoad()
     
    view.backgroundColor = .clear
    
    view.addSubview(nameEditView)
    nameEditView.snp.makeConstraints {
        bottomConstraint = $0.bottom.equalToSuperview().inset(50).constraint
        $0.height.equalTo(500)
        $0.left.right.equalToSuperview().inset(10)
    }
}

// =============================================
// MARK: Helpers
// =============================================
    
    func updateName(name: String) {
        let values = ["fullName": name]
        Service.shared.updateUserValues(values: values as [String: Any])
        UserService.refreshUser()
        dismiss(animated: true, completion: nil)
    }
    
    func dismiss() {
        dismiss(animated: true, completion: nil)
    }

}

extension NameEditController: ModalViewControllerDelegate {
    func modalClose() {
        dismissModal()
    }
}
