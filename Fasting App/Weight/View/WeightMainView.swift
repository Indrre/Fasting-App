//
//  WeightMainView.swift
//  Fasting App
//
//  Created by indre zibolyte on 17/04/2022.
//

import Foundation
import UIKit
import Firebase

struct WeightModel {
    var weight: String
    var data: [Weight]
    var callBack: (() -> Void?)
    var dataSet: [Dataset]
    let loadGraph: (() -> Void?)
    var currentWeight: Weight
    var updateWeight: ((Weight) -> Void)
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
        addShadow()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // =============================================
    // MARK: Helpers
    // =============================================
    
    func configure() {
        addSubview(lblToday)
        lblToday.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(10)
            $0.left.equalToSuperview()
        }
        
        addSubview(lblWeight)
        lblWeight.snp.makeConstraints {
            $0.top.equalTo(lblToday.snp.bottom).offset(5)
        }
//        addSubview(lblBMI)
//        lblBMI.snp.makeConstraints {
//            $0.top.equalTo(lblWeight.snp.bottom).offset(10)
//            $0.left.equalTo(lblWeight.snp.left)
//        }
        
        addSubview(btnEdit)
        btnEdit.setTitle("Edit", for: .normal)
        btnEdit.snp.makeConstraints {
            $0.left.equalTo(lblWeight.snp.right).offset(10)
            $0.bottom.equalTo(lblWeight)
        }
        
        addSubview(weightIcon)
        weightIcon.snp.makeConstraints {
            $0.bottom.equalTo(lblWeight.snp.bottom).offset(-15)
            $0.right.equalToSuperview().offset(-5)
        }
    
        addSubview(graphView)
        graphView.snp.makeConstraints {
            $0.top.equalTo(lblWeight.snp.bottom).offset(20)
            $0.height.equalTo(147)
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

// =================================
// MARK: UITableView
// =================================

extension WeightMainView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeightCell", for: indexPath) as? WeightCell else { fatalError("unable to create cells") }
        cell.textLabel?.font = UIFont(name: "Montserrat-ExtraLight", size: 2)
        cell.selectionStyle = .none

        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "E, d MMM"
        
        let weight = WeightService.currentWeight
        
        let data = model?.data[indexPath.row]
        if weight.unit == "kg" {
            let calculations = Double(data?.count ?? 0) / Double(1000)
            
            let label = String(format: "%.1f", calculations)
            count = "\(label)kg"
        } else {
            
            var pounds = (Double(data?.count ?? 0) * 0.00220462)
            var numberOfStones = 0.0
            while pounds > 14 {
                pounds -= 14
               numberOfStones += 1
            }
            
            let numbetOfPounds = pounds.rounded()
            count = "\(Int(numberOfStones))st \(Int(numbetOfPounds))lb"
        }
        cell.model = WeightCellModel(
            date: dayTimePeriodFormatter.string(from: Date(timeIntervalSince1970: (data?.date ?? TimeInterval.today) + 1)),
            value: count ?? ""
        )
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            
            let data = model?.data[indexPath.row]
            guard let id = data?.id else { return }
            guard let uid = Auth.auth().currentUser?.uid else { return }
            REFWEIGHT.child(uid).child(id).removeValue { (error, _) in
                if error != nil {
                    debugPrint("DEBUG: Error while trying to delete water:  \(String(describing: error))")
                }
            }
            
            if var weight = model?.currentWeight {
                if weight.id == data?.id {
                    weight.count = 0
                    model?.updateWeight(weight)
                }
            }
            
            WeightService.data.removeAll(where: {$0.id == data?.id})
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            tableView.reloadData()
        }
    }
}
