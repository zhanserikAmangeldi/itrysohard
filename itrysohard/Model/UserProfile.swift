import Foundation

struct UserProfile: Hashable, Equatable {
    let id: UUID
    let username: String
    let imageUrl: URL
    var bio: String
    var followers: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: UserProfile, rhs: UserProfile) -> Bool {
        return lhs.id == rhs.id
    }
}
