import Foundation

struct Post: Hashable, Equatable {
    let id: UUID
    let authorId: UUID
    var content: String
    var likes: Int
    var hashtags: Set<String>
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Post, rhs: Post) -> Bool {
        return lhs.id == rhs.id
    }
}
