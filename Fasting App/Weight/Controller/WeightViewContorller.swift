//
//  WeightViewContorller.swift
//  Fasting App
//
//  Created by indre zibolyte on 17/04/2022.
//

import Foundation
import UIKit

class WeightViewContorller: ViewController {
    
    // =============================================
    // MARK: Properties
    // =============================================
    
    lazy var weightView: WeightMainView = {
        let view = WeightMainView(model: model.weightModel)
        return view
    }()
    
    lazy var model: WeightViewModel = {
        let model = WeightViewModel()
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
//        WeightService.fetchAllWeight()

        view.addSubview(weightView)
        weightView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(15)
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(view.safeAreaLayoutGuide)
        }
        title = "Weight"
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
        weightView.model = model.weightModel
    }
    
    func loadModel() {
        model.viewDidLoad()
        setup()
    }
}
