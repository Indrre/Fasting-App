////
////  FastViewModel.swift
////  Fasting App
////
////  Created by indre zibolyte on 23/02/2022.
////
//
//import Foundation
//import UIKit
//
//class FastViewModel {
//
//    // =============================================
//    // MARK: Properties
//    // =============================================
//
//    var user: User? {
//        didSet {
////            fetchUserImage()
////            refreshController?()
//        }
//    }
//
//
//    var timer: Timer?
//    var fastLabel: String = "Fast lbl"
//    var timerLabel: String = "Fast lbl"
//
//
//
//    var fastPickerModel: FastPickerModel {
//        return FastPickerModel(
//            totalSelectedFast: 10,
//            callback: { [ weak self ] fast in
//                self?.fastSelected(fast: fast)
//            }
//        )
//    }
//
////    var ringModel: RingViewModel {
////        return RingViewModel(
////            lblTimer: timerLabel,
////            lblFast: fastLabel, refreshTimeLabels: <#(Int?) -> Void?#>
////        )
////    }
//
//
//    //=============================================
//    // MARK: Callback
//    //=============================================
//
//    var callback: (() -> Void)?
//    var refreshController: (() -> Void)?
//
//    // =============================================
//    // MARK: Helpers
//    // =============================================
//
//    func viewDidLoad() {
//        UserService.startObserving(self)
//        UserService.refreshUser()
//    }
//
//    func fastSelected(fast: Int) {
//        print("FACT SELECTED: \(fast)")
//    }
//
//    func startTimer() {
//        timer?.invalidate()
//        timer = Timer.scheduledTimer(
//            timeInterval: 1.0,
//            target: self,
//            selector: #selector(updateCounter),
//            userInfo: nil,
//            repeats: false
//        )
//    }
//
//
//    @objc func updateCounter() {
////        if fastSelected == nil {
////            fastLabel = "Select your fast"
////        } else {
////            timerLabel = "\(Int(fastSelected ?? 0) / 60 / 60) hour fast"
////        }
//    }
//
//}
//
////=================================
//// MARK: TemplateObserver
////=================================
//
//extension FastViewModel: UserServiceObserver {
//    func userServiceUserUpdated(_ user: User?) {
//        self.user = user
//    }
//}
//
//
//
////=============================================
//// MARK: UIPickerViewDataSource
////=============================================
//
//extension FastPickerView: UIPickerViewDataSource, UIPickerViewDelegate {
//
//
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 4 //2 headers and 2 values
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        if component == 0 {
//           return 1 //hours header
//        } else if component == 1 {
//           return 31 //hours
//        } else if component == 2 {
//           return 1 //days header
//        } else {
//           return 25 //days
//        }
//    }
//
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        if component == 1 {
//            selectedDays = row
//        } else {
//            selectedHours = row
//        }
//    }
//
//    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
//        var pickerLabel: UILabel? = (view as? UILabel)
//        if pickerLabel == nil {
//            pickerLabel = UILabel()
//            pickerLabel?.font = UIFont(name: "Montserrat-Light", size: 18)
//            pickerLabel?.textAlignment = .center
//        }
//
//        if component == 0 {
//            pickerLabel?.text = "Days:" //header
//        } else if component == 1 {
//            pickerLabel?.text = "\(row)" //value
//        } else if component == 2 {
//            pickerLabel?.text = "Hours:" //header
//        } else if component == 3 {
//            pickerLabel?.text = "\(row)" //value
//        }
//        return pickerLabel!
//    }
//
//}
//
//
