//
//  DatePickerView.swift
//  Fasting App
//
//  Created by indre zibolyte on 12/03/2022.
//

import Foundation
import UIKit

enum Includes: Int {
    case start, end
}

struct DatePickerViewModel {
    
    enum DateType {
        case end, start
    }
    
    let title: String
    var subtitle: String
    let startDate: TimeInterval?
    let endDate: TimeInterval?
    let includes: [Includes]
    let selectedDaysHours: ((_ selectedHours: Int, _ selectedDays: Int) -> Void)
    let selectedStart: ((_ start: TimeInterval?) -> Void)
    let selectedEnd: ((_ end: TimeInterval?) -> Void)
    
    var dateUpdated: ((
        _ type: DateType,
        _ date: TimeInterval,
        _ completion: (String?) -> Void
    ) -> Void)

    let save: (() -> Void)
}

class DatePickerView: UIView {
    
    // =============================================
    // MARK: Properties
    // =============================================
    
    var selectedHours = 0
    var selectedDays = 0

    // =============================================
    // MARK: Callbacks
    // =============================================
    
    var completionCallback: (() -> Void)?
    
    // =============================================
    // MARK: Components
    // =============================================
    
    lazy var homeIndicatorBar: UIImageView = {
        let view = UIImageView()
        view.tintColor = .stdText
        view.image = UIImage(named: "home-indicator-bar")?.withRenderingMode(.alwaysTemplate)
        view.clipsToBounds = true
        view.layer.cornerRadius = 3
        view.backgroundColor = .homeIndicatorColor
        return view
    }()
    
    var lblTitle: UILabel = {
        var label = UILabel()
        label.font =  UIFont(name: "Montserrat-SemiBold", size: 24)
        label.textAlignment = .center
        label.textColor = .stdText
        return label
    }()
    
    let lblSubTitle: UILabel = {
        let label = UILabel()
        label.font =  UIFont(name: "Montserrat-ExtraLight", size: 14)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .stdText
        return label
    }()
    
    var lblStart: UILabel = {
        var label = UILabel()
        label.font =  UIFont(name: "Montserrat-Medium", size: 20)
        label.textColor = .stdText
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        label.text = "Start:"
        return label
    }()
    
    var lblEnd: UILabel = {
        var label = UILabel()
        label.font =  UIFont(name: "Montserrat-Medium", size: 20)
        label.textColor = .stdText
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        label.text = "End:"
        return label
    }()
    
    lazy var startDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.tag = Includes.start.rawValue
        datePicker.tintColor = .stdText
        datePicker.datePickerMode = .dateAndTime
        datePicker.addTarget(self, action: #selector(startDateChanged), for: .valueChanged)

        return datePicker
    }()
    
    @objc func startDateChanged(sender: UIDatePicker) {
        let start = sender.date.timeIntervalSince1970
        endDatePicker.minimumDate = Date(timeIntervalSince1970: start)
        
        model.dateUpdated(.start, start) { [weak self] updatedLabel in
            self?.lblSubTitle.text = updatedLabel
        }
    }
    
    @objc func endDateChanged(sender: UIDatePicker) {
        let end = sender.date.timeIntervalSince1970
        model.dateUpdated(.end, end) { [weak self] updatedLabel in
            self?.lblSubTitle.text = updatedLabel
        }
    }
    
    lazy var endDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.tag = Includes.end.rawValue
        datePicker.tintColor = .stdText
        datePicker.datePickerMode = .dateAndTime
        datePicker.addTarget(self, action: #selector(endDateChanged), for: .valueChanged)

        return datePicker
    }()
    
    lazy var dayHourPicker: UIPickerView = {
        let view = UIPickerView()
        view.tintColor = .stdText
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    let firstStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 15
        return view
    }()
    
    let secondtackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 15
        return view
    }()
    
    lazy var saveButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .timeColor
        view.layer.cornerRadius = 10
        view.setTitle("Save", for: .normal)
        view.titleLabel?.font = UIFont(name: "Montserrat-Medium", size: 18)
        view.setTitleColor(.white, for: .normal)
        view.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        return view
    }()
    
    lazy var cancelButton: UIButton = {
        let view = UIButton()
        view.setTitle("Cancel", for: .normal)
        view.titleLabel?.font = UIFont(name: "Montserrat-Medium", size: 18)
        view.setTitleColor(.stdText, for: .normal)
        view.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        return view
    }()
    
    var model: DatePickerViewModel {
        didSet {
            setup()
        }
    }
    
    // =============================================
    // MARK: Initialization
    // =============================================
    
    init(model: DatePickerViewModel) {
        self.model = model
        super.init(frame: .zero)
        backgroundColor = .blackWhiteBackground
        
        addSubview(homeIndicatorBar)
        homeIndicatorBar.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.width.equalTo(60)
            $0.height.equalTo(5)
            $0.centerX.equalToSuperview()
        }
        
        addSubview(lblTitle)
        lblTitle.snp.makeConstraints {
            $0.top.equalToSuperview().offset(35)
            $0.left.right.equalToSuperview()
        }
        
        addSubview(lblSubTitle)
        lblSubTitle.snp.makeConstraints {
            $0.top.equalTo(lblTitle.snp.bottom).offset(15)
            $0.height.equalTo(60)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
        }
        
        addSubview(firstStackView)
        firstStackView.snp.makeConstraints {
            $0.top.equalTo(lblSubTitle.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        addSubview(secondtackView)
        secondtackView.snp.makeConstraints {
            $0.top.equalTo(firstStackView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        addSubview(cancelButton)
        cancelButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.left.right.equalToSuperview().inset(15)
            $0.bottom.equalToSuperview().inset(25)
        }
        addSubview(saveButton)
        saveButton.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(cancelButton)
            $0.bottom.equalTo(cancelButton.snp.top).offset(-25)
        }
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // =============================================
    // MARK: Helpers
    // =============================================
    
    func setup() {
        
        lblTitle.text = model.title
        lblSubTitle.text = model.subtitle
        if let startDate = model.startDate {
            startDatePicker.date = Date(timeIntervalSince1970: startDate)
        }
        
        endDatePicker.date = model.endDate != nil ? Date(timeIntervalSince1970: model.endDate!) : Date()
                
        model.includes.forEach {
            switch $0 {
            case .start:
                if model.startDate == nil {
                    firstStackView.addArrangedSubview(dayHourPicker)
                    dayHourPicker.snp.makeConstraints {
                        $0.centerX.equalToSuperview()
                        $0.top.equalToSuperview().inset(-70)
                    }
                } else {
                    firstStackView.addArrangedSubview(lblStart)
                    firstStackView.addArrangedSubview(startDatePicker)
                    startDatePicker.maximumDate = Date()
                }
            case .end:
                
                firstStackView.addArrangedSubview(lblStart)
                firstStackView.addArrangedSubview(startDatePicker)
                
                secondtackView.addArrangedSubview(lblEnd)
                secondtackView.addArrangedSubview(endDatePicker)
                endDatePicker.date = Date()
                endDatePicker.minimumDate = Date(timeIntervalSince1970: model.startDate ?? .today)
                endDatePicker.maximumDate = Date()
                endDatePicker.minimumDate = Date(timeIntervalSince1970: model.startDate ?? .today)
            }
        }
    }

    @objc func saveButtonPressed() {
        model.includes.forEach {
            switch $0 {
            case .start:
                if model.startDate == nil {
                    model.selectedDaysHours(selectedHours, selectedDays)
                } else {
                    model.selectedStart(startDatePicker.date.timeIntervalSince1970)
                }
            case .end:
                // update this
                model.selectedStart(startDatePicker.date.timeIntervalSince1970)
                model.selectedEnd(endDatePicker.date.timeIntervalSince1970)
                model.save()
            }
        }
        completionCallback?()
    }
    
    @objc func cancelButtonPressed() {
        completionCallback?()
    }
}
