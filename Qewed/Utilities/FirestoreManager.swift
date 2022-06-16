////
////  FirestoreManager.swift
////  Qewed
////
////  Created by Desmond Fitch on 2/8/22.
////
//
//import Foundation
//import Firebase
//import FirebaseFirestore
//import FirebaseFirestoreSwift
//import FirebaseStorage
//import UIKit
//import FirebaseAuth
//import SwiftUI
//
//class FirestoreManager: ObservableObject {
//    @Published private(set) var songs: [Song] = []
//    @Published private(set) var users: [User] = []
//    @Published private(set) var userSongs: [Song] = []
//    @Published private(set) var artworks: [UIImage] = []
//    
//    let db = Firestore.firestore()
//    let auth: Auth
//    
//    @State var image: Image?
//    
//    @Published var userIDD = false
//    @Published var namee = ""
//    
//    let storage = Storage.storage()
//    let newRef = Storage.storage().reference(forURL: "gs://qewed-55010.appspot.com")
//    
//    let uid = Auth.auth().currentUser?.uid
//    
//    var isLoggedIn: Bool {
//        return uid != nil
//    }
//    
//    init() {
//        self.auth = Auth.auth()
//        getUsername()
//        userSongs = []
//        fetchAllSongs()
//        fetchAllUsers()
//        if isLoggedIn == true {
//            fetchUserSongs(userID: uid!)
//        }
//    }
//    
////    func getUserInfo(userID: String) {
////        let user \= db.collection("Users").document(userID)
////    }
//    
//    func getUsername() {
//        for user in users {
//            if user.id == Auth.auth().currentUser?.uid {
//                namee = user.username
//                print("yoooooooo\(namee)")
//            } else {
//                print("Noooooooooo")
//            }
//        }
//    }
//    
//    func fetchUserSongs(userID: String) {
//        self.userSongs = []
//        db.collection("Users").document(userID).collection("Songs").addSnapshotListener { querySnapshot, error in
//            guard let documents = querySnapshot?.documents else {
//                print("error")
//                return
//            }
//            
//            self.userSongs = documents.compactMap { document -> Song? in
//                do {
//                    let res = document.data()
//                    let id = res["id"] as! String
//                    let album = res["album"] as! String
//                    let artist = res["artist"] as! String
//                    let description = res["description"] as! String
//                    let title = res["title"] as! String
//                    let user = res["user"] as! String
//                    let appleMusic = res["appleMusic"] as! String
//                    let spotify = res["spotify"] as! String
//                    let youtube = res["youtube"] as! String
//                    
//                    let content = Song(album: album, artist: artist, description: description, id: id, title: title, appleMusic: appleMusic, spotify: spotify, youtube: youtube, user: user)
//                    
//                    return content
//                }
//            }
//        }
//    }
//    
//    func fetchAllSongs() {
//        db.collection("Songs").addSnapshotListener { querySnapshot, error in
//            guard let documents = querySnapshot?.documents else {
//                print("Error")
//                return
//            }
//            
//            self.songs = documents.compactMap { document -> Song? in
//                do {
//                    print(document.data())
//                    let res = document.data()
//                    let id = res["id"] as! String
//                    let album = res["album"] as! String
//                    let artist = res["artist"] as! String
//                    let description = res["description"] as! String
//                    let title = res["title"] as! String
//                    let user = res["user"] as! String
//                    let appleMusic = res["appleMusic"] as! String
//                    let spotify = res["spotify"] as! String
//                    let youtube = res["youtube"] as! String
//                    
//                    let content = Song(album: album, artist: artist, description: description, id: id, title: title, appleMusic: appleMusic, spotify: spotify, youtube: youtube, user: user)
//                    
//                    return content
//                }
//            }
//        }
//    }
//    
//    
//    
//    func fetchAllUsers() {
//        db.collection("Users").addSnapshotListener { querySnapshot, error in
//            guard let documents = querySnapshot?.documents else {
//                print("Error")
//                return
//            }
//            
//            self.users = documents.compactMap { document -> User? in
//                do {
//                    print(document.data())
//                    
//                    let res = document.data()
//                    let username = res["username"] as! String
//                    let email = res["email"] as! String
//                    let password = res["password"] as! String
//                    let id = res["id"] as! String
//                    
//                    let content = User(username: username, email: email, password: password, id: id)
//                    
//                    return content
//                }
//            }
//        }
//    }
//    
//    func getImg2(name: String, completion: @escaping (_ imgg: UIImage) -> Void) {
//        let storageRef = storage.reference()
//        let imageRef = storageRef.child("images/\(name)")
//        
//        _ = imageRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
//            if let error = error {
//                print(error.localizedDescription)
//            } else {
//                DispatchQueue.main.async {
//                    let image = UIImage(data: data!)
//                    if let imag = UIImage(data: data!) {
//                        completion(imag)
//                    }
//                    print("Data: \(data!)")
//                    print("succesfully downloaded \(image!)")
//                }
//            }
//        }
//    }
//    
//    func addImg(img: UIImage, name: String, id: String, userID: String) async {
//        let storageRef = storage.reference()
//        let artworkRef = storageRef.child("profilePics/\(name)")
//        
//        let data = img.jpegData(compressionQuality: 0.4)
//        
//        let metadata = StorageMetadata()
//        metadata.contentType = "image/jpg"
//        
//        let db = Firestore.firestore()
//        
//        let docRef = db.collection("Songs").document("\(id)")
//        let userSongsRef = db.collection("Users").document(userID).collection("Songs").document(id)
//        
//        DispatchQueue.main.async {
//            artworkRef.putData(data!, metadata: metadata) { (FIRStorageMetadata, err) in
//                if err != nil {
//                    print((err?.localizedDescription)!)
//                    return
//                }
//                
//                artworkRef.downloadURL(completion: { (url, error) in
//                    if let metaImageURL = url?.absoluteString {
//                        docRef.updateData(["album": metaImageURL])
//                        userSongsRef.updateData(["album": metaImageURL])
//                        print(metaImageURL)
//                    }
//                })
//                print("HEre it issssss \(data!)")
//                print("success bozbo")
//            }
//        }
//        
//    }
//    
//    func addSong(title: String, album: String, artist: String, id: String, description: String, user: String, appleMusic: String, spotify: String, youtube: String, userID: String) {
//        let db = Firestore.firestore()
//        
//        let docRef = db.collection("Songs").document("\(id)")
//        let userSongsRef = db.collection("Users").document(userID).collection("Songs").document(id)
//        
//        userSongsRef.setData(
//            [
//                "title": title,
//                "id": id,
//                "album": album,
//                "artist": artist,
//                "description": description,
//                "user": user,
//                "appleMusic": appleMusic,
//                "spotify": spotify,
//                "youtube": youtube
//            ]
//        ) { error in
//            if let error = error {
//                print("Error writing document: \(error)")
//            } else {
//                print("Document successfully written.")
//            }
//        }
//        
////        var userr: User
//        
//        
//        
//        docRef.setData(
//            [
//                "title": title,
//                "id": id,
//                "album": album,
//                "artist": artist,
//                "description": description,
//                "user": user,
//                "appleMusic": appleMusic,
//                "spotify": spotify,
//                "youtube": youtube
//            ]
//        ) { error in
//            if let error = error {
//                print("Error writing document: \(error)")
//            } else {
//                print("Document successfully written.")
//            }
//        }
//    }
//    
//    func addUser(username: String, email: String, password: String, id: String) {
//        let docRef = db.collection("Users").document("\(id)")
//        
//        docRef.setData(
//            [
//                "username": username,
//                "email": email,
//                "password": password,
//                "id": id
//            ]
//        ) { error in
//            if let error = error {
//                print("Error idiot \(error)")
//            } else {
//                print("User saved successfully.")
//            }
//        }
//    }
//    
//    func deleteSong(id: String) {
//        let db = Firestore.firestore()
//        db.collection("Songs").document(id).delete() { err in
//            if let err = err {
//                print("Error removing: \(err)")
//            } else {
//                print("Removed.")
//            }
//        }
//    }
//}
