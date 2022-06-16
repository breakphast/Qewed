//
//  UserService.swift
//  Qewed
//
//  Created by Desmond Fitch on 3/23/22.
//

import Firebase
import FirebaseFirestoreSwift

struct UserService {
    
    func fetchUser(withUid uid: String, completion: @escaping(User) -> Void) {
        Firestore.firestore().collection("users")
            .document(uid)
            .getDocument { snapshot, _ in
                guard let snapshot = snapshot else { return }
                guard let user = try? snapshot.data(as: User.self) else { return } // can throw an error which is why we use try?
                completion(user) 
            }
    }
    
    func fetchUsers(completion: @escaping([User]) -> Void) {
        Firestore.firestore()
            .collection("users")
            .order(by: "fullName")
            .getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                let users = documents.compactMap({ try? $0.data(as: User.self) })
                
                completion(users)
            }
    }
    
    func fetchFollowing(withUID uid: String, completion: @escaping([User]) -> Void) {
        var following = [User]()
        Firestore.firestore()
            .collection("users")
            .document(uid)
            .collection("following")
            .getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                documents.forEach { doc in
                    let userID = doc.documentID
                
                    Firestore.firestore().collection("users")
                        .document(userID)
                        .getDocument { snapshot, _ in
                            guard let user = try? snapshot?.data(as: User.self) else { return }
                            
                            following.append(user)
                            
                            completion(following)
                        }
                    }
            }
    }
    
    func fetchFollowers(withUID uid: String, completion: @escaping([User]) -> Void) {
        var followers = [User]()
        Firestore.firestore()
            .collection("users")
            .document(uid)
            .collection("followers")
            .getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                documents.forEach { doc in
                    let userID = doc.documentID
                
                    Firestore.firestore().collection("users")
                        .document(userID)
                        .getDocument { snapshot, _ in
                            guard let user = try? snapshot?.data(as: User.self) else { return }
                            
                            followers.append(user)
                            
                            completion(followers)
                        }
                    }
            }
    }
    
    func checkIfUserFollows(_ user: User, completion: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("users")
            .document(uid)
            .collection("following")
            .document(user.id ?? "")
            .getDocument { snapshot, _ in
                guard let snapshot = snapshot else { return }
                completion(snapshot.exists)
            }
    }
    
    func followUser(_ user: User, user2: User, completion: @escaping() -> Void) {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        
        guard let followedUserID = user.id else { return }
        
        let followingRef = Firestore.firestore()
            .collection("users")
            .document(currentUserID)
            .collection("following")
        
        let followersRef = Firestore.firestore()
            .collection("users")
            .document(followedUserID)
            .collection("followers")
        
        Firestore.firestore().collection("users").document(currentUserID)
            .updateData(["following": user2.following + 1]) { _ in
                followingRef.document(followedUserID).setData([:]) { _ in
                    completion()
                }
            }
        
        Firestore.firestore().collection("users").document(followedUserID)
            .updateData(["followers": user.followers + 1]) { _ in
                followersRef.document(currentUserID).setData([:]) { _ in
                    completion()
                }
            }
    }
    
    func unfollowUser(_ user: User, user2: User, completion: @escaping() -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("NO CURRENT USER")
            return
        }
        guard let userID = user.id else {
            print("NO USER ID")
            return
        }
        
        let followingRef = Firestore.firestore()
            .collection("users")
            .document(uid)
            .collection("following")
        
        let followersRef = Firestore.firestore()
            .collection("users")
            .document(userID)
            .collection("followers")
        
        Firestore.firestore().collection("users")
            .document(uid)
            .updateData(["following": user2.following - 1]) { _ in
                followingRef.document(userID).delete { _ in
                    print("\(user.username) unfollowed and removed from \(user2.username)'s Following")
                    completion()
                }
                print("Updated following data...")
            }
        
        Firestore.firestore().collection("users")
            .document(userID)
            .updateData(["followers": user.followers - 1]) { _ in
                followersRef.document(uid).delete { _ in
                    print("\(user2.username) removed from \(user.username)'s Followers")
                    completion()
                }
                print("Updated followers data...")
            }
    }
}
