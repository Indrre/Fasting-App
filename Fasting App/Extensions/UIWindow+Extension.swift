//
//  UIWindow+Extension.swift
//  Fasting App
//
//  Created by indre zibolyte on 28/07/2022.
//

import Foundation
import UIKit

public extension UIWindow {
    
    /**
     * Variable to return the top most view controller presented on current UIWindow
     * @param none
     * @return: top view controller (UIViewcontroller)
     **/
    var topViewController: UIViewController? {
        var top = rootViewController
        while true {
            if let presented = top?.presentedViewController {
                top = presented
            } else if let nav = top as? UINavigationController {
                top = nav.visibleViewController
            } else if let tab = top as? UITabBarController {
                top = tab.selectedViewController
            } else {
                break
            }
        }
        return top
    }
    
}
