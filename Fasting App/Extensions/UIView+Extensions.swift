//
//  UIView+Extensions.swift
//  Fasting App
//
//  Created by indre zibolyte on 25/03/2022.
//

import Foundation
import UIKit

extension UIView {
    
    func addShadow(color: UIColor? = UIColor.black.withAlphaComponent(0.3)) {
        layer.shadowColor = color?.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = .zero
        layer.shadowRadius = 15
    }
    
    func addShadow() {
        layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = .zero
        layer.shadowRadius = 20
    }
    
    func setBackgroundGradient(topColor: UIColor, bottomColor: UIColor) {
        let layer0 = CAGradientLayer()
        layer0.colors = [
          topColor.cgColor,
          bottomColor.withAlphaComponent(0).cgColor,
          topColor.cgColor
        ]
        layer0.locations = [0, 1]
        layer0.startPoint = CGPoint(x: 0.15, y: 0.5)
        layer0.endPoint = CGPoint(x: 0.95, y: 0.5)
        layer0.transform = CATransform3DMakeAffineTransform(
            CGAffineTransform(
                a: 0,
                b: 0.72,
                c: -0.72,
                d: 0,
                tx: 1.86,
                ty: 0)
        )
        layer0.bounds = bounds.insetBy(
            dx: -0.5*frame.size.width,
            dy: -0.5*bounds.size.height
        )
        layer0.position = center
        layer.addSublayer(layer0)
    }
    
    /**
     Fade in `UIView` - with default setup
     - Parameter time: TimeInterval = 0.3
     - Parameter alpha: CGFloat = 1
     - Parameter completion: (() -> Void)? = nil
     */
    func fadeIn(time: TimeInterval = 0.4, alpha: CGFloat = 1, completion: (() -> Void)? = nil) {
        UIView.animate(
            withDuration: time,
            animations: {
                self.alpha = alpha
        }, completion: { _ in
            completion?()
        })
    }
    
    /**
     Fade out `UIView` - with default setup
     - Parameter time: TimeInterval = 0.3
     - Parameter alpha: CGFloat = 1
     - Parameter completion: (() -> Void)? = nil
     */
    func fadeOut(time: TimeInterval = 0.4, alpha: CGFloat = 0, completion: (() -> Void)? = nil) {
        UIView.animate(
            withDuration: time,
            animations: {
                self.alpha = alpha
        }, completion: { _ in
            completion?()
        })
    }
}
