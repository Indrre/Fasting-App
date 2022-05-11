//
//  DailyDots.swift
//  Fasting App
//
//  Created by indre zibolyte on 14/04/2022.
//

import Foundation
import UIKit

class VisualDotsView: UIView {
    
    // =============================================
    // MARK: Properties
    // =============================================
    
    let dotSize: CGFloat = 20
    
    let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 6
        return view
    }()
    
    var lblCount: UILabel = {
        var label = UILabel()
        label.font =  UIFont(name: "Montserrat-Medium", size: 10)
        label.textColor = UIColor.white
        return label
    }()
    
    var quantity: Int = 0 {
        didSet {
            setupDots()
        }
    }
    
    var color: UIColor? {
        didSet {
            setupDots()
        }
    }
    
    // =============================================
    // MARK: Initialization
    // =============================================
    
    init() {
        super.init(frame: .zero)
        clipsToBounds = true
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // =============================================
    // MARK: Helpers
    // =============================================
    
    @objc func setupDots() {
        let screenWidth = UIScreen.main.bounds.width
        var number = Int(screenWidth / 28)

        number.negate()

        // Remove all the previous dots, if the stackview has any
        stackView.subviews.forEach({ $0.removeFromSuperview() })
        // Add the number of dots required
        var dotCount = number
        for i in 0..<quantity {
            let alpha: CGFloat = 0.1 * CGFloat(i+1)
            let dot = createDot()
            dot.alpha = alpha
            
            if stackView.subviews.count != abs(number) {
                stackView.addArrangedSubview(dot)
                dotCount += 1
            }
            if  stackView.subviews.count >= abs(number) {
                if dotCount == 0 {
                    lblCount.text = ""
                } else {
                    lblCount.text = "+ \(dotCount)"
                }
                stackView.addSubview(lblCount)
                lblCount.snp.makeConstraints {
                    $0.right.equalTo(dot.snp.right).inset(3)
                    $0.centerY.equalToSuperview()
                }
            }
        }
    }
    
    func createDot() -> UIView {
        let dot = UIView()
        dot.layer.cornerRadius = dotSize/2
        dot.backgroundColor = color ?? UIColor.waterColor
        dot.snp.makeConstraints {
            $0.size.equalTo(dotSize)
        }
        return dot
    }
}
