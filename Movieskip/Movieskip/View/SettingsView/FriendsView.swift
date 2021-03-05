//
//  FriendsView.swift
//  Movieskip
//
//  Created by marchelmon on 2021-02-27.
//

import UIKit
import Firebase

private let cellIdentifier = "FriendsCell"

class FriendsView: UIView {
    
    //MARK: - Properties

    private let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
    
    var friends = [User]()
        
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Find friends"
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 15
        textField.layer.borderWidth = 2
        textField.layer.borderColor = MAIN_COLOR.cgColor
        textField.leftViewMode = .always
        let leftView = UIView()
        leftView.setDimensions(height: 30, width: 38)
        let leftViewImage = UIImageView(image: UIImage(systemName: "magnifyingglass")?.withTintColor(MAIN_COLOR, renderingMode: .alwaysOriginal))
        leftViewImage.setDimensions(height: 28, width: 28)
        leftView.addSubview(leftViewImage)
        leftViewImage.anchor(left: leftView.leftAnchor, paddingLeft: 5)
        textField.leftView = leftView
        return textField
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .systemGroupedBackground
        table.layer.cornerRadius = 5
        return table
    }()
    
    private let shouldRegisterText: UILabel = {
        let label = UILabel()
        label.text = "The main purpose of this app can only be available with an account. Read more... "
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        label.textColor = MAIN_COLOR
        return label
    } ()
        
    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(MAIN_COLOR, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 3
        button.layer.borderColor = MAIN_COLOR.cgColor
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()

    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        let user1 = User(dictionary: ["uid": "dasdasdad"])
        
        for i in 0...12 {
            sceneDelegate.addToExcluded(movie: i)
            sceneDelegate.addToWatchlist(movie: i)
            friends.append(user1)

        }
    
        configureUI()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FriendCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    
    @objc func handleRegister() {
        print("Should present register")
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        backgroundColor = .systemGroupedBackground
        
        if AuthService.userIsLoggedIn() {
            showFriendsView()
        } else {
            showRegisterContent()
        }
    }
    
    //MARK: - Helpers
    
    func showFriendsView() {
        addSubview(searchTextField)
        searchTextField.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 25, paddingRight: 25, height: 40)
        
        let friendsLabel = UILabel()
        friendsLabel.text = "Friends"
        friendsLabel.font = UIFont.boldSystemFont(ofSize: 18)
        addSubview(friendsLabel)
        friendsLabel.anchor(top: searchTextField.bottomAnchor, left: leftAnchor, paddingTop: 20, paddingLeft: 20)
        
        addSubview(tableView)
        tableView.anchor(top: friendsLabel.bottomAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: rightAnchor, paddingTop: 10,paddingLeft: 20, paddingBottom: 30, paddingRight: 20)
    }
    
    func createCountLabel(count: Int) -> UILabel {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = MAIN_COLOR
        label.text = String(count)
        return label
    }
    
    func showRegisterContent() {
        let registerView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 200))
        registerView.backgroundColor = .white
        registerView.addSubview(shouldRegisterText)
        shouldRegisterText.anchor(top: registerView.topAnchor, left: registerView.leftAnchor, right: registerView.rightAnchor, paddingTop: 30, paddingLeft: 20, paddingRight: 20)
        registerView.addSubview(registerButton)
        registerButton.centerX(inView: registerView)
        registerButton.anchor(top: shouldRegisterText.bottomAnchor, paddingTop: 20, width: 170)
        
        addSubview(registerView)
        registerView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 150, height: 200)
    }
    
}

extension FriendsView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! FriendCell
        let friend = friends[indexPath.row]
    
        cell.usernameLabel.text = friend.username
        cell.watchlistCount.text = String(friend.watchListCount)
        cell.excludeCount.text = String(friend.excludedCount)
        return cell
    }
}
