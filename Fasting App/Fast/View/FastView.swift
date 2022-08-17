//
//  FastView.swift
//  Fasting App
//
//  Created by indre zibolyte on 11/03/2022.
//

import Foundation
import UIKit
import SnapKit
import Firebase

struct FastModel {
    
    let graphModel: FastBarModel
    let timerLapsed: TimeInterval?
    let hours: String?
    let currentFast: Fast?
    let fastData: [Fast]
    let updateFast: ((Fast) -> Void)
}

class FastView: UIView {
    
    // ========================================
    // MARK: Properties
    // ========================================
    
    var timerLapsed: TimeInterval?
    var hours: String?
    
    lazy var horizontalTimerView: HorizontalTimerView = {
        let view = HorizontalTimerView()
        return view
    }()
    
    let lblThisWeek: UILabel = {
        var label = UILabel()
        label.font =  UIFont(name: "Montserrat-Light", size: 14)
        label.textColor = .stdText
        label.text = "This week"
        return label
    }()
    
    lazy var weeklyGraphView: TimeGraphView = {
        let view = TimeGraphView()
        return view
    }()
    
    var lblTimeLog: UILabel = {
        var label = UILabel()
        label.font =  UIFont(name: "Montserrat-ExtraLight", size: 14)
        label.text = "Time Log"
        label.textColor = UIColor.stdText
        return label
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.register(ViewCell.self, forCellReuseIdentifier: "FastViewCell")
        return view
    }()
    
    var model: FastModel {
        didSet {
            horizontalTimerView.timerLapsed = model.timerLapsed
            horizontalTimerView.lblHours.text = model.hours
            weeklyGraphView.barView.model = model.graphModel
            tableView.reloadData()
        }
    }
    
    // ========================================
    // MARK: Initialization
    // ========================================
    
    init(model: FastModel) {
        self.model = model
        super.init(frame: .zero)
        
        addSubview(horizontalTimerView)
        horizontalTimerView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.right.left.equalToSuperview()
            $0.height.equalTo(100)
        }
        
        addSubview(lblThisWeek)
        lblThisWeek.snp.makeConstraints {
            $0.top.equalTo(horizontalTimerView.snp.bottom)
            $0.left.equalToSuperview()
            $0.height.equalTo(20)
        }
        
        addSubview(weeklyGraphView)
        weeklyGraphView.snp.makeConstraints {
            $0.top.equalTo(lblThisWeek.snp.bottom).offset(10)
            $0.right.left.equalToSuperview()
            $0.height.equalTo(147)
        }
        
        addSubview(lblTimeLog)
        lblTimeLog.snp.makeConstraints {
            $0.top.equalTo(weeklyGraphView.snp.bottom).offset(30)
            $0.left.equalToSuperview()
        }
        
        addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(lblTimeLog.snp.bottom).offset(30)
            $0.width.centerX.bottom.equalToSuperview()
        }
        
        tableView.rowHeight = 60
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// =================================
// MARK: UITableView
// =================================

extension FastView: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.fastData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FastViewCell", for: indexPath) as? ViewCell else { fatalError("unable to create cells") }
        cell.textLabel?.font = UIFont(name: "Montserrat-ExtraLight", size: 2)
        cell.selectionStyle = .none

        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "E, d MMM"

        var data = model.fastData
        data.removeAll(where: {$0.start == nil})

        cell.model = ViewCellModel(
            date: dayTimePeriodFormatter.string(from: Date(timeIntervalSince1970: (data[indexPath.row].end ?? .today))),
            hours: String("\(Int(data[indexPath.row].timeLapsed / 60 / 60))h"))

        return cell
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            let data = model.fastData[indexPath.row]
            let id = data.id
            guard let uid = Auth.auth().currentUser?.uid else { return }
            REF_FASTS.child(uid).child(id).removeValue { (error, _) in
                if error != nil {
                    debugPrint("DEBUG: Error while trying to delete fast:  \(String(describing: error))")
                }
            }

            FastService.data.removeAll(where: {$0.id == data.id})

            if var fast = model.currentFast {
                if fast.id == data.id {
                    fast.start = 0
                    model.updateFast(fast)
                }
            }

            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            tableView.reloadData()
        }
    }
}
