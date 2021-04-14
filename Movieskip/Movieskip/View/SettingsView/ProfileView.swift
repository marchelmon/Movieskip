//
//  ProfileView.swift
//  Movieskip
//
//  Created by marchelmon on 2021-02-28.
//

import UIKit
import Firebase


protocol SettingsProfileDelegate: class {
    func handleLogout()
    func profileViewGoToRegister()
}

class ProfileView: UIView {
    
    //MARK: - Properties
        
    let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
    
    weak var delegate: SettingsProfileDelegate?
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "\(sceneDelegate.user?.username ?? "John Doe") "
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = K.MAIN_COLOR
        return label
    } ()
    
    private let userStatsView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let tmdbImage: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "tmdb-logo").withRenderingMode(.alwaysOriginal)
        iv.contentMode = .scaleAspectFill
        return iv
    } ()
    
    private let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.backgroundColor = .white
        button.layer.borderWidth = 1
        button.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        return button
    }()
    
    private var restoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Restore purchase", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.backgroundColor = .white
        button.layer.borderWidth = 1
        button.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        button.addTarget(self, action: #selector(handleRestore), for: .touchUpInside)
        return button
    }()
    
    private let shouldRegisterView = ShouldRegisterView()
    
    lazy var watchlistCountLabel = createCountLabel(count: sceneDelegate.user?.watchListCount ?? 0)
    lazy var excludedCountLabel = createCountLabel(count: sceneDelegate.user?.excludedCount ?? 0)
    lazy var friendsCountLabel = createCountLabel(count: sceneDelegate.user?.friendIds.count ?? 0)

    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    
        shouldRegisterView.delegate = self
        
        configureUI()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    
    @objc func handleRegister() {
        delegate?.profileViewGoToRegister()
    }
    
    @objc func handleLogout() {
        delegate?.handleLogout()
    }
    
    @objc func handleRestore() {
        print("Restore purchase!")
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        backgroundColor = .white
        
        Auth.auth().currentUser != nil ? addUserData() : showRegisterContent()
        
        addLogoutAndRestore()
        addTmdbAttribution()
    }
    
    func createCountLabel(count: Int) -> UILabel {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = K.MAIN_COLOR
        label.text = String(count)
        return label
    }
    
    func addUserData() {
        addSubview(userStatsView)
        userStatsView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 200)
        
        userStatsView.addSubview(usernameLabel)
        userStatsView.addSubview(watchlistCountLabel)
        userStatsView.addSubview(excludedCountLabel)
        userStatsView.addSubview(friendsCountLabel)
        
        usernameLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 5, paddingLeft: 20)
        watchlistCountLabel.anchor(top: usernameLabel.bottomAnchor, right: rightAnchor, paddingTop: 10, paddingRight: 20)
        excludedCountLabel.anchor(top: usernameLabel.bottomAnchor, right: watchlistCountLabel.leftAnchor, paddingTop: 10, paddingRight: 80)
        friendsCountLabel.anchor(top: usernameLabel.bottomAnchor, right: excludedCountLabel.leftAnchor, paddingTop: 10, paddingRight: 80)
    }
    
    func showRegisterContent() {
        addSubview(shouldRegisterView)
        shouldRegisterView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 150, paddingLeft: 20, paddingRight: 20, height: 200)
    }
    
    func addTmdbAttribution() {
        addSubview(tmdbImage)
        tmdbImage.centerX(inView: self)
        tmdbImage.anchor(left: leftAnchor, bottom: restoreButton.topAnchor, right: rightAnchor, paddingLeft: 30, paddingBottom: 30, paddingRight: 30)
        
        let sourceLabel = UILabel()
        sourceLabel.text = "Content source"
        sourceLabel.font = UIFont.systemFont(ofSize: 15)
        sourceLabel.textColor = .lightGray
        
        addSubview(sourceLabel)
        sourceLabel.anchor(left: leftAnchor, bottom: tmdbImage.topAnchor, paddingLeft: 20, paddingBottom: 10)
    }
    
    func addLogoutAndRestore() {
        if Auth.auth().currentUser != nil {
            addSubview(logoutButton)
            logoutButton.anchor(left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: rightAnchor, paddingBottom: 20, height: 60)
            
            addSubview(restoreButton)
            restoreButton.anchor(left: leftAnchor, bottom: logoutButton.topAnchor, right: rightAnchor, paddingBottom: 10, height: 60)
        } else {
            backgroundColor = .white
            restoreButton.isEnabled = false
            addSubview(restoreButton)
            restoreButton.anchor(left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: rightAnchor, paddingBottom: 20, height: 60)
        }
    }
    
}

extension ProfileView: ShouldRegisterDelegate {
    func goToRegister() {
        delegate?.profileViewGoToRegister()
    }
}
