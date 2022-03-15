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
    
    enum FastAction {
        case start, edit, end
    }
    
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
    var isAnimated: Bool?
    var startTime: TimeInterval?
    var timeLapsed: Float = 0
    var timer: Timer?
    var profileImage: UIImage?
    var endDate: TimeInterval?
    var selectedHours: Int?
    var selectedDays: Int?
    
    var fastTimer: TimeInterval {
        return FastService.currentFast?.timeLapsed ?? 0
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
    
    var ringModel: RingViewModel {
        return RingViewModel(
            trackColor: UIColor.gray,
            animatedColor: UIColor(named: "time-color")!,
            timer: timerLabel,
            fast: fastLabel,
            timeSelected: timeSelected,
            state: state,
            timeLapsed: timeLapsed,
            stroke: stroke,
            prsentPicker: { [weak self] in
                self?.openPicker(.start)
            },
            stopStartBtn: { [ weak self] state in
                self?.handleStopStart(state: state)
            }
        )
    }
    
    var mainTileModel: MainTileModel {
        return MainTileModel(
            fastHours: "\(Int(fast?.timeLapsed ?? 0) / 60 / 60)h",
            water: "Water Consumed",
            weight: "Weight value",
            calories: "Calories eated",
            takeToFast: { [ weak self ] in
                self?.presentFastController()
            },
            presentEditPicker: { [ weak self] in
                self?.openPicker(.edit)
            }, state: state
        )
    }
    
    // =============================================
    // MARK: Callbacks
    // =============================================
    
    var presentController: ((UIViewController) -> Void)?
    var pushController: ((UIViewController) -> Void)?
    var refreshController: (() -> Void)?

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
    
    func openPicker(_ action: FastAction) {
        var title: String = "Your Fast Selection"
        var subtitle = "Select your fasting hours"
        var includes: [Includes] = [.start]
        switch action {
        case .edit:
            title = "Edit Fast"
            subtitle = "Update your fast start"
        case .end:
            title = "Fast Complete"
            subtitle = "You have completed \(Int(fast!.timeLapsed / 60 / 60)) of your \(Int(fast!.timeSelected / 60 / 60)) hour fast, congratulations! Do you want to save your fast?"
            includes.append(.end)
        default: break
        }
        
        let controller = DatePickerViewController(
            model: DatePickerViewModel(
                title: title,
                subtitle: subtitle,
                startDate: fast?.start,
                endDate: fast?.end ?? 0,
                includes: includes,
                selectedDaysHours: { [weak self] selectedHours, selectedDays in
                    self?.saveSelectedInterval(selectedHours: selectedHours, selectedDays: selectedDays)
                },
                selectedStart: { [weak self] start in
                    self?.updateStart(start ?? 0)
                },
                selectedEnd: { [weak self] end in
                    self?.endDate = end
                },
                save: { [ weak self] in
                    self?.endFast()
                }
            )
        )
        controller.modalPresentationStyle = .overFullScreen
        presentController?(controller)
    }
    
    @objc func presentProfileController() {
        let controller = ProfileViewController()
        pushController?(controller)
    }
    
    @objc func presentFastController() {
        let controller = FastViewController()
        pushController?(controller)
    }
    
    func checkState() {
        if fast?.start != nil && fast?.end == nil {
            state = .running
        } else {
            state = .stopped
        }
    }
    
    func saveSelectedInterval(selectedHours: Int, selectedDays: Int) {
        if selectedHours == 0 && selectedDays == 0 { return }
        let hours = (selectedDays * 24) + selectedHours
        let seconds = hours * 60 * 60
        
        var fast = FastService.currentFast
        if fast == nil {
            fast = Fast(
                timeSelected: TimeInterval(seconds)
            )
            FastService.currentFast = fast
        } else {
            fast?.updateTimeSelected(interval: TimeInterval(seconds))
        }
        updateLabel()
        guard let fast = fast else { return }
        FastService.updateFast(fast)
    }
    
    func updateLabel() {
        if state == .running {
            startTimer()
            fastLabel = String(format: "%d", Int(fast!.timeSelected) / 60 / 60) + "" + "hours"
        } else if fast?.timeSelected != nil {
            timerLabel = "Start Fast"
            fastLabel = String(format: "%d", Int(fast!.timeSelected) / 60 / 60) + "" + "hours"
        } else {
            timerLabel = "Select Fast"
            fastLabel = ""
        }
    }
    
    func handleStopStart(state: State) {
        self.state = state
            if state == .running {
            openPicker(.end)
            updateLabel()
        } else {
            startFast()
        }
    }
    
    func startFast() {
        let fast = FastService.currentFast
        if fast == nil {
            openPicker(.start)
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
                let stroke = CGFloat(((self.fastTimer) / ((self.fast?.timeSelected) ?? 0)) )
                self.stroke = Double(stroke)
            }
        }
    }
    
    func endFast() {
        timer?.invalidate()
        guard var fast = FastService.currentFast else { return }
        fast.updateEnd(interval: endDate!)
        FastService.updateFast(fast)
        self.state = .stopped
    }
    
    func updateStart(_ start: TimeInterval) {
        guard var fast = FastService.currentFast else { return }
        fast.updateStart(interval: start)
        FastService.updateFast(fast)
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

extension DatePickerView: UIPickerViewDataSource, UIPickerViewDelegate {
    
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
