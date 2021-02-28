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
    
    var friends = [User]()
        
    private let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
    
    private let friendsTableView = UITableView(backgroundColor: .red)
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "\(sceneDelegate.user.username)"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        label.textColor = MAIN_COLOR
        return label
    } ()
    
    private let shouldRegisterText: UILabel = {
        let label = UILabel()
        label.text = "The main purpose of this app can only be available with an account. Read more... "
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        label.textColor = MAIN_COLOR
        return label
    } ()
    
    
    private var registerButton: UIButton = {
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
        
        let user1 = User(uid: "123", email: "sadas", username: "dsfdsf", watchlist: [], excluded: [], skipped: [], friends: [], profileImage: nil)
        friends.append(user1)
        friends.append(user1)
        friends.append(user1)
        friends.append(user1)
        friends.append(user1)
        friends.append(user1)
        friends.append(user1)
        friends.append(user1)
        friends.append(user1)
    
        configureUI()
        
        friendsTableView.delegate = self
        friendsTableView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    
    @objc func handleRegister() {
        print("Should present register")
    }
    
    @objc func handleLogout() {
        print("Logout ? ?? ? ?")
    }
    
    @objc func handleRestore() {
        print("Restore purchase!")
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        backgroundColor = .white
        
        if Auth.auth().currentUser != nil {
            addUserName()
            showFriendsTableView()
        } else {
            showRegisterContent()
        }
    }
    
    func showFriendsTableView() {
        
    }
    
    func addUserName() {
        
        addSubview(usernameLabel)
        
        usernameLabel.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20)
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
        return sceneDelegate.user.friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)! //as! CustomCell
        return cell
    }
}
