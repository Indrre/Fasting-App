//
//  WaterView.swift
//  Fasting App
//
//  Created by indre zibolyte on 26/03/2022.
//

import Foundation
import UIKit
import SnapKit
import Firebase

struct WaterModel {

    let waterData: [Water]
    var dotCount: Int
    var label: String
    let presentPicker: (() -> Void?)
    let graphModel: WaterBarModel
    var currentWater: Water
    var updateWater: ((Water) -> Void)
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
            dotCount: model.dotCount
        )
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

// ========================================
// MARK: UITableView
// ========================================

extension WaterMainView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.waterData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WaterCell", for: indexPath) as? WaterCell else { fatalError("unable to create cells") }
        cell.textLabel?.font = UIFont(name: "Montserrat-ExtraLight", size: 2)
        cell.selectionStyle = .none
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "E, d MMM"
    
        let currentModel = model.waterData[indexPath.row]
        cell.model = WaterViewCellViewModel(
            waterCount: currentModel.count ?? 0,
            dateString: dayTimePeriodFormatter.string(from: Date(timeIntervalSince1970: (currentModel.date ?? TimeInterval.today))),
            totalCount: "\((currentModel.count ?? 0) * 250)ml"
        )
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            
            let data = model.waterData[indexPath.row]
            let id = data.id
            guard let uid = Auth.auth().currentUser?.uid else { return }
            REFWATER.child(uid).child(id).removeValue { (error, _) in
                if error != nil {
                    debugPrint("DEBUG: Error while trying to delete water:  \(String(describing: error))")
                }
            }
            
            WaterService.data.removeAll(where: {$0.id == data.id})
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            tableView.reloadData()
            
            if model.currentWater.id == data.id {
                var water = model.currentWater
                water.count = 0
                model.updateWater(water)
            }
        }
    }
}
