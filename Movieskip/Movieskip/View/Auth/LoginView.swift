//
//  LoginView.swift
//  Movieskip
//
//  Created by marchelmon on 2021-04-08.
//

import UIKit

protocol EmailAuthViewDelegate: class {
    func showLogin()
    func showRegister()
    func showResetPassword()
}

class LoginView: UIView {
    
    //MARK: - Properties
    
    weak var delegate: EmailAuthViewDelegate?
    
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
        button.addTarget(self, action: #selector(handleLoginUser), for: .touchUpInside)
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
    
    private let resetPasswordButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Reset password", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.addTarget(self, action: #selector(resetPassword), for: .touchUpInside)
        button.isEnabled = true
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
        errorMessage.anchor(left: leftAnchor, bottom: email.topAnchor, right: rightAnchor, paddingBottom: 20)
        
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
    
    @objc func resetPassword() {
        
    }
    
    @objc func handleLoginUser() {
        
    }
    
    
    
}
