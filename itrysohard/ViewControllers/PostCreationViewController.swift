import UIKit
import Foundation

class PostCreationViewController: UIViewController {
    private let userSelectionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select User", for: .normal)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 8
        button.contentHorizontalAlignment = .left
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        return button
    }()
    
    private let contentTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 16)
        textView.layer.borderColor = UIColor.systemGray4.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 8
        return textView
    }()
    
    private let hashtagsTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Add hashtags (separated by space)"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let userSelectionTableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.layer.cornerRadius = 8
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor.systemGray4.cgColor
        return tableView
    }()
    
    private var selectedUserId: UUID?
    private let viewModel: FeedSystem
    private let completion: (Post) -> Void
    
    init(viewModel: FeedSystem, completion: @escaping (Post) -> Void) {
        self.viewModel = viewModel
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
    }
    
    private func setupTableView() {
        userSelectionTableView.delegate = self
        userSelectionTableView.dataSource = self
        userSelectionTableView.register(UITableViewCell.self, forCellReuseIdentifier: "UserCell")
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "New Post"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelTapped)
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(doneTapped)
        )
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        userSelectionButton.addTarget(self, action: #selector(userSelectionTapped), for: .touchUpInside)
        
        [userSelectionButton, contentTextView, hashtagsTextField, userSelectionTableView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            userSelectionButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            userSelectionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            userSelectionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            userSelectionButton.heightAnchor.constraint(equalToConstant: 44),
            
            userSelectionTableView.topAnchor.constraint(equalTo: userSelectionButton.bottomAnchor, constant: 4),
            userSelectionTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            userSelectionTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            userSelectionTableView.heightAnchor.constraint(equalToConstant: 200),
            
            contentTextView.topAnchor.constraint(equalTo: userSelectionTableView.bottomAnchor, constant: 16),
            contentTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            contentTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            contentTextView.heightAnchor.constraint(equalToConstant: 200),
            
            hashtagsTextField.topAnchor.constraint(equalTo: contentTextView.bottomAnchor, constant: 16),
            hashtagsTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            hashtagsTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    @objc private func userSelectionTapped() {
        userSelectionTableView.isHidden.toggle()
    }
    
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }
    
    @objc private func doneTapped() {
        guard let userId = selectedUserId, !contentTextView.text.isEmpty else { return }
        
        let hashtags = hashtagsTextField.text?
            .components(separatedBy: " ")
            .filter { !$0.isEmpty }
            .map { $0.hasPrefix("#") ? String($0.dropFirst()) : $0 }
            ?? []
        
        let post = Post(
            id: UUID(),
            authorId: userId,
            content: contentTextView.text,
            likes: 0,
            hashtags: Set(hashtags)
        )
        
        completion(post)
        dismiss(animated: true)
    }
}

// MARK: - TableView DataSource & Delegate
extension PostCreationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getAllProfiles().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        let profile = viewModel.getAllProfiles()[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = profile.username
        content.secondaryText = "@\(profile.username)"
        cell.contentConfiguration = content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let profile = viewModel.getAllProfiles()[indexPath.row]
        selectedUserId = profile.id
        userSelectionButton.setTitle(profile.username, for: .normal)
        userSelectionTableView.isHidden = true
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
}
