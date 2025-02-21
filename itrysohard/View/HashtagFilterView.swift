import UIKit
import Foundation

protocol HashtagFilterDelegate: AnyObject {
    func didSelectHashtag(_ hashtag: String?)
}

class HashtagFilterView: UICollectionView {
    weak var hashtagDelegate: HashtagFilterDelegate?
    private var hashtags: [String] = []
    private var selectedHashtagIndex: Int = 0
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        
        super.init(frame: .zero, collectionViewLayout: layout)
        
        backgroundColor = .systemBackground
        delegate = self
        dataSource = self
        register(HashtagCell.self, forCellWithReuseIdentifier: "HashtagCell")
        showsHorizontalScrollIndicator = false
        
        isUserInteractionEnabled = true
        isScrollEnabled = true
        
        allowsSelection = true
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = CGSize(width: 100, height: 30)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with hashtags: Set<String>) {
        self.hashtags = Array(hashtags)
        reloadData()
    }
}


extension HashtagFilterView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hashtags.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HashtagCell", for: indexPath) as! HashtagCell
        
        if indexPath.item == 0 {
            cell.configure(with: "All", isSelected: selectedHashtagIndex == 0)
        } else {
            cell.configure(with: hashtags[indexPath.item - 1], isSelected: selectedHashtagIndex == indexPath.item)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedHashtagIndex = indexPath.item
        
        if indexPath.item == 0 {
            hashtagDelegate?.didSelectHashtag(nil)
        } else {
            hashtagDelegate?.didSelectHashtag(hashtags[indexPath.item - 1])
        }
        
        collectionView.reloadData()
    }
}



