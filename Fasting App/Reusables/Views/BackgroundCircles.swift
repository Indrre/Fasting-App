//
//  BackgroundCircles.swift
//  Fasting App
//
//  Created by indre zibolyte on 22/02/2022.
//

import Foundation
import UIKit

class BackgroundCircles: UIView {
    
    // =============================================
    // MARK: Properties
    // =============================================
    
    let circleSize: CGFloat = 146
    
    let backgroundCircleOne: UIView = {
        let view = UIView()
        view.backgroundColor = .timeCircles
        return view
    }()
    
    let backgroundCircleTwo: UIView = {
        let view = UIView()
        view.backgroundColor = .timeCircles
        return view
    }()
    
    let backgroundCircleThree: UIView = {
        let view = UIView()
        view.backgroundColor = .timeCircles
        return view
    }()
    
    // =============================================
    // MARK: Initialization
    // =============================================
    
    init() {
        super.init(frame: .zero)
        
        addSubview(backgroundCircleOne)
        backgroundCircleOne.snp.makeConstraints {
            $0.size.equalTo(circleSize)
            $0.left.equalToSuperview().inset(-30)
            $0.top.equalToSuperview().inset(30)
        }
        
        addSubview(backgroundCircleTwo)
        backgroundCircleTwo.snp.makeConstraints {
            $0.size.equalTo(circleSize)
            $0.left.equalToSuperview().inset(5)
            $0.top.equalToSuperview().inset(40)
        }
        
        addSubview(backgroundCircleThree)
        backgroundCircleThree.snp.makeConstraints {
            $0.size.equalTo(circleSize)
            $0.left.equalToSuperview().inset(60)
            $0.top.equalToSuperview().inset(10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // =============================================
    // MARK: Helpers
    // =============================================
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundCircleOne.layer.cornerRadius = circleSize/2
        backgroundCircleTwo.layer.cornerRadius = circleSize/2
        backgroundCircleThree.layer.cornerRadius = circleSize/2
    }
}
