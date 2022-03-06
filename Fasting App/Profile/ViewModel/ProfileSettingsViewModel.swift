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
//import FirebaseCore
//import AVFoundation

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
    
    var user: User? {
        didSet {
            fetchUserImage()
            getWeight()
            getHeight()
            rerefreshController?()
            
        }
    }
    
    var profileImage: UIImage? {
        didSet {
            rerefreshController?()
        }
    }
    
    var profileSettingsModel: ProfileSettingsModel {
        return ProfileSettingsModel(
            profileImage: profileImage,
            name: user?.fullName ?? "",
            lblAgeValue: String(user?.age ?? 18),
            lblWeightValue: String(weight ?? "0.0") + (user?.weightUnit ?? ">"),
            lblHeightValue: String(height  ?? "0") + (user?.heightMsureUnit ?? "0"),
            lblGenderValue: user?.gender ?? "Female",
            lblActivityValue: user?.activity ?? "Inactive (less than 30 mins)",
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
    
    var ageViewModel: AgePickerModel {
        return AgePickerModel(
            value: user?.age,
            callback: { [weak self] age in
                self?.saveAge(age: age)
            }
        )
    }
    
    var weightModel: WeightPickerModel {
        return WeightPickerModel(
            mesureUnit: user?.weightUnit,
            weight: weight,
            callback: { [weak self] mesureUnit, weight in
                self?.saveWeight(mesureUnits: mesureUnit!, value: weight)
            }
        )
    }
    
    var heightModel: HeightPickerModel {
        return HeightPickerModel(
            mesureUnit: user?.weightUnit,
            value: height,
            callback: { [weak self] mesureUnit, firstUnit, secondUnit in
                self?.saveHeight(mesureUnits: mesureUnit!, heightFirstUnit: firstUnit, heightSecondUnit: secondUnit)
            }
        )
    }
    
    var genderModel: GenderPickerModel {
        return GenderPickerModel(
            gender: gender,
            callback: { [weak self] gender in
                self?.saveGender(gender: gender)
            }
        )
    }
    
    var activityModel: ActivityPickerModel {
        return ActivityPickerModel(
            activity: activity,
            callback: { [weak self] activity in
                self?.saveActivity(activity: activity)
            }
        )
    }
    
    //=================================
    // MARK: Callbacks
    //=================================
    
    var rerefreshController: (() -> Void)?
    var presentActionSheet: ((UIViewController) -> Void)?
    var presentNameEditController: ((UIViewController) -> Void)?
    var presentInageEditController: ((UIViewController) -> Void)?
    var presentPickerController: ((UIViewController) -> Void)?
    var presentController: ((_ type: PersonalInfo) -> Void)?
    
    //=============================================
    // MARK: Helpers
    //=============================================
    
    func viewDidLoad() {
        getWeight()
        getHeight()
        UserService.startObservingUser(self)
        UserService.refreshUser()
    }
    
    func saveName(name: String) {
        let values = ["fullName": name]
        Service.shared.updateUserValues(values: values as [String : Any])
        UserService.refreshUser()
    }
    
    func saveAge(age: Int) {
        self.age = age
        let values = ["age": age]
        Service.shared.updateUserValues(values: values as [String : Any])
        UserService.refreshUser()
    }
    
    func saveWeight(mesureUnits: String, value: Double) {
        let values = [
            "weightUnit": mesureUnits,
            "weight": value] as [String : Any]
        Service.shared.updateUserValues(values: values as [String : Any])
        UserService.refreshUser()
    }
    
    func saveHeight(mesureUnits: String, heightFirstUnit: Double, heightSecondUnit: Double) {
        
        let values = [
            "heightUnit": mesureUnits,
            "heightFirstUnit": heightFirstUnit,
            "heightSecondUnit": heightSecondUnit] as [String : Any]
        Service.shared.updateUserValues(values: values as [String : Any])
        UserService.refreshUser()
    }
    
    func saveGender(gender: String) {
        let values = ["gender":  gender] as [String : Any]
        Service.shared.updateUserValues(values: values as [String : Any])
        self.gender = gender
        UserService.refreshUser()
    }
    
    func saveActivity(activity: String) {
        let values = ["activity":  activity] as [String : Any]
        Service.shared.updateUserValues(values: values as [String : Any])
        self.activity = activity
        UserService.refreshUser()
    }
    
    func getWeight() {
        guard let weightUnit = user?.weightUnit else { return }
        guard let userWeight = user?.weight else { return }
        if weightUnit == "kg" {
            weight = String(userWeight / 1000)
        } else {
            let weigntInt = userWeight
            let stone = weigntInt / 14
            weight = String("\(stone)")
        }
    }
    
    func getHeight() {
        guard let heightMesureUnit = user?.heightMsureUnit else { return }
        guard let userheightFirstUnit = user?.heightFirstUnit else { return }
        guard let userheightSecondUnit = user?.heightSecondUnit else { return }
        
        if heightMesureUnit == "m" {
            height = String(userheightFirstUnit / 100)
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
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        guard let imageData = selectedImage.pngData() else { return }
        
        let userID = user?.uid
        imageStorage.child("\(String(describing: userID))/file.png").putData(imageData, metadata: nil) { _,  error in
            guard error == nil else {
                print("Failed to upload image")
                return
            }
            
            self.imageStorage.child("\(String(describing: userID))/file.png").downloadURL(completion: {url, error in
                guard let url = url, error == nil else {
                    return
                }
                let urlString = url.absoluteString
                
                let values = ["imageURL": urlString]
                Service.shared.updateUserValues(values: values )
                self.rerefreshController?()
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
            print("DEBUG: Success! Logged out!!!")
        } catch {
            debugPrint("Error Signing Out")
        }
    }
}

//=================================
// MARK: TemplateObserver
//=================================

extension ProfileSettingViewModel: UserServiceObserver {

    func userServiceUserUpdated(_ user: User?) {
        self.user = user
    }
}
