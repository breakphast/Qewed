//
//  AddSongViewModel.swift
//  Qewed
//
//  Created by Desmond Fitch on 5/28/22.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class AddSongViewModel: ObservableObject {
    private let songService = SongService()
    private let userService = UserService()
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @Published var songs = [Song]()
    
    init() {
        fetchCurrentUserSongsCount()
    }
    
    func createSong(albumArt: URL, artist: String, title: String, userDescription: String, genre: String, appleMusic: String, spotify: String, youtube: String, user: String, userID: String, userFullName: String
    ) {
        guard let uid = Firebase.Auth.auth().currentUser?.uid else { return }
        
        let songData = ["artist": artist, "albumArt": albumArt.absoluteString, "title": title, "genre": genre, "userDescription": userDescription, "appleMusic": appleMusic, "spotify": spotify, "youtube": youtube, "user": user, "userID" : uid, "userFullName" : userFullName, "timestamp": Timestamp(), "likes": 0] as [String : Any]
        
        Firestore.firestore().collection("allSongs").document(UUID().uuidString)
            .setData(songData) { err in
                if let err = err {
                    print(err)
                    return
                }
            }
        fetchCurrentUserSongsCount()
    }
    
    func persistImageToStorage(image: UIImage?, artist: String, title: String, userDescription: String, genre: String, appleMusic: String, spotify: String, youtube: String, user: String, userFullName: String) {
        fetchCurrentUserSongsCount()
        
        guard let uid = Firebase.Auth.auth().currentUser?.uid else { return }
        
        let ref = Firebase.Storage.storage().reference(withPath: "\(uid)-\(self.songs.count + 1)")
        
        guard let imageData = image?.jpegData(compressionQuality: 0.5) else { return }
        
        ref.putData(imageData, metadata: nil) { metadata, err in
            if let err = err {
                print(err)
                return
            }
            
            ref.downloadURL { url, err in
                if let err = err {
                    print(err)
                    return
                }
                
                guard let url = url else { return }
                self.createSong(albumArt: url, artist: artist, title: title, userDescription: userDescription, genre: genre, appleMusic: appleMusic, spotify: spotify, youtube: youtube, user: user, userID: uid, userFullName: userFullName)
            }
        }
    }
    
    private func fetchCurrentUserSongsCount() {
        songService.fetchSongs { songs in
            self.songs = songs
            for i in 0 ..< songs.count {
                self.userService.fetchUser(withUid: self.songs[i].userID) { user in
                    self.songs[i].songUser = user
                }
            }
        }
    }
}
