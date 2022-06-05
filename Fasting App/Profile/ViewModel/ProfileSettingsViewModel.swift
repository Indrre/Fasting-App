//
//  ProfileSettingsViewModel.swift
//  Fasting App
//
//  Created by indre zibolyte on 31/01/2022.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseStorage

class ProfileSettingViewModel: NSObject, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    // =============================================
    // MARK: Properties
    // =============================================
    
    private let imageStorage = Storage.storage().reference()
    
    var age: Int?
    var weight: String?
    var height: String?
    var heightUnit: String?
    var gender: String?
    var activity: String?
    var newAge: Int?
        
    var user: User? {
        didSet {
            fetchUserImage()
            getHeight()
            refreshController?()
        }
    }
        
    var currentWeight: Weight? {
        didSet {
            getWeight()
            refreshController?()
        }
    }
    
    var profileImage: UIImage? =  UIImage(named: "profile-pic") {
        didSet {
            refreshController?()
        }
    }
    
    var profileSettingsModel: ProfileSettingsModel {
        return ProfileSettingsModel(
            profileImage: profileImage,
            name: user?.fullName ?? "",
            age: String(user?.age ?? 19),
            weight: weight,
            height: String(height  ?? "0") + (user?.heightMsureUnit ?? "0"),
            gender: user?.gender ?? "Female",
            activity: user?.activity ?? "Inactive ",
            callback: { [weak self] in
                self?.showActionSheetController()
            },
            presentController: {  [weak self] type in
                self?.presentPickerView(type: type)
            },
            signOut: { [weak self] in
                self?.signOut()
            }
        )
    }
    
    // =================================
    // MARK: Callbacks
    // =================================
    
    var refreshController: (() -> Void)?
    var presentActionSheet: ((UIViewController) -> Void)?
    var presentNameEditController: ((UIViewController) -> Void)?
    var presentInageEditController: ((UIViewController) -> Void)?
    var presentPickerController: ((UIViewController) -> Void)?
    var presentController: ((_ type: PersonalInfo) -> Void)?
    var presentLogin: ((UIViewController) -> Void)?
    
    // =============================================
    // MARK: Helpers
    // =============================================
    
    func viewDidLoad() {
        WeightService.start()
        WeightService.startObservingWeight(self)
        getWeight()
        getHeight()
        UserService.startObservingUser(self)
        UserService.refreshUser()
    }
    
    func saveName(name: String) {
        let values = ["fullName": name]
        Service.shared.updateUserValues(values: values as [String: Any])
        UserService.refreshUser()
    }
    
    func saveAge(age: Int) {
        self.age = age
        let values = ["age": age]
        Service.shared.updateUserValues(values: values as [String: Any])
        UserService.refreshUser()
    }
    
    func saveWeight(mesureUnits: String, value: Double) {
        
        var weight = WeightService.currentWeight
        if mesureUnits == "st" {
            let count = value * 453.592
            
            weight.count = Int(count)
        } else {
            weight.count = Int(value)
        }
        weight.unit = mesureUnits
        weight.date = .today
        Service.shared.updateUserWeight(weight)
        WeightService.start()
    }
    
    func saveHeight(mesureUnits: String, heightFirstUnit: Double, heightSecondUnit: Double) {
        
        let values = [
            "heightUnit": mesureUnits,
            "heightFirstUnit": heightFirstUnit,
            "heightSecondUnit": heightSecondUnit] as [String: Any]
        Service.shared.updateUserValues(values: values as [String: Any])
        UserService.refreshUser()
    }
    
    func saveGender(gender: String) {
        let values = ["gender": gender] as [String: Any]
        Service.shared.updateUserValues(values: values as [String: Any])
        self.gender = gender
        UserService.refreshUser()
    }
    
    func saveActivity(activity: String) {
        let values = ["activity": activity] as [String: Any]
        Service.shared.updateUserValues(values: values as [String: Any])
        self.activity = activity
        UserService.refreshUser()
    }
    
    func getWeight() {
        let currentWeight = WeightService.currentWeight
        guard let weightUnit = currentWeight.unit else { return }
        guard let userWeight = currentWeight.count else { return }
        
        if weightUnit == "kg" {
            let calculations = Double(userWeight) / Double(1000)
            
            let label = String(format: "%.1f", calculations)
            weight = "\(label)kg"
        } else {
            
            var pounds = (Double(userWeight) * 0.00220462)
            var numberOfStones = 0.0
            while pounds > 14 {
                pounds -= 14
               numberOfStones += 1
            }
            let numbetOfPounds = pounds.rounded()
            weight = "\(Int(numberOfStones))st \(Int(numbetOfPounds))lb"
        }
    }
    
    func getHeight() {
        guard let heightMesureUnit = user?.heightMsureUnit else { return }
        guard let userheightFirstUnit = user?.heightFirstUnit else { return }
        guard let userheightSecondUnit = user?.heightSecondUnit else { return }
        
        if heightMesureUnit == "m" {
            height = "\(Int(userheightFirstUnit)).\(Int(userheightSecondUnit))"
        } else {
            height = "\(Int(userheightFirstUnit)).\(Int(userheightSecondUnit))"
        }
    }
    
    func fetchUserImage() {
        guard let imageURL = user?.imageURL else { return }
        ImageService.fetchImage(urlString: imageURL) { [weak self] image, _ in
            self?.profileImage = image
        }
    }
    
    func presentPickerView(type: PersonalInfo) {
        let controller = UserSettingsProfilePickerController()
        controller.modalPresentationStyle = .overFullScreen
        controller.setupPickerView(type: type)
        presentPickerController?(controller)
    }
    
    func showImagePickerController() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        presentInageEditController?(imagePicker)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        guard let imageData = selectedImage.pngData() else { return }
        
        let userID = user?.uid
        imageStorage.child("\(String(describing: userID))/file.png").putData(imageData, metadata: nil) { _, error in
            guard error == nil else {
                debugPrint("DEBUG: Failed to upload image")
                return
            }
            
            self.imageStorage.child("\(String(describing: userID))/file.png").downloadURL(completion: {url, error in
                guard let url = url, error == nil else {
                    return
                }
                let urlString = url.absoluteString
                
                let values = ["imageURL": urlString]
                Service.shared.updateUserValues(values: values )
                self.refreshController?()
            })
        }
    }
    
    func showNameEditController() {
        let controller = NameEditController()
        presentNameEditController?(controller)
    }
    
    func showActionSheetController() {
        let actionSheet = UIAlertController(
            title: nil,
            message: "Please select to edit",
            preferredStyle: .actionSheet
        )
        actionSheet.addAction(
            UIAlertAction(
                title: "Image",
                style: .default,
                handler: { _ in
                    self.showImagePickerController()
                }
            )
        )
        actionSheet.addAction(
            UIAlertAction(
                title: "Name",
                style: .default,
                handler: { _ in
                    self.showNameEditController()
                }
            )
        )
        actionSheet.addAction(
            UIAlertAction(
                title: "Cancel",
                style: .cancel,
                handler: nil
            )
        )
        actionSheet.view.tintColor = UIColor.stdText
        presentActionSheet?(actionSheet)
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            presentLoginController()
        } catch {
            debugPrint("DEBUG: Error Signing Out")
        }
    }
    
    func presentLoginController() {
        let controller = LoginViewController()
        presentLogin?(controller)
    }
}

// =================================
// MARK: TemplateObserver
// =================================

extension ProfileSettingViewModel: UserServiceObserver {

    func userServiceUserUpdated(_ user: User?) {
        self.user = user
    }
}

extension ProfileSettingViewModel: WeightServiceObserver {
    func weightServiceWeightUpdated(_ weight: Weight?) {
        self.currentWeight = weight
    }
    
    func weightServiceRefreshedData() {
        refreshController?()
    }
}
