//
//  ViewController.swift
//  Fasting App
//
//  Created by indre zibolyte on 31/01/2022.
//

import Foundation
import UIKit

class ViewController: UIViewController {
    
    // =======================================
    // MARK: Properties
    // =======================================
    
    let layer = CAGradientLayer()
    
    // =======================================
    // MARK: Lifecycle
    // =======================================
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setBackground()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setBackground()
    }
    
    // =======================================
    // MARK: Helpers
    // =======================================
    
    func setBackground() {
        guard
            let mainColor = UIColor.stdBackground,
            let topColor = UIColor.topBackground else { return }
        
        layer.frame = view.bounds
        layer.colors = [mainColor.cgColor, topColor.cgColor]
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 1)
        view.layer.insertSublayer(layer, at: 0)
    }
}
