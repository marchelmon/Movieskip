//
//  EmailAuthController.swift
//  Movieskip
//
//  Created by marchelmon on 2021-04-05.
//

import UIKit
import Firebase

protocol EmailAuthDelegate: class {
    func showLogin()
    func showRegister()
    func showResetPassword()
    func handleLogin(user: User)
    func handleRegister()
}

class EmailAuthController: UIViewController {
    
    let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
    
    weak var delegate: AuthenticationDelegate?
    
    private let loginView = LoginView()
    private let registerView = RegisterView()
    private let resetPasswordView = ResetPasswordView()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30)
        let image = UIImage(systemName: "arrow.backward", withConfiguration: imageConfig)?.withTintColor(.white, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(goToLoginController), for: .touchUpInside)
        button.setDimensions(height: 50, width: 50)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginView.delegate = self
        registerView.delegate = self
        resetPasswordView.delegate = self
        
        registerView.isHidden = true
        resetPasswordView.isHidden = true
        
        configureGradientLayer()
        
        view.addSubview(backButton)
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 20, paddingLeft: 20)
        
        view.addSubview(loginView)
        loginView.anchor(top: backButton.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 30, paddingRight: 30)
        
        view.addSubview(registerView)
        registerView.anchor(top: backButton.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 30, paddingRight: 30)
        
        view.addSubview(resetPasswordView)
        resetPasswordView.anchor(top: backButton.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 30, paddingRight: 30)
        
    }
    
    //MARK: - Actions
    
    @objc func goToLoginController() {
        navigationController?.popViewController(animated: true)
    }


//    //    @objc func handleForgotPassword() {
//    //        displayResetPasswordView()
//    //    }
//    //
//    //    @objc func handleResetPassword() {
//    //        guard let email = emailTextField.text else { return }
//    //
//    //        if email.count < 3 {
//    //            failedAuthMessage.alpha = 1
//    //            failedAuthMessage.text = "*Enter a valid email address"
//    //            return
//    //        }
//    //
//    //        AuthService.resetUserPassword(email: email) { error in
//    //            if let error = error {
//    //                if let errorCode = AuthErrorCode(rawValue: error._code) {
//    //                    self.failedAuthMessage.alpha = 1
//    //                    if errorCode.rawValue == 17008 {
//    //                        self.failedAuthMessage.text = "*Enter a valid email address"
//    //                    } else if errorCode.rawValue == 17011 {
//    //                        self.failedAuthMessage.text = "*No user found with this email address"
//    //                    } else {
//    //                        self.failedAuthMessage.text = "*An undefined error occured, please check your email and try again"
//    //                    }
//    //                }
//    //                return
//    //            }
//    //            self.failedAuthMessage.alpha = 1
//    //            self.failedAuthMessage.text = "*Check your email to continue"
//    //        }
//    //
//    //    }
//
//
//    func handleUserLoggedIn(snapshot: DocumentSnapshot?, error: Error?) {
//        if let error = error {
//            if let errorCode = AuthErrorCode(rawValue: error._code) {
//                //hud.dismiss
//                self.failedAuthMessage.alpha = 1
//                if errorCode.rawValue == 17008 {
//                    self.failedAuthMessage.text = "Please enter a valid email address"
//                } else if errorCode.rawValue == 17011 {
//                    self.failedAuthMessage.text = "No match found with those credentials"
//                } else if errorCode.rawValue == 17009 {
//                    self.failedAuthMessage.text = "The password is not correct. If you have logged in with google previously, please do so again."
//                } else if errorCode.rawValue == 17009 {
//                    self.failedAuthMessage.text = "You've made too many attempts to login. Please try again later"
//                } else {
//                    print("ERRORCODE: \(errorCode.rawValue)")
//                    print("ERROR \(error.localizedDescription)")
//                    self.failedAuthMessage.text = "An error occured: please try closing the app and starting again"
//                }
//            }
//            return
//        }
//        if let snapshot = snapshot {
//            if let userData = snapshot.data() {
//                self.sceneDelegate.setUser(user: User(dictionary: userData))
//            }
//        }
//        //hud.dismiss
//        self.delegate?.authenticationComplete()
//    }

}


extension EmailAuthController: EmailAuthDelegate {
    
    func showLogin() {
        registerView.isHidden = true
        resetPasswordView.isHidden = true
        loginView.isHidden = false
    }
    
    func showRegister() {
        resetPasswordView.isHidden = true
        loginView.isHidden = true
        registerView.isHidden = false
    }
    
    func showResetPassword() {
        loginView.isHidden = true
        registerView.isHidden = true
        resetPasswordView.isHidden = false
    }
    
    func handleLogin(user: User) {
        sceneDelegate.setUser(user: user)
        delegate?.authenticationComplete()
    }
    
    func handleRegister() {
        delegate?.authenticationComplete()
    }
    
}
