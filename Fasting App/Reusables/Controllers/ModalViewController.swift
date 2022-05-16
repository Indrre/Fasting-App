//
//  ModalViewController.swift
//  Fasting App
//
//  Created by indre zibolyte on 02/02/2022.
//

import Foundation
import UIKit
import SnapKit

protocol ModalViewControllerDelegate: AnyObject {
    func modalClose()
}

class ModalViewController: UIViewController {
    
    // =============================================
    // MARK: Components
    // =============================================
    
    lazy var btnClose: UIButton = {
        let view = UIButton()
        view.backgroundColor = UIColor.stdBackground?.withAlphaComponent(0.6)
        view.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
        return view
    }()

    // =============================================
    // MARK: Constraints
    // =============================================
    
    var bottomConstraint: Constraint?
    
    // =============================================
    // MARK: Initialization
    // =============================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addShadow()
        view.backgroundColor = .clear

        view.addSubview(btnClose)
        btnClose.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        btnClose.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentModal()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bottomConstraint?.update(inset: -view.frame.size.height)
    }
    
    // =============================================
    // MARK: Helpers
    // =============================================
                                                
    func presentModal() {
        bottomConstraint?.update(inset: 50)
        
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                self.btnClose.alpha = 1
                self.view.layoutIfNeeded()
            }
        )
    }
    
    @objc func dismissAction() {
        dismissModal()
    }
    
    func dismissModal(closure: (() -> Void)? = nil) {
        bottomConstraint?.update(inset: -view.frame.size.height)
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.btnClose.alpha = 0
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.dismiss(animated: false, completion: {
                closure?()
            })
        })
    }
}
