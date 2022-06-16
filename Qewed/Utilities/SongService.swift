//
//  SongService.swift
//  Qewed
//
//  Created by Desmond Fitch on 3/27/22.
//

import Firebase

struct SongService {
    
    func fetchSongs(completion: @escaping([Song]) -> Void) {
        Firestore.firestore()
            .collection("allSongs")
            .order(by: "timestamp")
            .getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                let songs = documents.compactMap({ try? $0.data(as: Song.self) })
                completion(songs)
            }
    }
    
    func fetchUserTweets(forUid uid: String, completion: @escaping([Song]) -> Void) {
        Firestore.firestore()
            .collection("allSongs")
            .whereField("userID", isEqualTo: uid)
            .getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                let songs = documents.compactMap({ try? $0.data(as: Song.self) })
                completion(songs)
            }
    }
    
    func fetchFilteredSongs(genre: String, completion: @escaping([Song]) -> Void) {
        Firestore.firestore()
            .collection("allSongs")
            .whereField("genre", isEqualTo: genre)
            .getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                let filteredSongs = documents.compactMap({ try? $0.data(as: Song.self) })
                completion(filteredSongs)
            }
    }
    
    func likeSong(_ song: Song, completion: @escaping() -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let userLikesRef = Firestore.firestore()
            .collection("users")
            .document(uid)
            .collection("user-likes")
        
        Firestore.firestore().collection("allSongs").document(song.id ?? "")
            .updateData(["likes": song.likes + 1]) { _ in
                userLikesRef.document(song.id!).setData(["artist": song.artist, "albumArt": String(song.albumArt), "title": song.title, "genre": song.genre, "userDescription": song.userDescription, "appleMusic": song.appleMusic, "spotify": song.spotify, "youtube": song.youtube, "user": song.user, "userID" : song.userID, "userFullName" : song.userFullName, "timestamp": Timestamp(), "likes": song.likes + 1] as [String : Any]) { _ in
                    completion()
                }
            }
    }
    
    func unlikeSong(_ song: Song, completion: @escaping() -> Void) {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            guard let songID = song.id else { return }
            guard song.likes > 0 else { return }
            
            let userLikesRef = Firestore.firestore().collection("users").document(uid).collection("user-likes")
            
            Firestore.firestore().collection("allSongs").document(songID)
                .updateData(["likes": song.likes - 1]) { _ in
                    userLikesRef.document(songID).delete { _ in
                        completion()
                    }
                }
        }
    
    func deleteSong(_ song: Song, completion: @escaping() -> Void) {
        guard let songID = song.id else { return }
        
        Firestore.firestore().collection("allSongs").document(songID).delete() { err in
            if let err = err {
                print(err)
            } else {
                return
            }
            
            
        }
    }
    
    func checkIfUserLikedSong(_ song: Song, completion: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("users")
            .document(uid)
            .collection("user-likes")
            .document(song.id ?? "")
            .getDocument { snapshot, _ in
                guard let snapshot = snapshot else { return }
                completion(snapshot.exists)
            }
    }
    
    func fetchUsersLikedSongs(withUID uid: String, completion: @escaping([Song]) -> Void) {
        var songs = [Song]()
        Firestore.firestore().collection("users")
            .document(uid)
            .collection("user-likes")
            .getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                documents.forEach { doc in
                    let songID = doc.documentID
                    
                    Firestore.firestore().collection("allSongs")
                        .document(songID)
                        .getDocument { snapshot, _ in
                            guard let song = try? snapshot?.data(as: Song.self) else { return }
                            songs.append(song)
                            
                            completion(songs)
                        }
                }
            }
    }
}
