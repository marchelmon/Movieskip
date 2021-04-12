//
//  resetPasswordView.swift
//  Movieskip
//
//  Created by marchelmon on 2021-04-08.
//

import UIKit

class ResetPasswordView: UIView {
    
    //MARK: - Properties
    
    weak var delegate: EmailAuthDelegate?
    
    private let email = CustomTextField(placeholder: "Email")
    
    private let errorMessage: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.numberOfLines = 0
        return label
    }()
    
    private let resetPasswordButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Reset password", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.addTarget(self, action: #selector(resetPassword), for: .touchUpInside)
        button.isEnabled = true
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
        showLoginButton.anchor(left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: rightAnchor, paddingBottom: 250)
        
        addSubview(resetPasswordButton)
        resetPasswordButton.anchor(left: leftAnchor, bottom: showLoginButton.topAnchor, right: rightAnchor, paddingLeft: 40, paddingBottom: 10, paddingRight: 40)
        
        addSubview(email)
        email.anchor(left: leftAnchor, bottom: resetPasswordButton.topAnchor, right: rightAnchor, paddingBottom: 12)
        
        addSubview(errorMessage)
        errorMessage.anchor(left: leftAnchor, bottom: email.topAnchor, right: rightAnchor, paddingBottom: 60)

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    
    @objc func resetPassword() {
        guard let email = email.text else { return }
        if !email.isValidEmail(){
            errorMessage.text = "Please enter a valid email address"
            errorMessage.alpha = 1
            return
        }
        AuthService.resetUserPassword(email: email) { error in
            if let error = error {
                print("ERROR RESET PASSWORD: \(error.localizedDescription)")
                self.errorMessage.text = "Something went wrong, check your email or try again"
                self.errorMessage.alpha = 1
                return
            }
            let alert = UIAlertController(title: "Check your email to continue password restoration", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                switch action {
                
                default:
                    self.delegate?.showLogin()
                }
            }))
            self.delegate?.showAlert(alert: alert)
        }
    }
    
    @objc func showLogin() {
        delegate?.showLogin()
    }
    
}
