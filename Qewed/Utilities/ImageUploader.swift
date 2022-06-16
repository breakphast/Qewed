//
//  ImageUploader.swift
//  Qewed
//
//  Created by Desmond Fitch on 3/23/22.
//

import Firebase
import UIKit

struct ImageUploader {
    static func uploadImage(image: UIImage, completion: @escaping(String) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
//        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/profile_image/\(uid)")
        
        ref.putData(imageData, metadata: nil) { _, err in
            if let err = err {
                print("\(err)")
                return
            }
            
            ref.downloadURL { imageURL, _ in
                guard let imageURL = imageURL?.absoluteString else { return }
                completion(imageURL)
            }
        }
    }
}
