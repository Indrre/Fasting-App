//
//  ContainerView.swift
//  Fasting App
//
//  Created by indre zibolyte on 23/01/2022.
//

import Foundation
import UIKit

class ContainerView: UIView {
    
    //=============================================
    // MARK: - Properties
    //=============================================
    
    lazy var title: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 40)
        view.text = "FastLog"
        view.textAlignment = .center
        view.textColor = .lightGray
        return view
    }()
    
    var launchIcon: UIImageView = {
        let view = UIImageView()
        
        view.image = UIImage(systemName: "water-icon")
        return view
    }()
    

    

    
    //=============================================
    // MARK: - Initialization
    //=============================================
    
    init() {
        super.init(frame: .zero)
            
        addSubview(title)
        title.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(50)
            $0.centerX.equalToSuperview()
        }
            
        addSubview(launchIcon)
        launchIcon.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(50)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(200)
        }
        
  
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //=============================================
    // MARK: - Helpers
    //=============================================
    

    
}



