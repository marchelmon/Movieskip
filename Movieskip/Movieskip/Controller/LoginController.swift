//
//  LoginController.swift
//  Movieskip
//
//  Created by marchelmon on 2021-02-25.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginController: UIViewController {
    
    //MARK: - Properties
    
    let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate

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
    
    private let emailTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "Email")
        //tf.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        return tf
    }()
    
    private let passwordTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "Password", secureText: true)
        //tf.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        return tf
    }()
    
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
            string: "Sign up",
            attributes: [.foregroundColor: UIColor.white, .font: UIFont.boldSystemFont(ofSize: 16)]
        )
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowRegister), for: .touchUpInside)
        
        return button
    }()
    
    private let forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(
            string: "Forgot password?",
            attributes: [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 14)]
        )
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleForgotPassword), for: .touchUpInside)
        
        return button
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30)
        let image = UIImage(systemName: "arrow.backward", withConfiguration: imageConfig)?.withTintColor(.white, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        button.setDimensions(height: 50, width: 50)
        return button
    }()
    
    private let googleButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Sign in", for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(signInGoogle), for: .touchUpInside)
        return button
    }()
    
    private let signUpLaterButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(
            string: "Continue without login",
            attributes: [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 16)]
        )
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleSkipLogin), for: .touchUpInside)
        
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        
        configureGradientLayer()
        displayLoginView()
    }
    
    
    //MARK: - Actions
    
    @objc func signInGoogle() {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @objc func handleSkipLogin() {
        UserDefaults.standard.set(true, forKey: "skippedLogin")
        sceneDelegate.fetchLocalUser()
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleLoginUser() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        //        let hud = JGProgressHUD(style: .dark)
        //        hud.show(in: view)
        
        AuthService.logUserIn(withEmail: email, withPassword: password, completion: handleUserLoggedIn)
    }
    
    @objc func handleShowRegister() {
        let controller = RegistrationController()
        controller.delegate = delegate
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func handleForgotPassword() {
        displayResetPasswordView()
    }
    
    @objc func handleResetPassword() {
        guard let email = emailTextField.text else { return }
        
        if email.count < 3 {
            failedAuthMessage.alpha = 1
            failedAuthMessage.text = "*Enter a valid email address"
            return
        }
        
        AuthService.resetUserPassword(email: email) { error in
            if let error = error {
                if let errorCode = AuthErrorCode(rawValue: error._code) {
                    self.failedAuthMessage.alpha = 1
                    if errorCode.rawValue == 17008 {
                        self.failedAuthMessage.text = "*Enter a valid email address"
                    } else if errorCode.rawValue == 17011 {
                        self.failedAuthMessage.text = "*No user found with this email address"
                    } else {
                        self.failedAuthMessage.text = "*An undefined error occured, please check your email and try again"
                    }
                }
                return
            }
            self.failedAuthMessage.alpha = 1
            self.failedAuthMessage.text = "*Check your email to continue"
        }
        
    }
    
    @objc func handleShowLogin() {
        displayLoginView()
    }
    
    func handleUserLoggedIn(snapshot: DocumentSnapshot?, error: Error?) {
        if let error = error {
            if let errorCode = AuthErrorCode(rawValue: error._code) {
                //hud.dismiss
                self.failedAuthMessage.alpha = 1
                if errorCode.rawValue == 17008 {
                    self.failedAuthMessage.text = "Please enter a valid email address"
                } else if errorCode.rawValue == 17011 {
                    self.failedAuthMessage.text = "No match found with those credentials"
                } else if errorCode.rawValue == 17009 {
                    self.failedAuthMessage.text = "The password is not correct. If you have logged in with google previously, please do so again."
                } else if errorCode.rawValue == 17009 {
                    self.failedAuthMessage.text = "You've made too many attempts to login. Please try again later"
                } else {
                    self.failedAuthMessage.text = "An error occured: please try closing the app and starting again"
                }
            }
            return
        }
        print("Handle user logged in")
        if let snapshot = snapshot {
            if let userData = snapshot.data() {
                print("LOGGED IN USER SET IN sceneDelegate")
                self.sceneDelegate.setUser(user: User(dictionary: userData))
            }
        }
        //hud.dismiss
        self.delegate?.authenticationComplete()
    }
    
    //MARK: - Helpers
    
    func displayResetPasswordView() {
        loginView.isHidden = true
        resetPasswordView.isHidden = false
        failedAuthMessage.alpha = 0
        
        resetPasswordView.addSubview(backButton)
        backButton.anchor(top: resetPasswordView.topAnchor, left: resetPasswordView.leftAnchor, paddingTop: 45, paddingLeft: 20)
        
        resetPasswordView.addSubview(failedAuthMessage)
        failedAuthMessage.anchor(top: resetPasswordView.topAnchor, left: resetPasswordView.leftAnchor, right: resetPasswordView.rightAnchor, paddingTop: 110, paddingLeft: 30, paddingRight: 30, height: 100)
        
        resetPasswordView.addSubview(emailTextField)
        emailTextField.anchor(top: failedAuthMessage.bottomAnchor, left: resetPasswordView.leftAnchor, right: resetPasswordView.rightAnchor, paddingTop: 120, paddingLeft: 32, paddingRight: 32)
        
        resetPasswordView.addSubview(resetPasswordButton)
        resetPasswordButton.anchor(top: emailTextField.bottomAnchor, left: resetPasswordView.leftAnchor, right: resetPasswordView.rightAnchor, paddingTop: 20, paddingLeft: 60, paddingRight: 60)
        
        resetPasswordView.addSubview(goToRegistrationButton)
        goToRegistrationButton.anchor(top: resetPasswordButton.bottomAnchor, left: resetPasswordView.leftAnchor, right: resetPasswordView.rightAnchor,                                    paddingTop: 15, paddingLeft: 60, paddingRight: 60)
        
        view.addSubview(resetPasswordView)
        resetPasswordView.fillSuperview()
    }
    
    func displayLoginView() {
        resetPasswordView.isHidden = true
        loginView.isHidden = false
        failedAuthMessage.alpha = 0
        
        loginView.addSubview(failedAuthMessage)
        failedAuthMessage.anchor(top: loginView.topAnchor, left: loginView.leftAnchor, right: loginView.rightAnchor,
                                 paddingTop: 110, paddingLeft: 30, paddingRight: 30, height: 100)
        
        loginView.addSubview(googleButton)
        googleButton.anchor(top: failedAuthMessage.bottomAnchor, left: loginView.leftAnchor, right: loginView.rightAnchor,
                            paddingTop: 70, paddingLeft: 40, paddingRight: 40, height: 50)
        
        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField])
        stack.axis = .vertical
        stack.spacing = 12
        loginView.addSubview(stack)
        stack.anchor(top: googleButton.bottomAnchor, left: loginView.leftAnchor, right: loginView.rightAnchor,
                     paddingTop: 50, paddingLeft: 40, paddingRight: 40)
        
        loginView.addSubview(authButton)
        authButton.anchor(top: stack.bottomAnchor, left: loginView.leftAnchor, right: loginView.rightAnchor, paddingTop: 22, paddingLeft: 60, paddingRight: 60)
        
        
        loginView.addSubview(goToRegistrationButton)
        goToRegistrationButton.anchor(top: authButton.bottomAnchor, left: loginView.leftAnchor, right: loginView.rightAnchor,
                                      paddingTop: 15, paddingLeft: 32, paddingRight: 32)
        
        loginView.addSubview(forgotPasswordButton)
        forgotPasswordButton.anchor(top: goToRegistrationButton.bottomAnchor, left: loginView.leftAnchor, right: loginView.rightAnchor, paddingLeft: 32, paddingRight: 32)
        
        loginView.addSubview(signUpLaterButton)
        signUpLaterButton.anchor(left: loginView.leftAnchor, bottom: loginView.bottomAnchor, right: loginView.rightAnchor,
                                 paddingLeft: 32, paddingBottom: 20, paddingRight: 32)
        
        view.addSubview(loginView)
        loginView.fillSuperview()
    }
}

//MARK: - GIDSignInDelegate Google

extension LoginController: GIDSignInDelegate {

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {

        if error != nil {
            failedAuthMessage.text = "An error occured, close the app and try again"
            failedAuthMessage.alpha = 1
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
     
        AuthService.socialSignIn(credential: credential) { error in
            if error != nil {
                self.failedAuthMessage.text = "An error occured, close the app and try again"
                self.failedAuthMessage.alpha = 1
                return
            }
            if let user = Auth.auth().currentUser {
                AuthService.fetchLoggedInUser(uid: user.uid, completion: self.handleUserLoggedIn)
            }
        }
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
        print("DID DISCONNECT GOOGLE")
    }

}

