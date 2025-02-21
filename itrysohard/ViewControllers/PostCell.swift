import UIKit
import Foundation

class PostCell: UITableViewCell {
    private let profileImageView = UIImageView()
    private let usernameLabel = UILabel()
    private let contentLabel = UILabel()
    private let likesLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 20
        contentView.addSubview(profileImageView)
        
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.font = .boldSystemFont(ofSize: 16)
        contentView.addSubview(usernameLabel)
        
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.numberOfLines = 0
        contentView.addSubview(contentLabel)
        
        likesLabel.translatesAutoresizingMaskIntoConstraints = false
        likesLabel.textColor = .gray
        contentView.addSubview(likesLabel)
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            profileImageView.widthAnchor.constraint(equalToConstant: 40),
            profileImageView.heightAnchor.constraint(equalToConstant: 40),
            
            usernameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            usernameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8),
            usernameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            contentLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 8),
            contentLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
            contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            likesLabel.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 8),
            likesLabel.leadingAnchor.constraint(equalTo: contentLabel.leadingAnchor),
            likesLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with post: Post, profile: UserProfile?, imageLoader: ImageLoader) {
        contentLabel.text = post.content
        likesLabel.text = "\(post.likes) likes"
        
        if let profile = profile {
            usernameLabel.text = profile.username
            imageLoader.loadImage(url: profile.imageUrl) { [weak self] image in
                self?.profileImageView.image = image
            }
        }
    }
}
