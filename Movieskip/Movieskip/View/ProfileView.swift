//
//  ProfileView.swift
//  Movieskip
//
//  Created by marchelmon on 2021-02-28.
//

import UIKit
import Firebase

class ProfileView: UIView {
    
    //MARK: - Properties
        
    let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "\(sceneDelegate.user.username)  and other data like email, watchlist count and exclude count"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        label.textColor = MAIN_COLOR
        return label
    } ()
    
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
    
        configureUI()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    
    @objc func handleRegister() {
        print("Should present register")
    }
    
    @objc func handleDone() {
        //dismiss(animated: true, completion: nil)
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
            addUserDetails()
        } else {
            showRegisterContent()
        }
        addLogoutAndRestore()
        addTmdbAttribution()
    }
    
    func addUserDetails() {
        let detailsView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 200))
        detailsView.backgroundColor = .white
        detailsView.addSubview(usernameLabel)
        
        usernameLabel.anchor(top: detailsView.topAnchor, left: detailsView.leftAnchor, right: detailsView.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20)
        addSubview(detailsView)
        detailsView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 50, height: 200)
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
