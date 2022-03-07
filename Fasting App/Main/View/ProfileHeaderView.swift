//
//  ProfileHeaderView.swift
//  Fasting App
//
//  Created by indre zibolyte on 29/01/2022.
//

import Foundation
import UIKit
import FirebaseAuth

struct ProfileHeaderModel {
    let name: String?
    let profilePic: UIImage?
    let action: (() -> Void)?
}

class ProfileHeaderView: TouchableView {
    
    // =============================================
    // MARK: Properties
    // =============================================
    
    let imageSize: CGFloat = 60
    
    let lblName: UILabel = {
        let view = UILabel()
        view.textColor = .stdText
        return view
    }()
    
    let lblGreeting: UILabel = {
        let view = UILabel()
        view.textColor = .stdText
        return view
    }()
    
    lazy var navArrow: UIImageView = {
        let view = UIImageView()
        view.tintColor = .stdText
        view.image = UIImage(named: "navigation-arrow")?.withRenderingMode(.alwaysTemplate)
        view.clipsToBounds = true
        return view
    }()
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "profile-pic")
        view.clipsToBounds = true
        return view
    }()
    
    var model: ProfileHeaderModel {
        didSet {
            lblName.text = model.name
            imageView.image = model.profilePic
        }
    }
    
    @objc func labelTapped() {
        print("DEBUG: TAP TAP TAP!!!")
        model.action?()
    }
    
    func setupLabelTap() {
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(labelTap)
    }
    
    // =================================
    // MARK: Callbacks
    // =================================
    
    var action: (() -> Void)?
    var presentController: ((UIViewController) -> Void)?
    
    // ========================================
    // MARK: Initialization
    // ========================================
    
    init(model: ProfileHeaderModel) {
        self.model = model
        super.init(frame: .zero)
        backgroundColor = .clear
        
        setupGreeting()
        
        backgroundColor = .clear
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        addGestureRecognizer(tap)
        
        addSubview(lblGreeting)
        lblGreeting.font =  UIFont(name: "Montserrat-ExtraLight", size: 22)
        lblGreeting.snp.makeConstraints {
            $0.top.left.equalToSuperview().inset(10)
        }
        
        addSubview(lblName)
        lblName.font =  UIFont(name: "Montserrat-ExtraLight", size: 30)
        lblName.snp.makeConstraints {
            $0.top.equalTo(lblGreeting.snp.bottom).offset(10)
            $0.left.equalTo(lblGreeting)
            $0.bottom.equalToSuperview()
        }
        
        addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.centerY.right.equalToSuperview().inset(45)
            $0.size.equalTo(imageSize)
        }
        
        addSubview(navArrow)
        navArrow.snp.makeConstraints {
            $0.centerY.right.equalToSuperview().inset(20)
        }
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.cornerRadius = imageView.frame.size.height/2
    }
    
    // =============================================
    // MARK: Helpers
    // =============================================
    
    func setupGreeting() {
        let hour = Calendar.current.component(.hour, from: Date())
        var timeOfTheDay: String = ""
        
        switch hour {
            case 0..<12 : timeOfTheDay = "Good Morning,"
            case 12..<18 : timeOfTheDay = "Good Afternoon,"
            case 18..<24 : timeOfTheDay = "Good Evening,"
            default: debugPrint("DEBUG: Hi")
        }
        lblGreeting.text = timeOfTheDay
    }
}
