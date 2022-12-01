//
//  ImageViewExtension.swift
//  iteam_ny
//
//  Created by 김하늘 on 2022/05/01.
//

import Foundation
import Kingfisher
import FirebaseStorage

extension UIImageView {
    func setImage(with urlString: String) {
    
        let cache = ImageCache.default
        cache.retrieveImage(forKey: urlString, options: nil) { _ in
            if let image = self.image {
                self.image = image
            } else {
                let storage = Storage.storage()
                storage.reference(forURL: urlString).downloadURL { (url, error) in
                    if let error = error {
                        print("An error has occured: \(error.localizedDescription)")
                        return
                    }
                    guard let url = url else {
                        return
                    }
                    self.kf.setImage(with: url)
                }
            }
        }
    }
}

func setImage(with urlString: String) -> URL {
    
    let cache = ImageCache.default
    var imageUrl: URL = URL(string: "")!
    cache.retrieveImage(forKey: urlString, options: nil) { _ in
        
        let storage = Storage.storage()
        storage.reference(forURL: urlString).downloadURL { (url, error) in
            if let error = error {
                print("An error has occured: \(error.localizedDescription)")
                return
            }
            guard let url = url else {
                return
            }
            imageUrl = url
        }
        
    }
    return imageUrl
}
