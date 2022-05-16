//
//  WaterCell.swift
//  Fasting App
//
//  Created by indre zibolyte on 14/04/2022.
//

import Foundation
import UIKit

struct WaterViewCellViewModel {
    
    let waterCount: Int
    let dateString: String
    let totalCount: String
    
}

class WaterCell: UITableViewCell {
    
    // =============================================
    // MARK: Components
    // =============================================
    
    let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 10
        return view
    }()
    
    var lblDate: UILabel = {
        let view = UILabel()
        view.textColor = .stdText
        view.textAlignment = .left
        view.font = UIFont(name: "Montserrat-Light", size: 15)
        return view
    }()
    
    lazy var dotViewLine: VisualDotsView = {
        let view = VisualDotsView()
        return view
    }()
    
    var lblvalue: UILabel = {
        let view = UILabel()
        view.textColor = .stdText
        view.textAlignment = .left
        view.text = "1000ml"
        view.font = UIFont(name: "Montserrat-ExtraLight", size: 12)
        return view
    }()
    
    // =============================================
    // MARK: Properties
    // =============================================
    
    var model: WaterViewCellViewModel? {
        didSet {
            lblDate.text = model?.dateString
            dotViewLine.quantity = model?.waterCount ?? 0
            lblvalue.text = model?.totalCount
            
        }
    }
    
    // =============================================
    // MARK: Initialization
    // =============================================
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        stackView.addArrangedSubview(lblDate)
        let dotContainer = UIView()
        dotContainer.addSubview(dotViewLine)
        dotViewLine.snp.makeConstraints {
            $0.left.top.bottom.equalToSuperview()
        }
        stackView.addArrangedSubview(dotContainer)
        
        stackView.addArrangedSubview(lblvalue)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
