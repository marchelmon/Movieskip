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
            string: "Already have an account?  ",
            attributes: [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 16)]
        )
        attributedTitle.append(
            NSAttributedString(
                string: "Sign in",
                attributes: [.foregroundColor: UIColor.white, .font: UIFont.boldSystemFont(ofSize: 16)]
            )
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
        button.addTarget(self, action: #selector(handleSkipLogin), for: .touchUpInside)
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
        configureTextFieldObservers()
    }
    
    //MARK: - Actions
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else if sender == passwordTextField {
            viewModel.password = sender.text
        }
        checkFormStatus()
    }
        
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
                        self.failedAuthMessage.text = "*The password must be 6 characters long"
                    } else if errorCode.rawValue == 17007 {
                        self.failedAuthMessage.text = "*The email address is already in use"
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
        //navigationController?.popViewController(self, animated: true)
    }
    
    @objc func handleSkipLogin() {
        //dismiss(animated: true, completion: nil)
        print("SHOULD DISMISS LOGIN CONTROLLER")
    }
    
    //MARK: - Helpers
    
    func checkFormStatus() {
        if viewModel.formIsValid {
            authButton.isEnabled = true
            authButton.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        } else {
            authButton.isEnabled = false
            authButton.backgroundColor = #colorLiteral(red: 0.3406828936, green: 0.02802316744, blue: 0.7429608185, alpha: 1)
        }
    }
    
    func configureUI() {
        
        configureGradientLayer()

        view.addSubview(failedAuthMessage)
        failedAuthMessage.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: 30, paddingRight: 30, height: 100)
        
        
        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, authButton])
        stack.axis = .vertical
        stack.spacing = 12
        view.addSubview(stack)
        stack.anchor(
            top: failedAuthMessage.bottomAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingTop: 100, paddingLeft: 40, paddingRight: 40
        )
        
        
        view.addSubview(googleButton)
        googleButton.anchor(top: stack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 15, paddingLeft: 40, paddingRight: 40, height: 50)
        
        
        view.addSubview(goToLoginButton)
        goToLoginButton.anchor(
            left: view.leftAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            right: view.rightAnchor,
            paddingLeft: 32, paddingRight: 32
        )
        
    }
    
    func configureTextFieldObservers() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
}


//MARK: - GIDSignInDelegate Google

extension RegistrationController: GIDSignInDelegate {

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {

        if let error = error {
            print("ERROR: \(error.localizedDescription)")
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
     
        AuthService.socialSignIn(credential: credential) { error in
            if let error = error {
                //TODO: HANDLE ERROR
                print("There was an error signing user in an creatingfetching from direbase; \(error.localizedDescription)")
                return
            }
            print("SUCCESS GOOGLE SIGNIN")
            self.dismiss(animated: true, completion: nil)
        }
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
        print("DID DISCONNECT GOOGLE")
    }

}
