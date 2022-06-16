//
//  HomeViewModel.swift
//  Qewed
//
//  Created by Desmond Fitch on 5/28/22.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestoreSwift

class HomeViewModel: ObservableObject {
    @Published var isCurrentUserLoggedOut = false
    @Published var songs = [Song]()
    @Published var filteredSongs = [Song]()
    @Published var isShowingProfile = false
    
    private let service = SongService()
    private let uService = UserService()
    
    @Published var user: User
    @Published var currentUser: User?
    
    init(user: User) {
        self.user = user
        
        fetchSongs()
    }
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        uService.fetchUser(withUid: uid) { user in
            self.currentUser = user
        }
    }
    
    private func fetchSongs() {
        service.fetchSongs { songs in
            self.songs = songs
            for i in 0 ..< songs.count {
                self.uService.fetchUser(withUid: self.songs[i].userID) { user in
                    self.songs[i].songUser = user
                }
            }
        }
    }
    
    func fetchFilteredSongs(genre: String, completion: @escaping(Bool) -> Void) {
        service.fetchFilteredSongs(genre: genre) { filtered in
            self.filteredSongs = filtered
            for i in 0 ..< filtered.count {
                self.uService.fetchUser(withUid: self.songs[i].userID) { user in
                    self.filteredSongs[i].songUser = user
                }
            }
            
            completion(true)
        }
    }
}
