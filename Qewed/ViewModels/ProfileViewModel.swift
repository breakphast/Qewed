//
//  ProfileViewModel.swift
//  Qewed
//
//  Created by Desmond Fitch on 5/22/22.
//

import Foundation
import SwiftUI
import FirebaseAuth
import Firebase

class ProfileViewModel: ObservableObject {
    @Published var songs = [Song]()
    @Published var likedSongs = [Song]()
    @Published var following = [User]()
    @Published var followers = [User]()
    
    @Published var contextMenuLabels = ["Delete", "User", "Like", "Apple Music", "Spotify", "YouTube"]
    @Published var contextMenuImages = ["trash", "person", "heart", "apple_music", "spotify", "youtube"]
    
    let service = SongService()
    let userService = UserService()
    @Published var user: User
    
    @Published var currentUser: User?
    
    init(user: User) {
        self.user = user
        
        self.fetchUser()
        self.fetchUserSongs()
        self.fetchLikedSongs()
        self.fetchFollowing()
        self.fetchFollowers()
        self.checkIfUserFollows()
    }
    
    func checkIfUserLikedSong(song: Song) {
        service.checkIfUserLikedSong(song) { bool in
            
        }
    }
    
    func updateUsername(username: String, completion: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let data: [String: Any] = ["username": username]
         
        Firestore.firestore().collection("users")
            .document(uid)
            .updateData(data) { _ in
                for i in 0 ..< self.songs.count {
                    self.songs[i].user = username
                }
                completion(false)
            }
        
    }
    
    func updateFullName(fullName: String, completion: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let data: [String: Any] = ["fullName": fullName]
         
        Firestore.firestore().collection("users")
            .document(uid)
            .updateData(data) { _ in
                for i in 0 ..< self.songs.count {
                    self.songs[i].userFullName = fullName
                }
                completion(false)
            }
    }
    
    func updateProfile(username: String, fullName: String, completion: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let data: [String: Any] = ["username": username, "fullName": fullName]
         
        Firestore.firestore().collection("users")
            .document(uid)
            .updateData(data) { _ in
                for i in 0 ..< self.songs.count {
                    self.songs[i].userFullName = fullName
                    self.songs[i].user = username
                }
                completion(false)
            }
    }
    
    func followUser() {
        if Auth.auth().currentUser?.uid == user.id {
            return
        }
        
        userService.followUser(user, user2: currentUser!) {
            self.user.doesFollow = true
            self.fetchFollowers()
            self.fetchFollowing()
            self.fetchUser()
            
            print(self.user.fullName)
            print(self.currentUser?.fullName ?? "Um who dis")
        }
    }
    
    func unfollowUser() {
        if Auth.auth().currentUser?.uid == user.id {
            return
        }
        
        userService.unfollowUser(user, user2: currentUser!) {
            self.user.doesFollow = false
            self.fetchFollowers()
            self.fetchFollowing()
            self.fetchUser()
            
            print(self.user.fullName)
            print(self.currentUser?.fullName ?? "Um who dis")
        }
    }
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        userService.fetchUser(withUid: uid) { user in
            self.currentUser = user
        }
    }
    
    func fetchUserSongs() {
        guard let uid = user.id else { return }
        
        service.fetchUserTweets(forUid: uid) { songs in
            self.songs = songs
            
            for i in 0 ..< songs.count {
                self.songs[i].songUser = self.user
            }
        }
    }
    
    func fetchLikedSongs() {
        guard let uid = user.id else { return }

        service.fetchUsersLikedSongs(withUID: uid) { songs in
            self.likedSongs = songs
            
            for i in 0 ..< songs.count {
                let uid = songs[i].userID
                self.userService.fetchUser(withUid: uid) { user in
                    self.likedSongs[i].songUser = user
                }
            }
        }
    }
    
    func unlikeSong(song: Song) {
        service.unlikeSong(song) {
            self.fetchLikedSongs()
        }
    }
    
    func fetchFollowing() {
        guard let uid = user.id else { return }
        
        userService.fetchFollowing(withUID: uid) { users in
            self.following = users
        }
    }
    
    func fetchFollowers() {
        guard let uid = user.id else { return }
        
        userService.fetchFollowers(withUID: uid) { users in
            self.followers = users
        }
    }
    
    func checkIfUserFollows() {
        userService.checkIfUserFollows(user) { doesFollow in
            if doesFollow {
                self.user.doesFollow = true
            } else {
                self.user.doesFollow = false
            }
        }
    }
    
    func deleteSong(song: Song) {
        service.deleteSong(song) {
            
        }
    }
    
    func songs(forFilter filter: SongFilterViewModel) -> [Song] {
        switch filter {
        case.likes:
            return likedSongs
        default:
            return songs
        }
    }
}
