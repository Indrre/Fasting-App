//
//  HomeTileView.swift
//  Fasting App
//
//  Created by indre zibolyte on 22/02/2022.
//

import Foundation
import UIKit

struct HomeTileViewModel {
    
    let icon: String
    let title: String
    let color: UIColor
    let value: String
    let action: (() -> Void)
    
}

class HomeTileView: TouchableView {
    
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
    
    lazy var containerStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .leading
        view.spacing = 8
        view.addArrangedSubview(imgIcon)
        view.addArrangedSubview(lblTitle)
        view.addArrangedSubview(valueStackView)
        return view
    }()
    
    let imgIcon: UIImageView = {
        let view = UIImageView()
        view.tintColor = .bottomBackground
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let lblTitle: UILabel = {
        var label = UILabel()
        label.font =  UIFont(name: "Montserrat-ExtraLight", size: 13)
        label.textColor = .stdText
        return label
    }()
    
    lazy var valueStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.spacing = 8
        view.addArrangedSubview(dotView)
        view.addArrangedSubview(lblValue)
        return view
    }()
    
    let dotView = UIView()
    
    let lblValue: UILabel = {
        let label = UILabel()
        label.font =  UIFont(name: "Montserrat-ExtraLight", size: 13)
        label.textColor = .stdText
        return label
    }()
    
    // =============================================
    // MARK: Properties
    // =============================================
    
    var model: HomeTileViewModel? {
        didSet {
            guard let model = model else { return }
            
            callback = model.action
            imgIcon.image = UIImage(named: model.icon)?.withRenderingMode(.alwaysTemplate)
            imgIcon.tintColor = UIColor.stdText?.withAlphaComponent(0.5)
            lblTitle.text = model.title
            dotView.backgroundColor = model.color
            lblValue.text = model.value
        }
    }
    
    var value: String? {
        didSet {
            lblValue.text = value
        }
    }
    
    // =============================================
    // MARK: Initialization
    // =============================================
    
    init() {
        super.init(frame: .zero)
        clipsToBounds = false
        
        addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        containerView.addSubview(circleContainerView)
        circleContainerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        circleContainerView.addSubview(circles)
        circles.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.left.equalToSuperview().inset(50)
        }
        
        containerView.addSubview(containerStackView)
        containerStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(15)
        }
        
        imgIcon.snp.makeConstraints {
            $0.size.equalTo(30)
        }
        
        dotView.snp.makeConstraints {
            $0.size.equalTo(8)
        }
        dotView.layer.cornerRadius = 4
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
