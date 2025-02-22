import UIKit
import Foundation

class FeedViewController: UIViewController, UICollectionViewDelegate {
    private let viewModel: FeedSystem
    private let tableView = UITableView()
    private let hashtagFilterView = HashtagFilterView()
    
    init(viewModel: FeedSystem) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureHashtags()
        setupNavigationBar()
    }
    
    
    private func setupNavigationBar() {
        navigationItem.title = "Feed"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addPostTapped)
        )
    }
    
    @objc private func addPostTapped() {
        let postCreationVC = PostCreationViewController(viewModel: viewModel) { [weak self] post in
            self?.viewModel.addPost(post)
            self?.tableView.reloadData()
            self?.hashtagFilterView.configure(with: self?.viewModel.uniqueHashtags ?? [])
        }
        
        let nav = UINavigationController(rootViewController: postCreationVC)
        present(nav, animated: true)
    }

    private func configureHashtags() {
        hashtagFilterView.hashtagDelegate = self
        hashtagFilterView.configure(with: viewModel.uniqueHashtags)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
            
        view.addSubview(hashtagFilterView)
        hashtagFilterView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            hashtagFilterView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            hashtagFilterView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hashtagFilterView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hashtagFilterView.heightAnchor.constraint(equalToConstant: 50),
            
            tableView.topAnchor.constraint(equalTo: hashtagFilterView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PostCell.self, forCellReuseIdentifier: "PostCell")
    }
}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfPosts
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        let post = viewModel.getPost(at: indexPath.row)
        let profile = viewModel.getProfile(for: post)
        
        cell.configure(with: post, profile: profile, imageLoader: viewModel.imageLoader)
        
        cell.onDelete = { [weak self] in
            self?.viewModel.removePost(post)
            self?.tableView.reloadData()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = viewModel.getPost(at: indexPath.row)
        if let profile = viewModel.getProfile(for: post) {
            let profileVC = ProfileViewController(profile: profile, imageLoader: viewModel.imageLoader)
            navigationController?.pushViewController(profileVC, animated: true)
        }
    }
}


extension FeedViewController: HashtagFilterDelegate {
    func didSelectHashtag(_ hashtag: String?) {
        print("Selected hashtag: \(hashtag ?? "All")")
        viewModel.filterPosts(byHashtag: hashtag)
        tableView.reloadData()
    }
}

extension FeedViewController: ProfileUpdateDelegate {
    func profileDidUpdate(_ profile: UserProfile) {
        tableView.reloadData()
    }
    
    func profileLoadingError(_ error: Error) {
        let alert = UIAlertController(title: "Error",
                                    message: "Failed to load profile: \(error.localizedDescription)",
                                    preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}


