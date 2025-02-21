import Foundation
import UIKit

class ProfileViewController: UIViewController {
    private let profile: UserProfile
    private let imageLoader: ImageLoader
    
    init(profile: UserProfile, imageLoader: ImageLoader) {
        self.profile = profile
        self.imageLoader = imageLoader
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = profile.username
        
        let profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 50
        view.addSubview(profileImageView)
        
        let bioLabel = UILabel()
        bioLabel.translatesAutoresizingMaskIntoConstraints = false
        bioLabel.text = profile.bio
        bioLabel.numberOfLines = 0
        view.addSubview(bioLabel)
        
        let followersLabel = UILabel()
        followersLabel.translatesAutoresizingMaskIntoConstraints = false
        followersLabel.text = "\(profile.followers) followers"
        view.addSubview(followersLabel)
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            
            bioLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20),
            bioLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            bioLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            followersLabel.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: 12),
            followersLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        imageLoader.loadImage(url: profile.imageUrl) { [weak profileImageView] image in
            profileImageView?.image = image
        }
    }
}
