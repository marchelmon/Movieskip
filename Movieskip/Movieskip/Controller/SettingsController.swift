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
        
    let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "\(sceneDelegate.user.username)  and other data like email, watchlist count and exclude count"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        label.textColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
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
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        return button
    }()
    
    private var restoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Restore purchase", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(handleRestore), for: .touchUpInside)
        return button
    }()
    
    private let shouldRegisterText: UILabel = {
        let label = UILabel()
        label.text = "The main purpose of this app can only be available with an account. Read more... "
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        label.textColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        return label
    } ()
    
    
    private var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 3
        button.layer.borderColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()

    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
    }
    
    //MARK: - Actions
    
    @objc func handleRegister() {
        print("Should present register")
    }
    
    @objc func handleDone() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleLogout() {
        print("Logout ? ?? ? ?")
    }
    
    @objc func handleRestore() {
        print("Restore purchase!")
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .systemGroupedBackground
        
        configureNavigationBar()
        
        if Auth.auth().currentUser == nil {
            addUserDetails()
        } else {
            showRegisterContent()
        }
        addLogoutAndRestore()
        addTmdbAttribution()
    }
    
    func configureNavigationBar() {
        navigationItem.title = "Settings"
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
    }
    
    func addUserDetails() {
        let detailsView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 200))
        detailsView.backgroundColor = .white
        detailsView.addSubview(usernameLabel)
        
        usernameLabel.anchor(top: detailsView.topAnchor, left: detailsView.leftAnchor, right: detailsView.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20)
        view.addSubview(detailsView)
        detailsView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, width: view.frame.width, height: 200)
    }
    
    func showRegisterContent() {
        let registerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 200))
        registerView.backgroundColor = .white
        registerView.addSubview(shouldRegisterText)
        shouldRegisterText.anchor(top: registerView.topAnchor, left: registerView.leftAnchor, right: registerView.rightAnchor, paddingTop: 30, paddingLeft: 20, paddingRight: 20)
        registerView.addSubview(registerButton)
        registerButton.centerX(inView: registerView)
        registerButton.anchor(top: shouldRegisterText.bottomAnchor, paddingTop: 20, width: registerView.frame.width / 2.5)
        
        view.addSubview(registerView)
        registerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 150, width: view.frame.width, height: 200)
    }
    
    func addTmdbAttribution() {
        view.addSubview(tmdbImage)
        tmdbImage.centerX(inView: view)
        tmdbImage.anchor(left: view.leftAnchor, bottom: restoreButton.topAnchor, right: view.rightAnchor, paddingLeft: 30, paddingBottom: 30, paddingRight: 30)
        
        let sourceLabel = UILabel()
        sourceLabel.text = "Content source"
        sourceLabel.font = UIFont.systemFont(ofSize: 15)
        sourceLabel.textColor = .lightGray
        
        view.addSubview(sourceLabel)
        sourceLabel.anchor(left: view.leftAnchor, bottom: tmdbImage.topAnchor, paddingLeft: 20, paddingBottom: 10)
    }
    
    func addLogoutAndRestore() {
        if Auth.auth().currentUser != nil {
            view.addSubview(logoutButton)
            logoutButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 20, height: 60)
            
            view.addSubview(restoreButton)
            restoreButton.anchor(left: view.leftAnchor, bottom: logoutButton.topAnchor, right: view.rightAnchor, paddingBottom: 10, height: 60)
        } else {
            view.backgroundColor = .white
            restoreButton.setTitle("", for: .normal)
            restoreButton.isEnabled = false
            view.addSubview(restoreButton)
            restoreButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 20, height: 40)
        }
    }
    
}

    

