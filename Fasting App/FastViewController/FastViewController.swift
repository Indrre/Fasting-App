//
//  FastViewController.swift
//  Fasting App
//
//  Created by indre zibolyte on 11/03/2022.
//

import Foundation
import UIKit

class FastViewController: UIViewController {
    
    // =============================================
    // MARK: Properties
    // =============================================
    
    lazy var fastView: FastView = {
        return FastView(model: model.fastModel)
    }()
    
    lazy var model: FastViewModel = {
        let model = FastViewModel()
        model.refreshController = { [ weak self ] in
            self?.setup()
        }
        return model
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.viewDidLoad()
        title = "Fast"
   
        view.addSubview(fastView)
        fastView.snp.makeConstraints {
            $0.edges.equalToSuperview()
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
        fastView.model = model.fastModel
    }
}
