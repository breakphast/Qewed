import Foundation
import FirebaseFirestoreSwift // so we can work with decodable through firebase code

struct User: Identifiable, Codable {
    @DocumentID var id: String? // reads document id and stores it in id property
    let email: String
    let password: String
    let username: String
    let imageProfileURL: String
    let fullName: String
    
    var following: Int
    var followers: Int
    
    var doesFollow: Bool? = false
}
