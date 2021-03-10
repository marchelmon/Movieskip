//
//  UsernameController.swift
//  Movieskip
//
//  Created by marchelmon on 2021-03-08.
//

import UIKit


class UsernameController: UIViewController {
    
    //MARK: - Properties
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Select a username to continue"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    private let usernameTextfield: UITextField = {
        let tf = UITextField()
        let spacer = UIView()
        spacer.setDimensions(height: 50, width: 12)
        tf.leftView = spacer
        tf.leftViewMode = .always
        tf.backgroundColor = UIColor(white: 0.9, alpha: 0.5)
        tf.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [.foregroundColor: UIColor(white: 0.1, alpha: 0.8)])
        tf.placeholder = "Username"
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        return tf
    }()
    
    private let authButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        button.setTitle("Continue", for: .normal)
        button.addTarget(self, action: #selector(handleSelectUsername), for: .touchUpInside)
        return button
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.alpha = 0
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(usernameLabel)
        usernameLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 150, paddingLeft: 20, paddingRight: 20)
        
        view.addSubview(errorLabel)
        errorLabel.anchor(top: usernameLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 100, paddingLeft: 20, paddingRight: 20, height: 50)
        
        view.addSubview(usernameTextfield)
        usernameTextfield.anchor(top: errorLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: 40, paddingRight: 40, height: 50)
        
        view.addSubview(authButton)
        authButton.anchor(top: usernameTextfield.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 15, paddingLeft: 40, paddingRight: 40)
        
    }
    
    //MARK: - Actions
    
    @objc func handleSelectUsername() {
        if let username = usernameTextfield.text {
            
            if !username.isAlphanumeric() {
                errorLabel.text = "Only letter and numbers are allowed"
                errorLabel.alpha = 1
                return
            }
            
            if username.count < 4 {
                errorLabel.text = "The username has to be 4 characters or longer"
                errorLabel.alpha = 1
                return
            }
            
            AuthService.isUsernameTaken(username: username) { (isTaken, error) in
                
                if let error = error {
                    print("ERROR OCCUREDWHEN SELECTING USERNAME: \(error.localizedDescription)")
                    self.errorLabel.text = "An error occured, please close the app and try again"
                    self.errorLabel.alpha = 1
                    return
                }
                if isTaken {
                    
                    self.errorLabel.text = "The username is already taken"
                    self.errorLabel.alpha = 1
                    
                } else {
                    
                    AuthService.updateUsername(username: username)
                    self.dismiss(animated: true, completion: nil)
                    
                }

            }
        }
    }
    
}







