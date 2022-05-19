//
//  WeightMainView.swift
//  Fasting App
//
//  Created by indre zibolyte on 17/04/2022.
//

import Foundation
import UIKit

struct WeightModel {
    var weight: String
    var data: [Weight]
    var callBack: (() -> Void?)
    let loadGraph: (() -> Void?)
    var dataSet: [Dataset]
}

class WeightMainView: UIView {
    
    // ========================================
    // MARK: Properties
    // ========================================
    
    var count: String?
    var currentWeight: String?

    var lblToday: UILabel = {
        var label = UILabel()
        label.font =  UIFont(name: "Montserrat-ExtraLight", size: 17)
        label.text = "Today"
        label.textColor = UIColor.stdText
        label.textAlignment = .left
        return label
    }()
    
    let lblWeight: UILabel = {
        var label = UILabel()
        label.font =  UIFont(name: "Montserrat-SemiBold", size: 30)
        label.textColor = UIColor.stdText
        return label
    }()
    
    lazy var weightIcon: UIImageView = {
        let view = UIImageView()
        view.tintColor = UIColor.stdText
        view.image = UIImage(named: "weight-icon-large")?.withRenderingMode(.alwaysTemplate)
        
        return view
    }()
    
    let lblBMI: UILabel = {
        var label = UILabel()
        label.font =  UIFont(name: "Montserrat-SemiBold", size: 20)
        label.textColor = UIColor.stdText
        label.text = "BMI"
        return label
    }()
    
    lazy var btnEdit: UIButton = {
        var editButton = UIButton()
        editButton.titleLabel?.font = UIFont(name: "Montserrat-Light", size: 14)
        editButton.setTitleColor(.stdText, for: .normal)
        editButton.addTarget(self, action: #selector(editButtonPressed), for: .touchUpInside)
        return editButton
    }()
    
    lazy var graphView: LineChart = {
        let view = LineChart()
        view.backgroundColor = .blackWhiteBackground
        view.isCurved = true
        view.layer.cornerRadius = 20
        view.lineColor = .weightColor
        view.isTouchable = true
        view.clipsToBounds = true
        view.touchColor = UIColor.timeColor
        view.callback = { [ weak self ] set in
            guard let set = set else { return }
            self?.setDataset(set: set)
        }
        view.setupView()
        view.addShadow()
        return view
    }()
    
    var lblResults: UILabel = {
        var label = UILabel()
        label.font =  UIFont(name: "Montserrat-ExtraLight", size: 12)
        label.text = "weight"
        label.textColor = UIColor.stdText
        return label
    }()
    
    var lblWeightLog: UILabel = {
        var label = UILabel()
        label.font =  UIFont(name: "Montserrat-ExtraLight", size: 15)
        label.text = "Weight Log"
        label.textColor = UIColor.stdText
        return label
    }()
    
    var tableView: UITableView = {
        let view = UITableView()
        view.register(WeightCell.self, forCellReuseIdentifier: "WeightCell")
        return view
    }()
    
    var model: WeightModel? {
        didSet {
            lblWeight.text = model?.weight
//            lblResults.text = model?.result
            graphView.dataSet = model?.dataSet
            tableView.reloadData()
        }
    }
    
    // ========================================
    // MARK: Initializer
    // ========================================
    
    init(model: WeightModel) {
        self.model = model
        super.init(frame: .zero)
        
        model.loadGraph()
        
        addSubview(lblToday)
        lblToday.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(10)
            $0.left.equalToSuperview()
        }
        
        addSubview(lblWeight)
        lblWeight.snp.makeConstraints {
            $0.top.equalTo(lblToday.snp.bottom).offset(5)
        }
        addSubview(lblBMI)
        lblBMI.snp.makeConstraints {
            $0.top.equalTo(lblWeight.snp.bottom).offset(10)
            $0.left.equalTo(lblWeight.snp.left)
        }
        
        addSubview(btnEdit)
        btnEdit.setTitle("Edit", for: .normal)
        btnEdit.snp.makeConstraints {
            $0.left.equalTo(lblWeight.snp.right).offset(10)
            $0.bottom.equalTo(lblWeight)
        }
        
        addSubview(weightIcon)
        weightIcon.snp.makeConstraints {
            $0.bottom.equalTo(lblWeight).offset(5)
            $0.right.equalToSuperview()
        }
    
        addSubview(graphView)
        graphView.snp.makeConstraints {
            $0.top.equalTo(lblBMI.snp.bottom).offset(10)
            $0.height.equalTo(170)
            $0.width.equalToSuperview()
        }
        
        addSubview(lblResults)
        lblResults.snp.makeConstraints {
            $0.top.equalTo(graphView.snp.bottom).inset(25)
            $0.right.equalTo(graphView).inset(15)
        }
        
        addSubview(lblWeightLog)
        lblWeightLog.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.top.equalTo(lblResults.snp.bottom).offset(30)
        }
        
        addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(lblWeightLog.snp.bottom).offset(30)
            $0.width.centerX.bottom.equalToSuperview()
        }
        
        tableView.rowHeight = 50
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // =============================================
    // MARK: Helpers
    // =============================================
    
    @objc func editButtonPressed() {
        model?.callBack()
    }
    
    func setDataset(set: Dataset) { // set graph result label
        
        let string = displayFor(value: set)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM"
        lblResults.text = String(dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(set.timestamp))) +  " "  + string )
    }
        
    func displayFor(value: Dataset) -> String {
        let weight = WeightService.currentWeight
        let weightUnit = weight.unit
        let userWeight = value.value
        if weightUnit == "kg" {
            let calculations = Double(userWeight) / Double(1000)
            
            let label = String(format: "%.1f", calculations)
            currentWeight = "\(label)kg"
        } else {
            
            var pounds = (Double(userWeight) * 0.00220462)
            var numberOfStones = 0.0
            while pounds > 14 {
                pounds -= 14
               numberOfStones += 1
            }
            
            let numbetOfPounds = pounds.rounded()
            currentWeight = "\(Int(numberOfStones))st \(Int(numbetOfPounds))lb"
        }
        return currentWeight ?? ""
    }
}
