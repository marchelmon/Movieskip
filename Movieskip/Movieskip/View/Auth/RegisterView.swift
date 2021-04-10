//
//  RegisterView.swift
//  Movieskip
//
//  Created by marchelmon on 2021-04-08.
//

import UIKit
import Firebase

class RegisterView: UIView {
    
    //MARK: - Properties
    
    weak var delegate: EmailAuthDelegate?
    
    private let email = CustomTextField(placeholder: "Email")
    private let password1 = CustomTextField(placeholder: "Password")
    private let password2 = CustomTextField(placeholder: "Repeat password")

    private let errorMessage: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.numberOfLines = 0
        return label
    }()
    
    private let registerButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    
    private let showLoginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Go to Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(showLogin), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        

        addSubview(showLoginButton)
        showLoginButton.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingBottom: 170)
        
        addSubview(registerButton)
        registerButton.anchor(left: leftAnchor, bottom: showLoginButton.topAnchor, right: rightAnchor, paddingLeft: 40, paddingBottom: 10, paddingRight: 40)

        addSubview(password2)
        password2.anchor(left: leftAnchor, bottom: registerButton.topAnchor, right: rightAnchor, paddingBottom: 15)

        addSubview(password1)
        password1.anchor(left: leftAnchor, bottom: password2.topAnchor, right: rightAnchor, paddingBottom: 12)
        
        addSubview(email)
        email.anchor(left: leftAnchor, bottom: password1.topAnchor, right: rightAnchor, paddingBottom: 12)
        
        addSubview(errorMessage)
        errorMessage.anchor(left: leftAnchor, bottom: email.topAnchor, right: rightAnchor, paddingBottom: 20)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    
    @objc func showLogin() {
        delegate?.showLogin()
    }
    
    @objc func handleRegister() {
        guard let email = email.text else { return }
        guard let password1 = password1.text else { return }
        guard let password2 = password2.text else { return }
    
        if email == "" || password1 == "" || password2 == "" { return }
        if password1 != password2 {
            errorMessage.alpha = 1
            errorMessage.text = "Passwords do not match"
            return
        }

        AuthService.registerUser(email: email, password: password1) { error in
            if let error = error {
                if let errorCode = AuthErrorCode(rawValue: error._code) {
                    //hud.dismiss
                    self.errorMessage.alpha = 1
            
                    switch errorCode.rawValue {
                    case 17007:
                        self.errorMessage.text = "The email is already in use"
                    case 17008:
                        self.errorMessage.text = "Please enter a valid email address"
                    case 17026:
                        self.errorMessage.text = "The password must be 6 characters longer."
                    default:
                        print("ERRORCODE: \(errorCode.rawValue)")
                        print("ERROR \(error.localizedDescription)")
                        self.errorMessage.text = "An error occured: please try closing the app and starting again"
                    }
                }
                return
            }
            self.delegate?.handleRegister()
        }
    }
    
    
}
