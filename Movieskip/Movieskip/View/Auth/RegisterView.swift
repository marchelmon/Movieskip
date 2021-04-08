//
//  RegisterView.swift
//  Movieskip
//
//  Created by marchelmon on 2021-04-08.
//

import UIKit

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
        delegate?.handleRegister()
        //        guard let email = emailTextField.text else { return }
        //        guard let password = passwordTextField.text else { return }
        //
        //        //let hud = JGProgressHUD(style: .dark)
        //        //hud.show(in: view)
        //        AuthService.registerUser(email: email, password: password) { error in
        //            if let error = error {
        //                if let errorCode = AuthErrorCode(rawValue: error._code) {
        //                    if errorCode.rawValue == 17008 {
        //                        self.failedAuthMessage.text = "*Enter a valid email address."
        //                    } else if errorCode.rawValue == 17026 {
        //                        self.failedAuthMessage.text = "*The password must be 6 characters long."
        //                    } else if errorCode.rawValue == 17007 {
        //                        self.failedAuthMessage.text = "*The email address is already in use."
        //                    } else {
        //                        self.failedAuthMessage.text = "An undefined error occured, please close the app and try again or login with another provider."
        //                    }
        //                    self.failedAuthMessage.alpha = 1
        //                    //hud.dismiss()
        //                    return
        //                }
        //            }
        //            //hud.dismiss() TODO
        //            self.delegate?.authenticationComplete()

    }
    
    
    
}
