//
//  CAShapeLayer+Extensions.swift
//  Fasting App
//
//  Created by indre zibolyte on 25/03/2022.
//

import Foundation
import UIKit

extension CAShapeLayer {

    class func create(
        arcCenter: CGPoint,
        strokeColor: UIColor,
        fillColor: UIColor,
        radius: CGFloat) -> CAShapeLayer {
        let circularPath = UIBezierPath(
            arcCenter: arcCenter,
            radius: radius,
            startAngle: -(.pi / 2),
            endAngle: 1.5 * .pi,
            clockwise: true
        )
        
        let layer = CAShapeLayer()
        layer.path = circularPath.cgPath
        layer.strokeColor = strokeColor.cgColor
        layer.lineWidth = 20
        layer.fillColor = fillColor.cgColor
        layer.lineCap = .round
//        layer.shadowOpacity = 0.2
//        layer.shadowOffset = CGSize(width: 0.0, height: 0.1)
        
        return layer
    }
    
}
