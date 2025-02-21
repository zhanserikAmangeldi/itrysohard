import UIKit
import Foundation

class ProfileManager {
    private var activeProfiles: [UUID: UserProfile] = [:]
    
    weak var delegate: ProfileUpdateDelegate?
    
    var onProfileUpdate: ((UserProfile) -> Void)?
    
    init(delegate: ProfileUpdateDelegate? = nil) {
        self.delegate = delegate
    }
    
    func loadProfile(id: UUID, completion: @escaping (Result<UserProfile, Error>) -> Void) {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            
            let profile = UserProfile(
                id: id,
                username: "user_\(id.uuidString.prefix(4))",
                imageUrl: URL(string: "https://picsum.photos/\(Int.random(in: 1...100))")!,
                bio: "Sample bio",
                followers: Int.random(in: 100...1000)
            )
            
            DispatchQueue.main.async {
                self.activeProfiles[id] = profile
                completion(.success(profile))
                self.delegate?.profileDidUpdate(profile)
            }
        }
    }
}
