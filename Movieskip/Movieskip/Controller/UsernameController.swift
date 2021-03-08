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
        label.textAlignment = .center
        return label
    }()
    
    private let usernameTextfield: UITextField = {
        let tf = UITextField()
        let spacer = UIView()
        spacer.setDimensions(height: 50, width: 12)
        tf.leftView = spacer
        tf.leftViewMode = .always
        //tf.heightAnchor.constraint(equalToConstant: 35).isActive = true
        tf.backgroundColor = UIColor(white: 0.9, alpha: 0.5)
        tf.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [.foregroundColor: UIColor(white: 0.1, alpha: 0.8)])
        tf.placeholder = "Username"
        return tf
    }()
    private let authButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        button.setTitle("Continue", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(usernameLabel)
        usernameLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 100, paddingLeft: 20, paddingRight: 20)
        
        view.addSubview(usernameTextfield)
        usernameTextfield.anchor(top: usernameLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 100, paddingLeft: 40, paddingRight: 40, height: 50)
        
        view.addSubview(authButton)
        authButton.anchor(top: usernameTextfield.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 15, paddingLeft: 40, paddingRight: 40)
        
        //TODO: kolla om detta knasar
        authButton.centerY(inView: view)

        
        
    }
    
}







