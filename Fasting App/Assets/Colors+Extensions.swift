//
//  Colors+Extensions.swift
//  Fasting App
//
//  Created by indre zibolyte on 23/01/2022.
//

import Foundation
import UIKit

extension UIColor {
    
    static let stdBackground: UIColor? = UIColor(named: "background")
    static let topBackground: UIColor? = UIColor(named: "gradient-top")
    static let bottomBackground: UIColor? = UIColor(named: "gradient-bottom")
    static let ringTrackColor: UIColor? = UIColor(named: "ring-track")
    static let ringColor: UIColor? = UIColor(named: "ring")
    static let timeColor: UIColor? = UIColor(named: "time-color")
    static let stdText: UIColor? = UIColor(named: "text")
    static let timeCircles: UIColor? = UIColor(named: "time-circles")
    static let blackWhiteBackground: UIColor? = UIColor(named: "black-white-background")
    static let infoLineColor: UIColor? = UIColor(named: "info-line-color")
    static let homeIndicatorColor: UIColor? = UIColor(named: "gradient-bottom")
    static let ringBackground: UIColor? = UIColor(named: "ring-background")
    static let loginBackground2: UIColor? = UIColor(named: "login-background")
    
    static let topBackground2: UIColor? = UIColor(named: "gradient-top-1")
    static let bottomBackground2: UIColor? = UIColor(named: "gradient-bottom-1")
    
    static let loginBackground = UIColor(red: 0.161, green: 0.161, blue: 0.161, alpha: 1)
    static let waterColor = UIColor(red: 0.427, green: 0.643, blue: 0.839, alpha: 1)
    static let waterColorLight = UIColor(red: 0.427, green: 0.643, blue: 0.839, alpha: 0.5)
    static let waterControlDark = UIColor(red: 0.192, green: 0.192, blue: 0.192, alpha: 1)
    static let fastBarColor = UIColor(red: 0.245, green: 0.149, blue: 0.145, alpha: 1)
    static let fastSelectedColor = UIColor(red: 0.821, green: 0.821, blue: 0.821, alpha: 1)
    static let fastedBarColor = UIColor(red: 0.961, green: 0.584, blue: 0.569, alpha: 1)
    static let lineColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
    static let waterIconColor = UIColor(red: 0.063, green: 0.063, blue: 0.063, alpha: 0.5)
    static let fastColor = UIColor(red: 0.271, green: 0.675, blue: 0.745, alpha: 1)
    static let calorieColor = UIColor(red: 0.957, green: 0.494, blue: 0.325, alpha: 1)
    static let lightCalorieColor = UIColor(red: 0.957, green: 0.494, blue: 0.325, alpha: 0.5)
    static let weightColor =  UIColor(red: 0.957, green: 0.742, blue: 0.325, alpha: 1)
}

extension UIColor {
    static var myControlBackground: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { (traits) -> UIColor in
                // Return one of two colors depending on light or dark mode
                return traits.userInterfaceStyle == .dark ?
                UIColor(red: 0.255, green: 0.255, blue: 0.255, alpha: 0.766) :
                    UIColor(red: 0.804, green: 0.804, blue: 0.804, alpha: 1)
            }
        } else {
            // Same old color used for iOS 12 and earlier
            return UIColor(red: 0.804, green: 0.804, blue: 0.804, alpha: 1)
        }
    }
}
