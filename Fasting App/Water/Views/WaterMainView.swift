//
//  WaterView.swift
//  Fasting App
//
//  Created by indre zibolyte on 26/03/2022.
//

import Foundation
import UIKit
import SnapKit

struct WaterModel {
    
    var dotCount: Int
    var label: String
    let presentPicker: (() -> Void?)
    let graphModel: WaterBarModel
    var refreshController: (() -> Void)?
    var tableView: UITableView?
}

class WaterMainView: UIView {
    
    // ========================================
    // MARK: Properties
    // ========================================
    
    lazy var dotView: WaterDotView = {
        let view = WaterDotView()
        view.model = WaterDotModel(
            milliliters: "water consumed",
            presentPicker: { [ weak self ] in
                self?.presentWaterPicker()
            },
            dotCount: model.dotCount)
        return view
    }()
    
    lazy var graphView: WaterGraphView = {
        let view = WaterGraphView()
        return view
    }()
    
    var lblWaterLog: UILabel = {
        var label = UILabel()
        label.font =  UIFont(name: "Montserrat-ExtraLight", size: 15)
        label.text = "Water Log"
        label.textColor = UIColor.stdText
        return label
    }()
    
    var tableView: UITableView = {
        let view = UITableView()
        view.register(WaterCell.self, forCellReuseIdentifier: "WaterCell")
        return view
    }()
    
    var model: WaterModel {
        didSet {
            dotView.model?.dotCount = model.dotCount
            dotView.lblvalue.text = model.label
            graphView.barView.model = model.graphModel
            tableView.reloadData()
        }
    }
    
    // ========================================
    // MARK: Initializer
    // ========================================
    
    init(model: WaterModel) {
        self.model = model
        super.init(frame: .zero)
            
        addSubview(dotView)
        dotView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(10)
            $0.right.left.equalToSuperview()
            $0.height.equalTo(100)
        }
        
        addSubview(graphView)
        graphView.snp.makeConstraints {
            $0.top.equalTo(dotView.snp.bottom).offset(10)
            $0.right.left.equalToSuperview()
            $0.height.equalTo(147)
        }
        
        addSubview(lblWaterLog)
        lblWaterLog.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.top.equalTo(graphView.snp.bottom).offset(30)
        }
        
        addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(lblWaterLog.snp.bottom).offset(30)
            $0.width.centerX.bottom.equalToSuperview()
        }
        tableView.rowHeight = 100
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    
  }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // ========================================
    // MARK: Helpers
    // ========================================
        
    func presentWaterPicker() {
        model.presentPicker()
    }
}
