//
//  LoginController.swift
//  Movieskip
//
//  Created by marchelmon on 2021-02-25.
//

import UIKit

class LoginController: UIViewController {
    
    
    //MARK: - Properties
    
    private var viewModel = LoginViewModel()
    weak var delegate: AuthenticationDelegate?
    
    private let emailTextField = CustomTextField(placeholder: "Email")
    private let passwordTextField = CustomTextField(placeholder: "Password", secureText: true)
    
    private let authButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Sign in", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.addTarget(self, action: #selector(handleLoginUser), for: .touchUpInside)
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
    
    private let signUpLaterButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(
            string: "Sign up later",
            attributes: [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 16)]
        )
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleSkipLogin), for: .touchUpInside)
        
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
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
                print("ERROR SIGNING USER IN: \(error)")
                //hud.dismiss
                return
            } else {
                //hud.dismiss
                self.delegate?.authenticationComplete()
            }
        }
    }
    
    @objc func handleShowRegister() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleSkipLogin() {
        print("SHOULD DISMISS LOGIN CONTROLLER")
        //dismiss(animated: true, completion: nil)
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else if sender == passwordTextField {
            viewModel.password = sender.text
        }
        checkFormStatus()
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        configureGradientLayer()
        
        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, authButton])
        stack.axis = .vertical
        stack.spacing = 12
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 100, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(signUpLaterButton)
        signUpLaterButton.anchor(top: stack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8)
        
        view.addSubview(goToRegistrationButton)
        goToRegistrationButton.anchor(
            left: view.leftAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            right: view.rightAnchor,
            paddingLeft: 32,
            paddingRight: 32
        )
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
