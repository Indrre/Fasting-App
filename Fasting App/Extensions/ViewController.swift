//
//  ViewController.swift
//  Fasting App
//
//  Created by indre zibolyte on 12/05/2022.
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
            let mainColor = UIColor.topBackground2,
            let topColor = UIColor.bottomBackground2  else { return }

        layer.frame = view.bounds
        layer.colors =  [mainColor.cgColor, topColor.cgColor]// [UIColor.red.cgColor, UIColor.blue.cgColor]
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 1)
        view.layer.insertSublayer(layer, at: 0)
        
//        let layer = CAGradientLayer()
//        layer.frame = view.bounds
//        layer.colors = [UIColor.red.cgColor, UIColor.blue.cgColor]
//        layer.startPoint = CGPoint(x: 0, y: 0)
//        layer.endPoint = CGPoint(x: 1, y: 1)
//        view.layer.insertSublayer(layer, at: 0)
    }

}
