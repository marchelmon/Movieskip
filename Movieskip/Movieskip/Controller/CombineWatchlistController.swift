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
    
    
    let friendsTable: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        return table
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
    
    //MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Watchlist"
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
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
    
}

extension CombineWatchlistController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sceneDelegate.user?.friendIds.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let friend = sceneDelegate.userFriends[indexPath.row]
        
        cell.textLabel?.text = friend.username
        return cell
    }
    
}
