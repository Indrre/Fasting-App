//
//  DatePickerViewController.swift
//  Fasting App
//
//  Created by indre zibolyte on 26/01/2022.
//

import Foundation
import UIKit

class DatePickerViewController: ModalViewController {
    
    // =======================================
    // MARK: Properties
    // =======================================
    
    let datePickerView: DatePickerView
    
    // =======================================
    // MARK: Callback
    // =======================================
    
    var selectedCallback: (() -> Void)?
    var didDismiss: ((TimeInterval?) -> Void)?
    
    // =======================================
    // MARK: Initialization
    // =======================================
    
    init(model: DatePickerViewModel) {
        datePickerView = DatePickerView(model: model)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // =======================================
    // MARK: Lifecycle
    // =======================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        datePickerView.completionCallback = { [weak self] in
            self?.dismissModal()
        }
        view.addSubview(datePickerView)
        datePickerView.layer.cornerRadius = 20
        datePickerView.snp.makeConstraints {
            bottomConstraint = $0.bottom.equalToSuperview().inset(50).constraint
            $0.height.equalTo(453)
            $0.left.right.equalToSuperview().inset(10)
        }
    }
    
}
