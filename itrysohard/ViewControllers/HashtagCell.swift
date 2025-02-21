import UIKit
import Foundation

class HashtagCell: UICollectionViewCell {
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        isUserInteractionEnabled = true
        
        backgroundColor = .systemBlue.withAlphaComponent(0.1)
        layer.cornerRadius = 15
        clipsToBounds = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .systemBlue
        label.font = .systemFont(ofSize: 14)
        contentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            contentView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func configure(with hashtag: String, isSelected: Bool) {
        label.text = "#\(hashtag)"
        if isSelected {
            backgroundColor = .systemBlue
            label.textColor = .white
        } else {
            backgroundColor = .systemBlue.withAlphaComponent(0.1)
            label.textColor = .systemBlue
        }
    }
}

