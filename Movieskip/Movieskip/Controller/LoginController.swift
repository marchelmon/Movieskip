//
//  LoginController.swift
//  Movieskip
//
//  Created by marchelmon on 2021-02-25.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    
    
    //MARK: - Properties
    
    private var viewModel = LoginViewModel()
    weak var delegate: AuthenticationDelegate?
    
    private let loginView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let resetPasswordView: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()
    
    private let emailTextField = CustomTextField(placeholder: "Email")
    private let passwordTextField = CustomTextField(placeholder: "Password", secureText: true)
    private let failedAuthMessage = FailedAuthMessageView()
    
    private let authButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Sign in", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.addTarget(self, action: #selector(handleLoginUser), for: .touchUpInside)
        return button
    }()
    
    private let resetPasswordButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Reset password", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.addTarget(self, action: #selector(handleResetPassword), for: .touchUpInside)
        button.isEnabled = true
        return button
    }()
    
    private let goToRegistrationButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(
            string: "Don't have an account?  ",
            attributes: [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 16)]
        )
        attributedTitle.append(
            NSAttributedString(
                string: "Sign up",
                attributes: [.foregroundColor: UIColor.white, .font: UIFont.boldSystemFont(ofSize: 16)]
            )
        )
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowRegister), for: .touchUpInside)
        
        return button
    }()
    
    private let forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(
            string: "Forgot password?",
            attributes: [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 16)]
        )
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleForgotPassword), for: .touchUpInside)
        
        return button
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.backward")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        button.setDimensions(height: 50, width: 50)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureGradientLayer()
        displayLoginView()
        configureTextFieldObservers()
        
    }
    
    
    //MARK: - Actions
    
    
    @objc func handleLoginUser() {
        guard let email = viewModel.email else { return }
        guard let password = viewModel.password else { return }
        
        //        let hud = JGProgressHUD(style: .dark)
        //        hud.show(in: view)
        
        AuthService.logUserIn(withEmail: email, withPassword: password) { (data, error) in
            if let error = error {
                if let errorCode = AuthErrorCode(rawValue: error._code) {
                    //hud.dismiss
                    self.failedAuthMessage.alpha = 1
                    if errorCode.rawValue == 17008 {
                        self.failedAuthMessage.text = "Enter a valid email address"
                    } else if errorCode.rawValue == 17011 {
                        self.failedAuthMessage.text = "No match found with those credentials"
                    } else if errorCode.rawValue == 17009 {
                        self.failedAuthMessage.text = "The password is not correct"
                    } else {
                        self.failedAuthMessage.text = "Unknown error, please try closing the app and starting again"
                    }
                    return
                }
            }  else {
                //hud.dismiss
                self.delegate?.authenticationComplete()
            }
        }
    }
    
    @objc func handleShowRegister() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleForgotPassword() {
        displayResetPasswordView()
    }
    
    @objc func handleResetPassword() {
        guard let email = emailTextField.text else { return }
        
        if email.count < 3 {
            failedAuthMessage.alpha = 1
            failedAuthMessage.text = "Enter a valid email address"
            return
        }
        
        AuthService.resetUserPassword(email: email) { error in
            if let error = error {
                if let errorCode = AuthErrorCode(rawValue: error._code) {
                    self.failedAuthMessage.alpha = 1
                    if errorCode.rawValue == 17008 {
                        self.failedAuthMessage.text = "Enter a valid email address"
                    } else if errorCode.rawValue == 17011 {
                        self.failedAuthMessage.text = "No match found with this email address"
                    }
                }
                return
            }
            self.failedAuthMessage.alpha = 1
            self.failedAuthMessage.text = "Check your email to continue"
        }
        
        
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else if sender == passwordTextField {
            viewModel.password = sender.text
        }
        checkFormStatus()
    }
    
    @objc func handleShowLogin() {
        displayLoginView()
    }
    
    //MARK: - Helpers
    
    func displayResetPasswordView() {
        loginView.isHidden = true
        resetPasswordView.isHidden = false
        failedAuthMessage.alpha = 0
        
        resetPasswordView.addSubview(backButton)
        backButton.anchor(top: resetPasswordView.topAnchor, left: resetPasswordView.leftAnchor, paddingTop: 45, paddingLeft: 20)
        
        resetPasswordView.addSubview(failedAuthMessage)
        failedAuthMessage.anchor(top: resetPasswordView.topAnchor, left: resetPasswordView.leftAnchor, right: resetPasswordView.rightAnchor, paddingTop: 110, paddingLeft: 30, paddingRight: 30, height: 80)
        
        resetPasswordView.addSubview(emailTextField)
        emailTextField.anchor(top: failedAuthMessage.bottomAnchor, left: resetPasswordView.leftAnchor, right: resetPasswordView.rightAnchor, paddingTop: 120, paddingLeft: 32, paddingRight: 32)
        
        resetPasswordView.addSubview(resetPasswordButton)
        resetPasswordButton.anchor(top: emailTextField.bottomAnchor, left: resetPasswordView.leftAnchor, right: resetPasswordView.rightAnchor, paddingTop: 20, paddingLeft: 32, paddingRight: 32)
        
        resetPasswordView.addSubview(goToRegistrationButton)
        goToRegistrationButton.anchor(
            left: resetPasswordView.leftAnchor,
            bottom: resetPasswordView.bottomAnchor,
            right: resetPasswordView.rightAnchor,
            paddingLeft: 32,
            paddingBottom: 30,
            paddingRight: 32
        )
        
        view.addSubview(resetPasswordView)
        resetPasswordView.fillSuperview()
        
    }
    
    func displayLoginView() {
        resetPasswordView.isHidden = true
        loginView.isHidden = false
        failedAuthMessage.alpha = 0
        
        loginView.addSubview(failedAuthMessage)
        failedAuthMessage.anchor(top: loginView.topAnchor, left: loginView.leftAnchor, right: loginView.rightAnchor, paddingTop: 80, paddingLeft: 30, paddingRight: 30, height: 80)
        
        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, authButton])
        stack.axis = .vertical
        stack.spacing = 12
        loginView.addSubview(stack)
        stack.anchor(top: failedAuthMessage.bottomAnchor, left: loginView.leftAnchor, right: loginView.rightAnchor, paddingTop: 60, paddingLeft: 32, paddingRight: 32)
        
        loginView.addSubview(forgotPasswordButton)
        forgotPasswordButton.anchor(top: stack.bottomAnchor, left: loginView.leftAnchor, right: loginView.rightAnchor, paddingTop: 8)
        
        loginView.addSubview(goToRegistrationButton)
        goToRegistrationButton.anchor(
            left: loginView.leftAnchor,
            bottom: loginView.bottomAnchor,
            right: loginView.rightAnchor,
            paddingLeft: 32,
            paddingBottom: 30,
            paddingRight: 32
        )
        
        view.addSubview(loginView)
        loginView.fillSuperview()
    }
    
    func checkFormStatus() {
        if viewModel.formIsValid {
            authButton.isEnabled = true
            authButton.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        } else {
            authButton.isEnabled = false
            authButton.backgroundColor = #colorLiteral(red: 0.3406828936, green: 0.02802316744, blue: 0.7429608185, alpha: 1)
        }
    }
    
    func configureTextFieldObservers() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
}
