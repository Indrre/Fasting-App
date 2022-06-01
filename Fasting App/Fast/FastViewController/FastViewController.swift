//
//  FastViewController.swift
//  Fasting App
//
//  Created by indre zibolyte on 11/03/2022.
//

import Foundation
import UIKit
import Firebase

class FastViewController: ViewController {
    
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
    
    // ========================================
    // MARK: Initialization
    // ========================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model.viewDidLoad()
        setup()
        
        title = "Fast"
        view.backgroundColor = .stdBackground
        
        view.addSubview(fastView)
        fastView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(15)
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(view.safeAreaLayoutGuide)
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
