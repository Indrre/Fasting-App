//
//  ImageService.swift
//  Fasting App
//
//  Created by indre zibolyte on 25/03/2022.
//

import Foundation
import SDWebImage

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
