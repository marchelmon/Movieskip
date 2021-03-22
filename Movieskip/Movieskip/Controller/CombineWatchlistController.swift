//
//  CombineWatchlistController.swift
//  Movieskip
//
//  Created by marchelmon on 2021-03-19.
//

import UIKit

private let cellIdentifier = "FriendCell"

class CombineWatchlistController: UIViewController {
    
    //MARK: - Properties
    
    private let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
    
    private var selectedFriends = [User]()
    
    private lazy var matchingResultsView = MatchingResultsView()
    private lazy var registerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 200))

    private let friendsLabel: UILabel = {
        let label = UILabel()
        label.text = "Friends"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    private let friendsTable: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        return table
    }()
    
    private let friendsView = UIView()
    
    private let matchButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        button.setTitle("Combine watchlists", for: .normal)
        button.layer.cornerRadius = 5
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(showMatchingResults), for: .touchUpInside)
        return button
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
    
    private let backFromResultsButton: UIButton = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30)
        let image = UIImage(systemName: "arrow.backward", withConfiguration: imageConfig)?.withTintColor(.black, renderingMode: .alwaysOriginal)
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(showFriendsView), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        friendsTable.delegate = self
        friendsTable.dataSource = self
        friendsTable.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        configureUI()
        configureAndDisplayFriends()
        
    }
    
    //MARK: - Actions
    
    @objc func handleDone() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleRegister() {
        
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Combine watchlist with friends"
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
        
        sceneDelegate.user == nil ? showRegisterContent() : showFriendsView()
        
    }
    
    func configureAndDisplayFriends() {
        if sceneDelegate.userFriends.count == 0 {
            guard let allUsers = sceneDelegate.allUsers else { return }
            guard let user = sceneDelegate.user else { return }

            user.friendIds.forEach { friendId in
                let friendIndex = allUsers.firstIndex { user -> Bool in
                    return user.uid == friendId
                }
                guard let index = friendIndex else { return }
                sceneDelegate.userFriends.append(allUsers[index])
            }
            sceneDelegate.userFriends = sceneDelegate.userFriends.sorted { $0.username.compare($1.username) == ComparisonResult.orderedAscending }
        }
        friendsTable.reloadData()
    }
    
    @objc func showFriendsView() {
        registerView.isHidden = true
        matchingResultsView.isHidden = true
        backFromResultsButton.isHidden = true
        friendsView.isHidden = false
        
        friendsView.addSubview(friendsLabel)
        friendsLabel.anchor(top: friendsView.topAnchor, left: friendsView.leftAnchor)
        
        friendsView.addSubview(matchButton)
        matchButton.anchor(left: friendsView.leftAnchor, bottom: friendsView.bottomAnchor, right: friendsView.rightAnchor, paddingBottom: 20, height: 45)
        
        friendsView.addSubview(friendsTable)
        friendsTable.anchor(top: friendsLabel.bottomAnchor, left: friendsView.leftAnchor, bottom: matchButton.topAnchor, right: friendsView.rightAnchor, paddingTop: 15, paddingBottom: 20)
        
        view.addSubview(friendsView)
        friendsView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: 20, paddingBottom: 30, paddingRight: 20)
        
    }
    
    func showRegisterContent() {
        matchingResultsView.isHidden = true
        backFromResultsButton.isHidden = true
        friendsView.isHidden = true
        registerView.isHidden = false
        
        registerView.addSubview(shouldRegisterText)
        shouldRegisterText.anchor(top: registerView.topAnchor, left: registerView.leftAnchor, right: registerView.rightAnchor, paddingTop: 30, paddingLeft: 20, paddingRight: 20)
        registerView.addSubview(registerButton)
        registerButton.centerX(inView: registerView)
        registerButton.anchor(top: shouldRegisterText.bottomAnchor, paddingTop: 20, width: 170)
        
        view.addSubview(registerView)
        registerView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 150, height: 200)
    }
    
    @objc func showMatchingResults() {
        friendsView.isHidden = true
        registerView.isHidden = true
        matchingResultsView.isHidden = false
        backFromResultsButton.isHidden = false
        
        matchingResultsView.friends = selectedFriends
        
        view.addSubview(backFromResultsButton)
        backFromResultsButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 20, paddingLeft: 20)
        
        view.addSubview(matchingResultsView)
        matchingResultsView.anchor(top: backFromResultsButton.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                   right: view.rightAnchor, paddingTop: 10, paddingLeft: 20, paddingBottom: 30, paddingRight: 20)
        
    }
    
}

extension CombineWatchlistController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sceneDelegate.user?.friendIds.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let friend = sceneDelegate.userFriends[indexPath.row]
        cell.selectionStyle = .none
        cell.textLabel?.text = friend.username
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let friend = sceneDelegate.userFriends[indexPath.row]
       
        if selectedFriends.contains(where: { return $0.uid == friend.uid }) {
            let friendIndex = selectedFriends.firstIndex { selectedFriend -> Bool in
                if selectedFriend.uid == friend.uid {
                    return true
                }
                return false
            }
            if let friendIndex = friendIndex { selectedFriends.remove(at: friendIndex) }
            cell?.accessoryType = .none
        } else {
            selectedFriends.append(friend)
            cell?.accessoryType = .checkmark
        }
        tableView.reloadData()
    }
    
}




