//
//  FastSelectionController.swift
//  Fasting App
//
//  Created by indre zibolyte on 26/01/2022.
//

import Foundation
import UIKit

class FastSelectionsViewController: ModalViewController {
    
    //=======================================
    //MARK: Properties
    //=======================================
    
    lazy var fastPickerView: FastPickerView = {
        return FastPickerView(model: model.fastPickerModel)
    }()
   
    
    lazy var model: MainViewModel = {
        let model = MainViewModel()
        model.refreshController = { [weak self] in
            self?.setup()
        }
        return model
    }()
    
    func setup() {
        print("SETUOP!!!e")
    }

    
    //=======================================
    //MARK: Callback
    //=======================================
    
    var selectedCallback: (() -> Void)?
    var didDismiss: ((TimeInterval?) -> Void)?
    
    
    //=======================================
    //MARK: Initialization
    //=======================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fastPickerView.delegate = self
        view.addSubview(fastPickerView)
        fastPickerView.layer.cornerRadius = 20
        fastPickerView.snp.makeConstraints {
            bottomConstraint = $0.bottom.equalToSuperview().inset(50).constraint
            $0.height.equalTo(453)
            $0.left.right.equalToSuperview().inset(10)
        }
    }
    
    //=======================================
    //MARK: Helpers
    //=======================================
    
    func setupView() {
        fastPickerView.model = model.fastPickerModel
    }
}

extension FastSelectionsViewController: ModalViewControllerDelegate {
    func modalClose() {
        dismissModal()
    }
    
}

