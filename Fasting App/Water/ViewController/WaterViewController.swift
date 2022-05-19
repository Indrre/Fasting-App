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
    
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 20
        return view
    }()
        
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
        
        title = "Water"
        view.backgroundColor = .stdBackground
        
        view.addSubview(waterView)
        waterView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().inset(20)
        }
        
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
