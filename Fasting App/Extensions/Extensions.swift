//
//  Extensions.swift
//  Fasting App
//
//  Created by indre zibolyte on 25/01/2022.
//

import UIKit
import SDWebImage

extension UIView {
    
    
    func addShadow(color: UIColor? = UIColor.black.withAlphaComponent(0.3)) {
        layer.shadowColor = color?.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = .zero
        layer.shadowRadius = 15
    }
    
    func addShadow() {
        layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = .zero
        layer.shadowRadius = 20
    }
    
    func setBackgroundGradient(topColor: UIColor, bottomColor: UIColor) {
        let layer0 = CAGradientLayer()
        layer0.colors = [
          topColor.cgColor,
          bottomColor.withAlphaComponent(0).cgColor,
          topColor.cgColor,
        ]
        layer0.locations = [0, 1]
        layer0.startPoint = CGPoint(x: 0.15, y: 0.5)
        layer0.endPoint = CGPoint(x: 0.95, y: 0.5)
        layer0.transform = CATransform3DMakeAffineTransform(
            CGAffineTransform(
                a: 0,
                b: 0.72,
                c: -0.72,
                d: 0,
                tx: 1.86,
                ty: 0)
        )
        layer0.bounds = bounds.insetBy(
            dx: -0.5*frame.size.width,
            dy: -0.5*bounds.size.height
        )
        layer0.position = center
        layer.addSublayer(layer0)
    }
}

extension CAShapeLayer {

    class func create(strokeColor: UIColor, fillColor: UIColor, radius: CGFloat) -> CAShapeLayer {
        let circularPath = UIBezierPath(
            arcCenter: CGPoint(x: radius, y: radius),
            radius: radius,
            startAngle: -(.pi / 2),
            endAngle: 1.5 * .pi,
            clockwise: true
        )
        
        let layer = CAShapeLayer()
        layer.path = circularPath.cgPath
        layer.strokeColor = strokeColor.cgColor
        layer.lineWidth = 20
        layer.fillColor = fillColor.cgColor
        layer.lineCap = .round
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0.0, height: 0.1)
        
        return layer
    }
    
}


class ImageService {
    
    let manager = SDWebImageManager()
    
    static let shared = ImageService()
    
    static func fetchImage(
        urlString: String,
        completion: @escaping ((UIImage?, Error?) -> Void)) {
        
        guard let url = URL(string: urlString) else { return }
        
        DispatchQueue.global().async {
            shared.manager.loadImage(
                with: url,
                options: [],
                progress: nil) { (image, _, error, _, _, _) in
                
                DispatchQueue.main.async {
                    completion(image, error)
                }
            }
        }
    }
    
}

extension UIImageView {
    
    func fetchImage(url: String) {
        ImageService.fetchImage(urlString: url) { [weak self] (image, _) in
            self?.image = image
        }
    }
    
}

extension UIViewController {
    
    func setLargeTitleDisplayMode(_ largeTitleDisplayMode: UINavigationItem.LargeTitleDisplayMode) {
        switch largeTitleDisplayMode {
        case .automatic:
            guard let navigationController = navigationController else { break }
            if let index = navigationController.children.firstIndex(of: self) {
                setLargeTitleDisplayMode(index == 0 ? .always : .never)
            } else {
                setLargeTitleDisplayMode(.always)
            }
        case .always:
            navigationItem.largeTitleDisplayMode = largeTitleDisplayMode
            // Even when .never, needs to be true otherwise animation will be broken on iOS11, 12, 13
            navigationController?.navigationBar.prefersLargeTitles = true
        case .never:
            navigationController?.navigationBar.prefersLargeTitles = false
        @unknown default:
            assertionFailure("\(#function): Missing handler for \(largeTitleDisplayMode)")
        }
    }
    
}

extension AgePickerView: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ageArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(format: "%d", ageArray[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        age = ageArray[row]
    }
    
}

extension WeightPickerView: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        4
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch selectedUnit {
        case .kilograms:
            if component == 0 {
                return 1 //KG header
            } else if component == 1 {
                return kgArray.count //kilograms
            } else if component == 2 {
                return 1 //grams header
            } else {
                return gramsArray.count //grams
            }
        default:
            if component == 0 {
                return 1 //stone header
            } else if component == 1 {
                return 100 //stones
            } else if component == 2 {
                return 1 //pound header
            } else {
                return 15 //inches
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent componentKG: Int) -> String? {
        switch selectedUnit {
        case .kilograms:
            if componentKG == 0 {
                return "kg:" //header
            } else if componentKG == 1 {
                return String(format: "%d", kgArray[row]) //value
            } else if componentKG == 2 {
                return "g:" //header
            } else if componentKG == 3 {
                return String(format: "%d", gramsArray[row]) //value
            }
        default:
            if componentKG == 0 {
                return "st:" //header
            } else if componentKG == 1 {
                return String(format: "%d", stoneArray[row]) //value
            } else if componentKG == 2 {
                return "lbs:" //header
            } else if componentKG == 3 {
                return String(format: "%d", kgArray[row]) //value
            }
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch selectedUnit {
        case .kilograms:
            if component == 1 {
                kilograms = row * 1000
            } else {
                grams = row  * 100
            }
            totalPoundsEntered = 0
            totalGramsEntered = kilograms + grams
        default:
            if component == 1 {
                stones = row * 14
            } else {
                pounds = row
            }
            totalGramsEntered = 0
            totalPoundsEntered = stones + pounds
        }
    }
}

extension HeightPickerView: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        4
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if selectedUnits == "metrics" {
            if component == 0 {
               return 1 //meter header
            } else if component == 1 {
                return 3 //meters
            } else if component == 2 {
               return 1 //centimeters header
            } else {
               return 100 //days
            }
        } else {
            if component == 0 {
               return 1 //feet header
            } else if component == 1 {
                return 10 //feet
            } else if component == 2 {
               return 1 //inches header
            } else {
               return 12 //inches
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if selectedUnits == "metrics" {
            if component == 0 {
                return "m:" //header
            } else if component == 1 {
                return "\(row)" //value
            } else if component == 2 {
                return "cm:" //header
            } else if component == 3 {
                return "\(row)" //value
            }
        } else {
            if component == 0 {
                return "feet:" //header
            } else if component == 1 {
                return "\(row)" //value
            } else if component == 2 {
                return "inch:" //header
            } else if component == 3 {
                return "\(row)" //value
            }
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if selectedUnits == "metrics" {
            if component == 1 {
                meters = row
                firstUnit = Double(meters ?? 0)
            } else {
                centimeters = row
                secondUnit = Double(centimeters ?? 0)
            }
        } else {
            if component == 1 {
                feet = row
                firstUnit = Double(feet ?? 0)
            } else {
                inches = row
                secondUnit = Double(inches ?? 0)
            }
        }
    }
    
}

extension GenderPickerView: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderArray[row]
    }
    
    internal func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        gender = genderArray[row]
    }
}

extension ActivityPickerView: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return activityArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return activityArray[row]
    }
    
    internal func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        activity = activityArray[row]
        
    }
}






