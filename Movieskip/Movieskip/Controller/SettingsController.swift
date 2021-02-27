//
//  UserController.swift
//  Movieskip
//
//  Created by marchelmon on 2021-02-26.
//

import UIKit

class SettingsController: UIViewController {
            
    //MARK: - Properties
        
    private let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        return button
    }()

    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
    }
    
    
    //MARK: - Actions
    
    @objc func handleDone() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleLogout() {
        print("Logout ? ?? ? ?")
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .systemGroupedBackground
        
        configureNavigationBar()
        
                
        
        addLogoutButton()
    }
    
    func configureNavigationBar() {
        navigationItem.title = "Settings"
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
    }
    
    func addLogoutButton() {
        view.addSubview(logoutButton)
        logoutButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 20, height: 50)
    }
    
}

    

