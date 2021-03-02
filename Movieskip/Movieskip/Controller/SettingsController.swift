//
//  UserController.swift
//  Movieskip
//
//  Created by marchelmon on 2021-02-26.
//

import UIKit
import Firebase

class SettingsController: UIViewController {
            
    //MARK: - Properties
        
    private let friendsView = FriendsView()
    private let profileView = ProfileView()
    
    private let friendsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Friends", for: .normal)
        button.setTitleColor(MAIN_COLOR, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(showFriends), for: .touchUpInside)
        return button
    }()
    
    private let profileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Profile", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(showProfile), for: .touchUpInside)
        return button
    }()
        
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        profileView.isHidden = true
        
        configureUI()
        
    }
    
    
    //MARK: - Actions
    
    @objc func handleDone() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func showFriends() {
        friendsView.isHidden = false
        profileView.isHidden = true
        
        friendsButton.setTitleColor(MAIN_COLOR, for: .normal)
        profileButton.setTitleColor(#colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1), for: .normal)
    }

    @objc func showProfile() {
        friendsView.isHidden = true
        profileView.isHidden = false
        
        profileButton.setTitleColor(MAIN_COLOR, for: .normal)
        friendsButton.setTitleColor(#colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1), for: .normal)
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        navigationItem.title = "Settings"
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
    
        let topButtonStack = UIStackView(arrangedSubviews: [UIView(), friendsButton, profileButton, UIView()])
        topButtonStack.backgroundColor = .white
        topButtonStack.distribution = .equalSpacing
        
        view.addSubview(topButtonStack)
        topButtonStack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, width: view.frame.width, height: 70)
        
        view.addSubview(friendsView)
        friendsView.anchor(top: topButtonStack.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
        
        view.addSubview(profileView)
        profileView.anchor(top: topButtonStack.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
    }
 
}

    

