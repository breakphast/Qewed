//
//  AuthViewModel.swift
//  Qewed
//
//  Created by Desmond Fitch on 3/23/22.
//

import SwiftUI
import Firebase

class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User? = nil
    @Published var didAuthenticateUser = false
    @Published var currentUser: User? // optional because we have to reach out to our api to get data before we set it so it will originally be nil... app launches before we fetch the data
    
    private let service = UserService()
    
    private var tempUserSession: FirebaseAuth.User?
    
    let auth = Auth.auth()
    
    init() {
        self.userSession = Auth.auth().currentUser
        self.fetchUser() // from auth view model
    }
    
    func fetchUser() {
        guard let uid = self.userSession?.uid else { return } // always current user
        
        service.fetchUser(withUid: uid) { user in
            self.currentUser = user // sets published user to user we fetched from database
        }
    }
    
    func login(withEmail email: String, password: String, username: String) {
        auth.signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Failed to sign in: \(error)")
                return
            }
            
            guard let user = result?.user else { return }
            self.userSession = user
            self.fetchUser()
            
            print("Successfully logged in user.")
        }
    }
    
    func register(withEmail email: String, password: String, username: String, fullName: String) {
        auth.createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Failed to register: \(error)")
                return
            }
            
            guard let user = result?.user else { return }
            self.tempUserSession = user
            
            let data: [String: Any] = ["email": email,
                        "password": password,
                        "username": username.lowercased(),
                        "fullName": fullName,
                        "followers": 0,
                        "following": 0
                        ]
            
            Firestore.firestore().collection("users")
                .document(user.uid)
                .setData(data) { _ in
                    self.didAuthenticateUser = true
                    print("Set to true")
                }
        }
        
    }
    
    func signOut() {
        userSession = nil
        try? auth.signOut()
    }
    
    func uploadProfileImage(_ image: UIImage) {
        guard let uid = tempUserSession?.uid else { return }
        
        ImageUploader.uploadImage(image: image) { profileImageURL in
            Firestore.firestore().collection("users")
                .document(uid)
                .updateData(["imageProfileURL": profileImageURL]) { _ in
                    self.userSession = self.tempUserSession
                    self.fetchUser()
                }
        }
    }
    
    func updateProfileImage(_ image: UIImage, completion: @escaping() -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        ImageUploader.uploadImage(image: image) { profileImageURL in
            Firestore.firestore().collection("users")
                .document(uid)
                .updateData(["imageProfileURL": profileImageURL]) { _ in
                    completion()
                }
        }
    }
    
}
