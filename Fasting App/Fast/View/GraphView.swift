//
//  GraphView.swift
//  Fasting App
//
//  Created by indre zibolyte on 15/03/2022.
//

import Foundation
import UIKit

class GraphView: TouchableView {
    
    // =============================================
    // MARK: Components
    // =============================================
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .stdBackground
        view.layer.cornerRadius = 20
        view.addShadow()
        return view
    }()
    
    let circleContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .stdBackground
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()
    
    let circles = BackgroundCircles()

    lazy var title: UILabel = {
        let view = UILabel()
        view.font =  UIFont(name: "Montserrat-ExtraLight", size: 17)
        view.text = "Fast"
        view.textAlignment = .center
        view.textColor = UIColor.stdText
        return view
    }()
    
    lazy var navArrow: UIImageView = {
        let view = UIImageView()
        view.tintColor = .stdText
        view.image = UIImage(named: "navigation-arrow")?.withRenderingMode(.alwaysTemplate)
        view.clipsToBounds = true
        return view
    }()
        
    lazy var barView: TimeBarView = {
        let view = TimeBarView()
        return view
    }()
    
    // =============================================
    // MARK: Initialization
    // =============================================
    
    init() {
        super.init(frame: .zero)
        clipsToBounds = false
        
        addShadow()
        
        addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(170)
        }
        
        containerView.addSubview(circleContainerView)
        circleContainerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        circleContainerView.addSubview(circles)
        circles.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(130)
            $0.right.equalToSuperview().inset(170)
        }
        
        containerView.addSubview(title)
        title.snp.makeConstraints {
            $0.top.right.equalToSuperview().inset(15)
        }
        
        containerView.addSubview(barView)
        barView.snp.makeConstraints {
            $0.width.equalTo(200)
            $0.top.left.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
