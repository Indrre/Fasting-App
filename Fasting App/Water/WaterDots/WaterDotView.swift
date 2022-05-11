//
//  WaterDotView.swift
//  Fasting App
//
//  Created by indre zibolyte on 27/03/2022.
//

import Foundation
import UIKit

struct WaterDotModel {
    var milliliters: String
    let presentPicker: (() -> Void)?
    var dotCount: Int

}

class WaterDotView: UIView {

    // =============================================
    // MARK: Properties
    // =============================================
    
    var currentCount: Int {
        return WaterService.currentWater.count ?? 0
    }
    
    let lblToday: UILabel = {
        var label = UILabel()
        label.font =  UIFont(name: "Montserrat-Light", size: 14)
        label.text = "Today"
        label.textColor = UIColor.stdText
        return label
    }()
    
    let dotView = DotView()
    
    let btnEdit: UIButton = {
        var editButton = UIButton()
        editButton.titleLabel?.font = UIFont(name: "Montserrat-Light", size: 17)
        editButton.setTitleColor(.stdText, for: .normal)
        editButton.setTitle("Edit Water", for: .normal)
        editButton.addTarget(self, action: #selector(editButtonPressed), for: .touchUpInside)
        return editButton
    }()

    lazy var waterIcon: UIImageView = {
        let view = UIImageView()
        view.tintColor = .stdText
        view.image = UIImage(named: "water-large-icon")?.withRenderingMode(.alwaysTemplate)
        return view
    }()
    
    var lblvalue: UILabel = {
        let view = UILabel()
        view.textColor = .stdText
        view.textAlignment = .left
        view.text = "empty"
        view.font = UIFont(name: "Montserrat-ExtraLight", size: 15)
        return view
    }()
    
    var model: WaterDotModel? {
        didSet {
            lblvalue.text = model?.milliliters
            dotView.quantity = model?.dotCount ?? 0
        }
    }
    
    // =============================================
    // MARK: Initialization
    // =============================================
    
    init() {
        super.init(frame: .zero)
        
        addSubview(lblToday)
        lblToday.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.height.equalTo(20)
            $0.left.equalToSuperview()
        }
        
        addSubview(waterIcon)
        waterIcon.snp.makeConstraints {
            $0.bottom.equalTo(lblToday.snp.bottom)
            $0.right.equalToSuperview()
        }
        
        addSubview(dotView)
        dotView.snp.makeConstraints {
            $0.top.equalTo(lblToday.snp.bottom).offset(20)
            $0.left.equalToSuperview()
        }
        
        addSubview(btnEdit)
        btnEdit.snp.makeConstraints {
            $0.top.equalTo(dotView.snp.bottom)
            $0.right.equalToSuperview()
            $0.width.equalTo(100)
            $0.height.equalTo(130)
            $0.bottom.equalToSuperview()
        }
        
        addSubview(lblvalue)
        lblvalue.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.centerY.equalTo(btnEdit.snp.centerY)
        }
        updateDotCount()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // =============================================
    // MARK: Helpers
    // =============================================
    
    @objc func updateDotCount() {
        dotView.quantity = currentCount
    }
    
    @objc func editButtonPressed() {
        model?.presentPicker?()
    }
}
