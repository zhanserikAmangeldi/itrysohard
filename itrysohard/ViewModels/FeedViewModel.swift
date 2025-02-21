import Foundation
import UIKit

class FeedViewModel {
    private var profiles: [UUID: UserProfile] = [:]
    private var posts: [Post] = []
    private var filteredPosts: [Post] = []
    private var currentHashtagFilter: String?
    
    let profileManager: ProfileManager
    let imageLoader: ImageLoader
    
    init(profileManager: ProfileManager, imageLoader: ImageLoader) {
        self.profileManager = profileManager
        self.imageLoader = imageLoader
        loadMockData()
    }
    
    private func loadMockData() {
        let mockUsers = (0...5).map { _ in UUID() }
        
        let possibleHashtags = ["travel", "lifestyle", "food", "adventure", "fitness", "tech", "nature", "music", "fashion", "art"]
        
        mockUsers.forEach { userId in
            profileManager.loadProfile(id: userId) { [weak self] result in
                if case .success(let profile) = result {
                    self?.profiles[userId] = profile
                }
            }
            
            (0...3).forEach { _ in
                let hashtagCount = Int.random(in: 1...3)
                let randomHashtags = Set(possibleHashtags.shuffled().prefix(hashtagCount))
                
                let post = Post(
                    id: UUID(),
                    authorId: userId,
                    content: "Sample post content " + randomHashtags.map { "#\($0)" }.joined(separator: " "),
                    likes: Int.random(in: 0...100),
                    hashtags: randomHashtags
                )
                posts.append(post)
            }
        }
        
        filteredPosts = posts
    }

    
    func filterPosts(byHashtag hashtag: String?) {
        currentHashtagFilter = hashtag
        if let hashtag = hashtag {
            filteredPosts = posts.filter { $0.hashtags.contains(hashtag) }
        } else {
            filteredPosts = posts
        }
    }

    
    func getPost(at index: Int) -> Post {
        return filteredPosts[index]
    }
    
    func getProfile(for post: Post) -> UserProfile? {
        return profiles[post.authorId]
    }
    
    var numberOfPosts: Int {
        return filteredPosts.count
    }
    
    var uniqueHashtags: Set<String> {
        return Set(posts.flatMap { $0.hashtags })
    }
}
