//
//  MainViewModel.swift
//  Fasting App
//
//  Created by indre zibolyte on 29/01/2022.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseStorage

class MainViewModel {
    
    // =============================================
    // MARK: Properties
    // =============================================
        
    var user: User? {
        didSet {
            updateLabel()
            fetchUserImage()
            refreshController?()
        }
    }
    
    var fast: Fast? {
        didSet {
            checkState()
            updateLabel()
            refreshController?()
        }
    }
    
    var fastLabel = "" {
        didSet {
            refreshController?()
        }
    }
    
    var timerLabel = "" {
        didSet {
            refreshController?()
        }
    }
    
    var state: State = .stopped {
        didSet {
            print("DEBUG: STEP 3")
            print("DEBUG: STATE IN VM \(state)")
            refreshController?()
        }
    }
//
//    var isRunning: Bool {
//        return startTime != nil
//    }
    
    var startTime: TimeInterval?
    
    var timeSelected: Int?
    
    var profileImage: UIImage? 
    
    var ringModel: RingViewModel {
        return RingViewModel(
            trackColor: UIColor.gray,
            animatedColor: UIColor(named: "time-color")!,
            lblTimer: timerLabel,
            lblFast: fastLabel,
            timeSelected: timeSelected,
            prsentPicker: { [weak self] in
                self?.presentFastPicker()
            },
            stopStartBtn: { [ weak self] state in
                self?.handleStopStart(state: state)
            },
            state: state
//            btnStartStop: state!
        )
    }
    var fastPickerModel: FastPickerModel {
        return FastPickerModel(
            totalSelectedFast: 10,
            callback: { [ weak self ] fast in
                self?.saveSelectedInterval(timeSelected: fast)
            }
        )
    }
    
    var profileHeaderModel: ProfileHeaderModel {
        return ProfileHeaderModel(
            name: user?.fullName ?? "Not found",
            profilePic: profileImage,
            action: { [weak self] in
                self?.presentProfileController()
            }
        )
    }
    
    var mainTileModel: MainTileViewModel {
        return MainTileViewModel(
            fastHours: "Fast Hours",
            waterValue: "Water Consumed",
            weightvalue: "Weight value",
            calorieValue: "Calories eated",
            callback: { [ weak self] in
                
            })
    }
    
    // =============================================
    // MARK: Callbacks
    // =============================================
    
    var refreshController: (() -> Void)?
    var presentController: ((UIViewController) -> Void)?
    var pushController: ((UIViewController) -> Void)?
    
    // =============================================
    // MARK: Helpers
    // =============================================
    
    func viewDidLoad() {
        UserService.startObservingUser(self)
        FastService.startObservingFast(self)
        UserService.refreshUser()
        FastService.start()
//        checkState()
        updateLabel()
    }
    
    func checkState() {
        if fast?.start != nil && fast?.end == nil {
            state = .running
        } else {
            state = .stopped
        }
    }
    
    func presentFastPicker() {
        let controller = FastSelectionsViewController()
        controller.modalPresentationStyle = .overFullScreen
        presentController?(controller)
    }
    
    @objc func presentProfileController() {
        print("DEBUG: RECEIVING")
        let controller = ProfileViewController()
        pushController?(controller)
    }
    
    func fetchUserImage() {
        guard let imageURL = user?.imageURL else { return }
        ImageService.fetchImage(urlString: imageURL) { [weak self] image, _ in
            self?.profileImage = image
        }
    }
    
    func saveSelectedInterval(timeSelected: Int) {
        var fast = FastService.currentFast
        if fast == nil {
            fast = Fast(
                timeSelected: TimeInterval(timeSelected)
            )
            FastService.currentFast = fast
        } else {
            fast?.updateTimeSelected(interval: TimeInterval(timeSelected))
        }
        
        guard let fast = fast else { return }
        FastService.updateFast(fast)
    }
    
    func updateLabel() {
        let fast = FastService.currentFast?.timeSelected
        if fast == nil {
            timerLabel = "Select Fast"
            fastLabel = ""
        } else {
            timerLabel = "Start Fast"
            fastLabel = String(format: "%d", Int(fast!) / 60 / 60) + "" + "hours"
        }
    }
    
    func handleStopStart(state: State) {
        self.state = state
        print("DEBUG: HANDLE STOP START BUTTON _ STATE \(state)")
            if state == .running {
            guard var fast = FastService.currentFast else { return }
            fast.updateEnd(interval: Date().timeIntervalSince1970)
//            endFast()
            self.state = .stopped
        } else {
            startFast()
        }
        UserService.refreshUser()
    }
    
    func startFast() {
        timeSelected = Int(FastService.currentFast?.timeSelected ?? 0)
        let fast = FastService.currentFast
        if fast == nil {
            presentFastPicker()
        } else {
            guard var fast = FastService.currentFast else { return }
            fast.updateStart(interval: Date().timeIntervalSince1970)
            FastService.updateFast(fast)
    
            UserService.refreshUser()
            state = .running
        }
    }
    
    func endFast() {
        guard var fast = FastService.currentFast else { return }
        let end = fast.end
        fast.updateStart(interval: Date().timeIntervalSince1970)
//        FastService.updateFast(.updateEnd(fase.e))
        checkState()
    }
    
    func passingFast(fast: Int) {
        
    }
}

// =================================
// MARK: TemplateObserver
// =================================

extension MainViewModel: UserServiceObserver {
    func userServiceUserUpdated(_ user: User?) {
        self.user = user
    }
}

extension MainViewModel: FastServiceObserver {
    func fastServiceFastUpdated(_ fast: Fast?) {
        self.fast = fast
    }
}

// =============================================
// MARK: UIPickerViewDataSource
// =============================================

extension FastPickerView: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4 // 2 headers and 2 values
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
           return 1 // hours header
        } else if component == 1 {
           return 31 // hours
        } else if component == 2 {
           return 1 // days header
        } else {
           return 25 // days
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 1 {
            selectedDays = row
        } else {
            selectedHours = row
        }
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "Montserrat-Light", size: 18)
            pickerLabel?.textAlignment = .center
        }

        if component == 0 {
            pickerLabel?.text = "Days:" // header
        } else if component == 1 {
            pickerLabel?.text = "\(row)" // value
        } else if component == 2 {
            pickerLabel?.text = "Hours:" // header
        } else if component == 3 {
            pickerLabel?.text = "\(row)" // value
        }
        return pickerLabel!
    }
}
