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
import UserNotifications

class MainViewModel {
    
    enum FastAction {
        case start, edit, end
    }
    
    // =============================================
    // MARK: Properties
    // =============================================
    
    var stroke: CGFloat = 0
    var timeSelected: TimeInterval?
    var isAnimated: Bool?
    var startTime: TimeInterval?
    var timeLapsed: Float = 0
    var timer: Timer?
    var profileImage: UIImage? = UIImage(named: "profile-pic")
    var endDate: TimeInterval?
    var selectedHours: Int?
    var selectedDays: Int?
    var lblWeight: String?
    
    let options: UNAuthorizationOptions = [.alert, .sound, .badge]
    var timeLapsedToNotification: TimeInterval = 0

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
            setupNotifications()
            refreshController?()
        }
    }
    
    var fastLabel: String? {
        didSet {
            refreshController?()
        }
    }
    
    var weightLabel: String? {
        
        let weight = WeightService.currentWeight
        return  "\(setWeightLabel(weight: weight))"
        
    }
    
    var waterLabel: String {
        let count = WaterService.currentWater.count ?? 0
        if count > 1 {
            return "\(count) glasses"
        } else {
            return "\(count) glass"
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
    
    var fastTimeSelected: String {
        if state != .running {
            return "0h"
        } else {
            
            return "\(Int(FastService.currentFast?.timeLapsed ?? 0) / 60 / 60) h"
        }
    }
    
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
            fastHours: fastTimeSelected,
            water: waterLabel,
            weight: weightLabel ?? "Nothing to display",
            calories: "Calories eated",
            takeToFast: { [ weak self ] in
                self?.presentFastController()
            },
            takeToWater: { [ weak self ] in
                self?.presentWaterViewController()
            },
            takeToWeight: { [ weak self ] in
                self?.presentWeightViewController()
            },
            presentEditPicker: { [ weak self] in
                self?.openPicker(.edit)
            },
            state: state
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
        WaterService.start()
        WeightService.start()
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
                    debugPrint("@@@ updateStart")
                },
                selectedEnd: { [weak self] end in
                    self?.endDate = end
                    debugPrint("@@@ endDate")
                },
                newStartDate: { [ weak self ] newStart in
                    self?.updateNewStart(newStart: newStart!)
                    debugPrint("@@@ updateNewStart")
                },
                save: { [ weak self] in
                    self?.endFast()
                    debugPrint("@@@ endFast eave fasr")
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
    
    func presentWaterViewController() {
        let controller = WaterViewController()
        pushController?(controller)
    }
    
    func presentWeightViewController() {
        let controller = WeightViewContorller()
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
    
    func updateNewStart(newStart: TimeInterval) {
        debugPrint("newStart in viemodel \(newStart)")
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
        
    func setWeightLabel(weight: Weight) -> String {
        
        let weightUnit = weight.unit
        let userWeight = weight.count
        if weightUnit == "kg" {
            let calculations = Double(userWeight ?? 0) / Double(1000)
            
            let label = String(format: "%.1f", calculations)
            lblWeight = "\(label)kg"
        } else {
            
            var pounds = (Double(userWeight ?? 0) * 0.00220462)
            var numberOfStones = 0.0
            while pounds > 14 {
                pounds -= 14
                numberOfStones += 1
            }
            
            let numbetOfPounds = pounds.rounded()
            lblWeight = "\(Int(numberOfStones))st \(Int(numbetOfPounds))lb"
        }
        return lblWeight ?? "String"
    }
    
    func setupNotifications() {
        debugPrint("NOTIFICATIONS")
        // 1. Ask for permission
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: options) { (granted, error) in }
        
        // 2. Create Notification content
        let content = UNMutableNotificationContent()
        content.title = "Whoop whoop!"
        content.subtitle = "You have reached your Fasting goal!"
        //        content.body = "You can eat now! Whoop Whoop"
        content.badge = 0
        content.sound = UNNotificationSound.default
        
        // 3. Create notification trigger
        if FastService.currentFast == nil {
            debugPrint("NOTIFICATIONS ?\(FastService.currentFast)")
            return
        } else {
            
            let timeLapsed = FastService.currentFast!.timeLapsed
            let timeSelected = FastService.currentFast!.timeSelected
            timeLapsedToNotification = timeSelected - timeLapsed
            debugPrint("NOTIFICATIONS{ !\(timeLapsedToNotification)")
        }
        
        let date = Date().addingTimeInterval(timeLapsedToNotification)
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        // 4. Create request
        guard let fastId = FastService.currentFast?.id else { return }
        print("fastId \(fastId)")
        let request = UNNotificationRequest(identifier: fastId, content: content, trigger: trigger)
        
        // 5. Register the request
        center.add(request) { (error) in
            print("sending request")
            if error != nil {
                print("Notification error \(String(describing: error))")
            }
        }
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
    func fastServiceRefreshedData() {
    }
    
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
