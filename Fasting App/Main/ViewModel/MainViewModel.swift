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
    
    var fastLabel: String? {
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
            refreshController?()
        }
    }
    
    var stroke: CGFloat = 0
    
    var timeSelected: TimeInterval?
    
    var fastTimer: TimeInterval {
        return FastService.currentFast?.timeLapsed ?? 0
    }
    
    var isAnimated: Bool?
    
    var startTime: TimeInterval?
    var timeLapsed: Float = 0
    var timer: Timer?
    var profileImage: UIImage? 
    
    var ringModel: RingViewModel {
        return RingViewModel(
            isAnimated: isAnimated,
            trackColor: UIColor.gray,
            animatedColor: UIColor(named: "time-color")!,
            timer: timerLabel,
            fast: fastLabel,
            timeSelected: timeSelected,
            state: state,
            timeLapsed: timeLapsed,
            stroke: stroke,
            prsentPicker: { [weak self] in
                self?.presentFastPicker()
            },
            stopStartBtn: { [ weak self] state in
                self?.handleStopStart(state: state)
            }
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
            name: user?.fullName ?? "",
            profilePic: profileImage,
            action: { [weak self] in
                self?.presentProfileController()
            }
        )
    }
    
    var mainTileModel: MainTileModel {
        return MainTileModel(
            fastHours: fast?.timeLapsed.timeString ?? "" + "h",
            water: "Water Consumed",
            weight: "Weight value",
            calories: "Calories eated",
            callback: { [ weak self ] in
                print("Calling")
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
        updateLabel()
    }
    
    func fetchUserImage() {
        guard let imageURL = user?.imageURL else { return }
        ImageService.fetchImage(urlString: imageURL) { [weak self] image, _ in
            self?.profileImage = image
        }
    }
    
    func presentFastPicker() {
        let controller = FastSelectionsViewController()
        controller.modalPresentationStyle = .overFullScreen
        presentController?(controller)
    }
    
    @objc func presentProfileController() {
        let controller = ProfileViewController()
        pushController?(controller)
    }
    
    func checkState() {
        if fast?.start != nil && fast?.end == nil {
            state = .running
        } else {
            state = .stopped
        }
    }
    
    func saveSelectedInterval(timeSelected: Int) {
        if timeSelected == 0 { return }
        var fast = FastService.currentFast
        if fast == nil {
            fast = Fast(
                timeSelected: TimeInterval(timeSelected)
            )
            FastService.currentFast = fast
        } else {
            fast?.updateTimeSelected(interval: TimeInterval(timeSelected))
        }
        updateLabel()
        guard let fast = fast else { return }
        FastService.updateFast(fast)
    }
    
    func updateLabel() {
        if state == .running {
            startTimer()
            updateCounter()
            fastLabel = String(format: "%d", Int(fast!.timeSelected) / 60 / 60) + "" + "hours"
        } else if fast?.timeSelected != nil {
            timerLabel = "Start Fast"
            fastLabel = String(format: "%d", Int(fast!.timeSelected) / 60 / 60) + "" + "hours"
        } else {
            timerLabel = "Select Fast"
        }
        UserService.refreshUser()
    }
    
    func handleStopStart(state: State) {
        self.state = state
            if state == .running {
            guard var fast = FastService.currentFast else { return }
            fast.updateEnd(interval: Date().timeIntervalSince1970)
            endFast()
            self.state = .stopped
        } else {
            startFast()
        }
        UserService.refreshUser()
    }
    
    func startFast() {
        let fast = FastService.currentFast
        if fast == nil {
            presentFastPicker()
        } else {
            guard var fast = FastService.currentFast else { return }
            fast.updateStart(interval: Date().timeIntervalSince1970)
            FastService.updateFast(fast)
    
            UserService.refreshUser()
            state = .running
            startTimer()
            
        }
    }
    
    func startTimer() {
        if FastService.currentFast == nil { return }
        timer?.invalidate()
        timer = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(updateCounter),
            userInfo: nil,
            repeats: true
        )
    }
    
    @objc func updateCounter() {
        if let fast = FastService.currentFast {
            DispatchQueue.main.async {
                self.timerLabel = fast.timeLapsed.timeString
                self.isAnimated = true
                let stroke = CGFloat(((self.fastTimer) / ((self.fast?.timeSelected)!)) )
                self.stroke = Double(stroke)
            }
        }
       
    }
    
    func endFast() {
        guard var fast = FastService.currentFast else { return }
        fast.updateEnd(interval: Date().timeIntervalSince1970)
        FastService.updateFast(fast)
        timer?.invalidate()
        fastLabel = ""
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
           return 1 // "Days" Header
        } else if component == 1 {
           return 32 // Number of days
        } else if component == 2 {
           return 1 // "Hours" Header
        } else {
           return 25 // Number of hours
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
