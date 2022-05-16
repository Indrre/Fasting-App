//
//  WeightCell.swift
//  Fasting App
//
//  Created by indre zibolyte on 09/05/2022.
//

import Foundation
import UIKit

struct WeightCellModel {
    let date: String
    let value: String
}

class WeightCell: UITableViewCell {
    
    // =============================================
    // MARK: Components
    // =============================================
    
    var lblDate: UILabel = {
        let view = UILabel()
        view.textColor = .stdText
        view.textAlignment = .right
        view.font = UIFont(name: "Montserrat-normal", size: 14)
        return view
    }()
    
    let lblValue: UILabel = {
        let view = UILabel()
        view.textColor = .stdText
        view.textAlignment = .right
        view.font = UIFont(name: "Montserrat-normal", size: 14)
        return view
    }()
    
    // =============================================
    // MARK: Properties
    // =============================================
    
    var model: WeightCellModel? {
        didSet {
            lblDate.text = model?.date
            lblValue.text = model?.value
        }
    }
    
    // =============================================
    // MARK: Initialization
    // =============================================
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear

        addSubview(lblDate)
        lblDate.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(15)
        }
        addSubview(lblValue)
        lblValue.snp.makeConstraints {
            $0.bottom.equalTo(lblDate)
            $0.right.equalToSuperview().inset(15)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
