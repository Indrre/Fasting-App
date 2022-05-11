//
//  WaterViewController.swift
//  Fasting App
//
//  Created by indre zibolyte on 26/03/2022.
//

import Foundation
import UIKit
import FirebaseAuth

class WaterViewController: UIViewController {
    
    // =============================================
    // MARK: Properties
    // =============================================
        
    lazy var waterView: WaterMainView = {
        let view = WaterMainView(model: model.waterModel)
        return view
    }()

    lazy var model: WaterViewModel = {
        let model = WaterViewModel()
        model.refreshController = { [ weak self ] in
            self?.setup()
        }
        model.presentPickerController = { [weak self] controller in
            self?.present(
                controller,
                animated: true,
                completion: nil
            )
        }
        return model
    }()
    
    // =============================================
    // MARK: Initialization
    // =============================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model.viewDidLoad()
        setup()
        
        view.addSubview(waterView)
        waterView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(15)
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(view.safeAreaLayoutGuide)
        }
    
        title = "Water"
        view.backgroundColor = .stdBackground
        
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: self, action: nil)
        navigationItem.backBarButtonItem = backButton

        navigationController?.navigationBar.tintColor = .stdText
        setLargeTitleDisplayMode(.always)
    }
    
    // =============================================
    // MARK: Helpers
    // =============================================
    
    func setup() {
        waterView.model = model.waterModel
    }
}
