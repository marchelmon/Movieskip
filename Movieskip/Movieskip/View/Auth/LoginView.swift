//
//  LoginView.swift
//  Movieskip
//
//  Created by marchelmon on 2021-04-08.
//

import UIKit
import Firebase

class LoginView: UIView {
    
    //MARK: - Properties
    
    weak var delegate: EmailAuthDelegate?
    
    private let email = CustomTextField(placeholder: "Email")
    private let password = CustomTextField(placeholder: "Password")
    
    private let errorMessage: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.numberOfLines = 0
        return label
    }()
    
    private let loginButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    private let showResetPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(
            string: "Forgot password?",
            attributes: [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 15)]
        )
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(showResetPassword), for: .touchUpInside)

        return button
    }()
    
    private let showRegisterButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(showRegister), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(showResetPasswordButton)
        showResetPasswordButton.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingBottom: 25)
        
        addSubview(showRegisterButton)
        showRegisterButton.anchor(left: leftAnchor, bottom: showResetPasswordButton.topAnchor, right: rightAnchor, paddingBottom: 150)
        
        addSubview(loginButton)
        loginButton.anchor(left: leftAnchor, bottom: showRegisterButton.topAnchor, right: rightAnchor, paddingLeft: 40, paddingBottom: 10, paddingRight: 40)
        
        addSubview(password)
        password.anchor(left: leftAnchor, bottom: loginButton.topAnchor, right: rightAnchor, paddingBottom: 15)
        
        addSubview(email)
        email.anchor(left: leftAnchor, bottom: password.topAnchor, right: rightAnchor, paddingBottom: 12)
        
        addSubview(errorMessage)
        errorMessage.anchor(left: leftAnchor, bottom: email.topAnchor, right: rightAnchor, paddingBottom: 60)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    
    @objc func showRegister() {
        delegate?.showRegister()
    }
    
    @objc func showResetPassword() {
        delegate?.showResetPassword()
    }

    @objc func handleLogin() {
        guard let email = email.text else { return }
        guard let password = password.text else { return }
        
        //        let hud = JGProgressHUD(style: .dark)
        //        hud.show(in: view)
        AuthService.logUserIn(withEmail: email, withPassword: password, completion: handleUserLoggedIn)
    }
    
    func handleUserLoggedIn(snapshot: DocumentSnapshot?, error: Error?) {
        if let error = error {
            if let errorCode = AuthErrorCode(rawValue: error._code) {
                //hud.dismiss
                self.errorMessage.alpha = 1
                
                switch errorCode.rawValue {
                case 17007:
                    self.errorMessage.text = "The email is already in use"
                case 17008:
                    self.errorMessage.text = "Please enter a valid email address"
                case 17009:
                    self.errorMessage.text = "The password is not correct. If you have logged in with google previously, please do so again."
                case 17010:
                    self.errorMessage.text = "You've made too many attempts to login. Please try again later"
                case 17011:
                    self.errorMessage.text = "No user found with those credentials"
                case 17012:
                    self.errorMessage.text = "Please use the same login method as you have previously"
                default:
                    print("ERRORCODE: \(errorCode.rawValue)")
                    print("ERROR \(error.localizedDescription)")
                    self.errorMessage.text = "An error occured: please try closing the app and starting again"
                }
            }
            return
        }
        if let snapshot = snapshot {
            if let userData = snapshot.data() {
                self.delegate?.handleLogin(user: User(dictionary: userData))
            }
        }
    }
    
}
