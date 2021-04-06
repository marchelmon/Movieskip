//
//  RegisterController.swift
//  Movieskip
//
//  Created by marchelmon on 2021-02-25.
//

import UIKit
import Firebase
import GoogleSignIn


class RegistrationController: UIViewController {
    
    //MARK: - Properties
    
    let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate

    weak var delegate: AuthenticationDelegate?
    
    private let emailTextField = CustomTextField(placeholder: "Email")
    private let passwordTextField = CustomTextField(placeholder: "Password")
    
    private let failedAuthMessage = FailedAuthMessageView()
    
    private let goToLoginButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(
            string: "Go back to login",
            attributes: [.foregroundColor: UIColor.white, .font: UIFont.boldSystemFont(ofSize: 16)]
        )
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        return button
    }()
    
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        
    }
    
    //MARK: - Actions
    
    @objc func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }

    //MARK: - Helpers
    
    func configureUI() {
        
        configureGradientLayer()

        view.addSubview(failedAuthMessage)
        failedAuthMessage.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor,
                                 paddingTop: 80, paddingLeft: 30, paddingRight: 30, height: 100)
        
        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField])
        stack.axis = .vertical
        stack.spacing = 12
        view.addSubview(stack)
        stack.anchor(top: failedAuthMessage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
                     paddingTop: 50, paddingLeft: 40, paddingRight: 40)
    
        
        view.addSubview(goToLoginButton)
        goToLoginButton.anchor(top: stack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
                               paddingTop: 15, paddingLeft: 32, paddingRight: 32)
    }
    
}

