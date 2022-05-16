//
//  ViewCell.swift
//  Fasting App
//
//  Created by indre zibolyte on 20/03/2022.
//

import Foundation
import UIKit

struct ViewCellModel {
    let date: String
    let hours: String
}

class ViewCell: UITableViewCell {
    
    var lblDate: UILabel = {
        let view = UILabel()
        view.textColor = .stdText
        view.textAlignment = .right
        view.font = UIFont(name: "Montserrat-normal", size: 14)
        return view
    }()
    
    var lblValue: UILabel = {
        let view = UILabel()
        view.textColor = .stdText
        view.textAlignment = .right
        view.font = UIFont(name: "Montserrat-normal", size: 14)
        return view
    }()
    
    var model: ViewCellModel? {
        didSet {
            lblDate.text = model?.date
            lblValue.text = model?.hours
        }
    }
   
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
