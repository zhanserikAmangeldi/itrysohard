    import Foundation
    import UIKit

    class FeedSystem {
        private var userCache: [UUID: UserProfile] = [:]
        private var feedPosts: [Post] = []
        private var hashtags: Set<String> = []
        private var filteredPosts: [Post] = []
        private var currentHashtagFilter: String?
        
        let profileManager: ProfileManager
        let imageLoader: ImageLoader
        
        var onFeedUpdate: (() -> Void)?
        
        init(profileManager: ProfileManager, imageLoader: ImageLoader) {
            self.profileManager = profileManager
            self.imageLoader = imageLoader
            loadMockData()
        }
        
        private func loadMockData() {
            let mockUsers = (0...5).map { _ in UUID() }
            let possibleHashtags = ["travel", "food", "fitness", "nature", "technology", "music", "fashion", "gaming", "art", "books"]

            mockUsers.forEach { userId in
                profileManager.loadProfile(id: userId) { [weak self] result in
                    if case .success(let profile) = result {
                        self?.cacheUser(profile)
                    }
                }
                
                (0...3).forEach { _ in
                    let selectedHashtags = Set(possibleHashtags.shuffled().prefix(Int.random(in: 1...3))) // Pick 1 to 3 hashtags randomly
                    
                    let post = Post(
                        id: UUID(),
                        authorId: userId,
                        content: "Sample post content #" + selectedHashtags.joined(separator: " #"),
                        likes: Int.random(in: 0...100),
                        hashtags: selectedHashtags
                    )
                    addPost(post)
                }
            }
        }
    
        func addPost(_ post: Post) {
            feedPosts.insert(post, at: 0)
            hashtags.formUnion(post.hashtags)
            updateFilteredPosts()
            onFeedUpdate?()
        }
        
        func removePost(_ post: Post) {
            if let index = feedPosts.firstIndex(where: { $0.id == post.id }) {
                feedPosts.remove(at: index)
                refreshHashtags()
                updateFilteredPosts()
                onFeedUpdate?()
            }
        }
        
        private func refreshHashtags() {
            hashtags.removeAll()
            feedPosts.forEach { hashtags.formUnion($0.hashtags) }
        }
        
        func filterPosts(byHashtag hashtag: String?) {
            currentHashtagFilter = hashtag
            updateFilteredPosts()
        }
        
        private func updateFilteredPosts() {
            filteredPosts = getFilteredPosts(byHashtag: currentHashtagFilter)
        }
        
        func getFilteredPosts(byHashtag hashtag: String?) -> [Post] {
            guard let hashtag = hashtag else { return feedPosts }
            return feedPosts.filter { $0.hashtags.contains(hashtag) }
        }
        
        func getPost(at index: Int) -> Post {
            return filteredPosts[index]
        }
        
        func cacheUser(_ profile: UserProfile) {
            userCache[profile.id] = profile
        }
        
        func getUser(id: UUID) -> UserProfile? {
            return userCache[id]
        }
        
        func getProfile(for post: Post) -> UserProfile? {
            return self.getUser(id: post.authorId)
        }
        
        var numberOfPosts: Int {
            return filteredPosts.count
        }
        
        var uniqueHashtags: Set<String> {
            return hashtags
        }
        
        func getFirstUserId() -> UUID {
            return filteredPosts[0].authorId
        }
        
        func getAllProfiles() -> [UserProfile] {
            return Array(profileManager.getActiveProfiles().values)
        }
    }
