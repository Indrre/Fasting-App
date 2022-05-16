//
//  WaterPickerViewController.swift
//  Fasting App
//
//  Created by indre zibolyte on 27/03/2022.
//

import Foundation
import UIKit
import SnapKit

class WaterPickerViewController: ModalViewController {
    
    // =============================================
    // MARK: Properties
    // =============================================

    lazy var waterPickerView: WaterPickerView = {
        let view = WaterPickerView(model: model.waterPickerModel)
        view.dismiss = { [weak self] in
            self?.dismissModal()
            self?.complete?()
        }
        view.layer.cornerRadius = 20
        return view
    }()
    
    lazy var model: WaterPickerViewModel = {
        let model = WaterPickerViewModel()
        model.refreshController = { [weak self] in
            self?.setup()
        }
        return model
    }()

    var complete: (() -> Void)?
    
    // =============================================
    // MARK: Initialization
    // =============================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model.viewDidLoad()
        setup()
        
        view.addSubview(waterPickerView)
        waterPickerView.snp.makeConstraints {
            bottomConstraint = $0.bottom.equalToSuperview().inset(50).constraint
            $0.height.equalTo(403)
            $0.left.right.equalToSuperview().inset(10)
        }
    }
    
    // =============================================
    // MARK: Helpers
    // =============================================
    
    func setup() {
        waterPickerView.model = model.waterPickerModel
    }
}
