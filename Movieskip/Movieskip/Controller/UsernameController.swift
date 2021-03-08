//
//  UsernameController.swift
//  Movieskip
//
//  Created by marchelmon on 2021-03-08.
//

import UIKit


class UsernameController: UIViewController {
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Select a username to continue"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let usernameTextfield = CustomTextField(placeholder: "Username")
    private let authButton = AuthButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(usernameLabel)
        usernameLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 100, paddingLeft: 20, paddingRight: 20)
        
        view.addSubview(usernameTextfield)
        usernameTextfield.anchor(top: usernameLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 100, paddingLeft: 40, paddingRight: 40)
        
        view.addSubview(authButton)
        authButton.anchor(top: usernameTextfield.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 15, paddingLeft: 40, paddingRight: 40)
        
    }
    
}
