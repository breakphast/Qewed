//
//  Song.swift
//  Qewed
//
//  Created by Desmond Fitch on 2/7/22.
//

import Foundation
import SwiftUI
import FirebaseStorage
import SDWebImageSwiftUI
import Firebase
import FirebaseFirestoreSwift


struct Song: Identifiable, Codable {
    @DocumentID var id: String?
    
    var albumArt, artist, title, userDescription, genre, appleMusic, spotify, youtube, user, userID, userFullName: String
    var likes: Int
    
    init(data: [String: Any]) {
        self.albumArt = data["albumArt"] as? String ?? ""
        self.artist = data["artist"] as? String ?? ""
        self.title = data["title"] as? String ?? ""
        self.userDescription = data["userDescription"] as? String ?? ""
        self.genre = data["genre"] as? String ?? ""
        self.appleMusic = data["appleMusic"] as? String ?? ""
        self.spotify = data["spotify"] as? String ?? ""
        self.youtube = data["youtube"] as? String ?? ""
        self.user = data["user"] as? String ?? ""
        self.userID = data["userID"] as? String ?? ""
        self.userFullName = data["userID"] as? String ?? ""
        self.likes = data["likes"] as? Int ?? 0
    }
    
    var songUser: User?
    var didLike: Bool? = false
}
