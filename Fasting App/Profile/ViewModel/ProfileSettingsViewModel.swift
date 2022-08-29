//
//  ProfileSettingsViewModel.swift
//  Fasting App
//
//  Created by indre zibolyte on 31/01/2022.
//

import Foundation
import UIKit
import FirebaseStorage

class ProfileSettingViewModel: NSObject, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    // =============================================
    // MARK: Properties
    // =============================================
    
    private let imageStorage = Storage.storage().reference()
    
    var age: Int?
    var height: String?
    var heightUnit: String?
    var gender: String?
    var activity: String?
    var newAge: Int?
    
    var weightString: String = "0"
    
    var data: [Weight?] {
        return WeightService.data
            .sorted(by: { $0.date ?? .today > $1.date ?? .today })
    }

    var user: User? {
        didSet {
            fetchUserImage()
            getHeight()
            getWeight()
            refreshController?()
        }
    }
        
    var currentWeight: Weight? {
        didSet {
//            getWeight()
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
            weight: weightString,
            height: String(height  ?? "0") + (user?.heightMsureUnit ?? ""),
            gender: user?.gender ?? "Female",
            activity: user?.activity ?? "Inactive ",
            callback: { [weak self] in
                self?.showActionSheetController()
            },
            presentController: {  [weak self] type in
                self?.presentPickerView(type: type)
            }
        )
    }
    
    // =================================
    // MARK: Callbacks
    // =================================
    
    var refreshController: (() -> Void)?
    var presentActionSheet: ((UIViewController) -> Void)?
    var presentNameEditController: ((UIViewController) -> Void)?
    var presentImageEditController: ((UIViewController) -> Void)?
    var presentPickerController: ((UIViewController) -> Void)?
    var presentController: ((_ type: PersonalInfo) -> Void)?
    var presentLogin: ((UIViewController) -> Void)?
    var presentSettings: ((UIViewController) -> Void)?
    
    // =============================================
    // MARK: Helpers
    // =============================================
    
    func viewDidLoad() {
        WeightService.start()
        WeightService.fetchAllWeight()
        WeightService.startObservingWeight(self)
        getWeight()
        getHeight()
        UserService.startObservingUser(self)
        UserService.refreshUser()
        refreshController?()
    }
    
    func getWeight() {
        var currentWeight: Weight?
          
        guard
            data.count > 0,
            let weight = data[0] else { return }
        
        currentWeight = weight
        if data.count >= 2 {
            if data[0]?.count == 0 {
                currentWeight = data[1]
            }
        }
        
        guard let weightUnit = currentWeight?.unit else { return }
        guard let userWeight = currentWeight?.count else { return }
        
        if weightUnit == "kg" {
            let calculations = Double(userWeight) / Double(1000)
            
            let label = String(format: "%.1f", calculations)
            weightString = "\(label)kg"
        } else {
            
            var pounds = (Double(userWeight) * 0.00220462)
            var numberOfStones = 0.0
            while pounds > 14 {
                pounds -= 14
               numberOfStones += 1
            }
            let numbetOfPounds = pounds.rounded()
            weightString = "\(Int(numberOfStones))st \(Int(numbetOfPounds))lb"
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
        presentImageEditController?(imagePicker)
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
            UserService.refreshUser()
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
    func weightServiceCurrentWeightUpdated(_ weight: Weight?) {
        self.currentWeight = weight
    }
    
    func weightServiceAllWeightUpdated() {
        refreshController?()
    }
}
