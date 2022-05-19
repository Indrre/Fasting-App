//
//  FastView.swift
//  Fasting App
//
//  Created by indre zibolyte on 11/03/2022.
//

import Foundation
import UIKit
import SnapKit

struct FastModel {
    
    let graphModel: FastBarModel
    let timerLapsed: TimeInterval?
    let hours: String?
    
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
        
        backgroundColor = .stdBackground
        
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
