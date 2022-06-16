//
//  ListedSongViewModel.swift
//  Qewed
//
//  Created by Desmond Fitch on 6/7/22.
//

import Foundation
import SwiftUI
import FirebaseAuth
import Firebase

class ListedSongViewModel: ObservableObject {
    let userService = UserService()
    let service = SongService()
    
    @Published var user: User
    @Published var currentUser: User?
    @Published var liked: Bool?
    
    init(user: User, song: Song) {
        self.user = user
        
        self.fetchUser()
        
        self.checkIfLiked(song: song)
    }
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        userService.fetchUser(withUid: uid) { user in
            self.currentUser = user
        }
    }
    func deleteSong(song: Song) {
        service.deleteSong(song) {
            
        }
    }
    
    func checkIfLiked(song: Song) {
        service.checkIfUserLikedSong(song) { bool in
            self.liked = bool
        }
    }
    
    func likeSong(song: Song) {
        service.likeSong(song) {
            
        }
    }
    
    func unlikeSong(song: Song) {
        service.unlikeSong(song) {
            
        }
    }
}
