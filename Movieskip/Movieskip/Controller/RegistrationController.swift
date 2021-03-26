//
//  RegisterController.swift
//  Movieskip
//
//  Created by marchelmon on 2021-02-25.
//

import UIKit
import Firebase
import GoogleSignIn


protocol AuthenticationDelegate: class {
    func authenticationComplete()
}

class RegistrationController: UIViewController {
    
    //MARK: - Properties
    
    let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate

    
    private var viewModel = RegistrationViewModel()
    weak var delegate: AuthenticationDelegate?
    
    private let emailTextField = CustomTextField(placeholder: "Email")
    private let passwordTextField = CustomTextField(placeholder: "Password")
    
    private let failedAuthMessage = FailedAuthMessageView()
    
    private let authButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Sign up", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.addTarget(self, action: #selector(handleRegisterUser), for: .touchUpInside)
        return button
    }()
    
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
    
    private let signUpLaterButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(
            string: "Sign up later",
            attributes: [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 16)]
        )
        button.setAttributedTitle(attributedTitle, for: .normal)
        return button
    }()
    
    private let googleButton: GIDSignInButton = {
        let button = GIDSignInButton()
        button.layer.cornerRadius = 8
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self

        configureUI()
        
    }
    
    //MARK: - Actions
        
    @objc func handleRegisterUser() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
    
//        let hud = JGProgressHUD(style: .dark)
//        hud.show(in: view)
        AuthService.registerUser(email: email, password: password) { error in
            if let error = error {
                if let errorCode = AuthErrorCode(rawValue: error._code) {
                    if errorCode.rawValue == 17008 {
                        self.failedAuthMessage.text = "*Enter a valid email address."
                    } else if errorCode.rawValue == 17026 {
                        self.failedAuthMessage.text = "*The password must be 6 characters long."
                    } else if errorCode.rawValue == 17007 {
                        self.failedAuthMessage.text = "*The email address is already in use."
                    } else {
                        self.failedAuthMessage.text = "An undefined error occured, please close the app and try again or login with another provider."
                    }
                    self.failedAuthMessage.alpha = 1
                    //hud.dismiss()
                    return
                }
            }
            //hud.dismiss() TODO
            self.delegate?.authenticationComplete()
        }
    }
    
    @objc func handleShowLogin() {
        let controller = LoginController()
        controller.delegate = delegate
        navigationController?.pushViewController(controller, animated: true)
    }

    //MARK: - Helpers
    
    func configureUI() {
        
        configureGradientLayer()

        view.addSubview(failedAuthMessage)
        failedAuthMessage.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor,
                                 paddingTop: 80, paddingLeft: 30, paddingRight: 30, height: 100)
        
        view.addSubview(googleButton)
        googleButton.anchor(top: failedAuthMessage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
                            paddingTop: 80, paddingLeft: 40, paddingRight: 40)
        
        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField])
        stack.axis = .vertical
        stack.spacing = 12
        view.addSubview(stack)
        stack.anchor(top: googleButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
                     paddingTop: 50, paddingLeft: 40, paddingRight: 40)
        
        view.addSubview(authButton)
        authButton.anchor(top: stack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 22, paddingLeft: 60, paddingRight: 60)
        
        
        view.addSubview(goToLoginButton)
        goToLoginButton.anchor(top: authButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
                               paddingTop: 15, paddingLeft: 32, paddingRight: 32)
    }
    
}


//MARK: - GIDSignInDelegate Google

extension RegistrationController: GIDSignInDelegate {

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {

        if  error != nil {
            failedAuthMessage.text = "An error occured, please close the app and try again"
            failedAuthMessage.alpha = 1
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
     
        AuthService.socialSignIn(credential: credential) { error in
            if error != nil {
                self.failedAuthMessage.text = "An error occured, please close the app and try again"
                self.failedAuthMessage.alpha = 1
                return
            }
            self.delegate?.authenticationComplete()
        }
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
        print("DID DISCONNECT GOOGLE")
    }

}
