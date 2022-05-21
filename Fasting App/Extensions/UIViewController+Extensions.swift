//
//  UIViewController+Extensions.swift
//  Fasting App
//
//  Created by indre zibolyte on 25/03/2022.
//

import Foundation
import UIKit
import SDWebImage

extension UIViewController {
    
    func setLargeTitleDisplayMode(_ largeTitleDisplayMode: UINavigationItem.LargeTitleDisplayMode) {
        switch largeTitleDisplayMode {
        case .automatic:
            guard let navigationController = navigationController else { break }
            if let index = navigationController.children.firstIndex(of: self) {
                setLargeTitleDisplayMode(index == 0 ? .always : .never)
            } else {
                setLargeTitleDisplayMode(.always)
            }
        case .always:
            navigationItem.largeTitleDisplayMode = largeTitleDisplayMode
            // Even when .never, needs to be true otherwise animation will be broken on iOS11, 12, 13
            navigationController?.navigationBar.prefersLargeTitles = true
        case .never:
            navigationController?.navigationBar.prefersLargeTitles = false
        @unknown default:
            assertionFailure("\(#function): Missing handler for \(largeTitleDisplayMode)")
        }
    }
    
}
