//
//  FastPickerView.swift
//  Fasting App
//
//  Created by indre zibolyte on 23/02/2022.
//

import Foundation
import UIKit

struct FastPickerModel{
    var totalSelectedFast: Int?
    var callback: ((_ totalSelectedFast: Int) -> Void?)
}

class FastPickerView: UIView {

    //=============================================
    // MARK: Properties
    //=============================================

    var selectedHours = 0
    var selectedDays = 0
    var totalSelectedFast = 0

    weak var delegate: ModalViewControllerDelegate?

    lazy var homeIndicatorBar: UIImageView = {
        let view = UIImageView()
        view.tintColor = .stdText
        view.image = UIImage(named: "home-indicator-bar")?.withRenderingMode(.alwaysTemplate)
        view.clipsToBounds = true
        view.layer.cornerRadius = 3
        view.backgroundColor = .homeIndicatorColor
        return view
    }()

    let topLabel: UILabel = {
        let label = UILabel()
        label.font =  UIFont(name: "Montserrat-SemiBold", size: 24)
        label.text = "Your Fast selection"
        label.textAlignment = .center
        label.textColor = .stdText
        return label
    }()

    let lblMessage: UILabel = {
        let label = UILabel()
        label.font =  UIFont(name: "Montserrat-ExtraLight", size: 14)
        label.text = "Please select your fasting hours"
        label.textAlignment = .center
        label.textColor = .stdText
        return label
    }()

    lazy var picker: UIPickerView = {
        let view = UIPickerView()
        view.tintColor = .stdText
        view.delegate = self
        view.dataSource = self
        return view
    }()

    lazy var selectButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .timeColor
        view.layer.cornerRadius = 10
        view.setTitle("Select", for: .normal)
        view.titleLabel?.font = UIFont(name: "Montserrat-Medium", size: 18)
        view.setTitleColor(.white, for: .normal)
        view.addTarget(self, action: #selector(savePressed), for: .touchUpInside)
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

    var model: FastPickerModel {
        didSet {
            totalSelectedFast = model.totalSelectedFast ?? 0
        }
    }

    //=============================================
    // MARK: Callback
    //=============================================

    var dismiss: ((TimeInterval) -> Void)?

    //=============================================
    // MARK: Initialization
    //=============================================

    init(model: FastPickerModel) {
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

        addSubview(topLabel)
        topLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(40)
        }

        addSubview(lblMessage)
        lblMessage.numberOfLines = 0
        lblMessage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(topLabel.snp.bottom).offset(15)
            $0.height.equalTo(20)
            $0.width.equalTo(350)
        }

        addSubview(picker)
        picker.snp.makeConstraints {
            $0.height.equalTo(200)
            $0.top.equalTo(lblMessage.snp.bottom).offset(10)
            $0.left.right.equalToSuperview().inset(15)
        }

        addSubview(selectButton)
        selectButton.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.left.right.equalToSuperview().inset(15)
            $0.top.equalTo(picker.snp.bottom).offset(20)
        }

        addSubview(cancelButton)
        cancelButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.size.equalTo(selectButton)
            $0.top.equalTo(selectButton.snp.bottom)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //========================================
    // MARK: Helpers
    //========================================

    @objc func savePressed() {
        calculateTotalSelectedFast()
        delegate?.modalClose()
        model.callback(totalSelectedFast)
    }

    @objc func cancelButtonPressed() {
        delegate?.modalClose()
    }

    func calculateTotalSelectedFast() {
        let hours = (selectedDays * 24) + selectedHours
        let seconds = hours * 60 * 60
        totalSelectedFast = seconds
        delegate?.modalClose()
//        if totalSelectedFast != 0 {
//            dismiss?(TimeInterval(seconds))
//        }
    }

}
