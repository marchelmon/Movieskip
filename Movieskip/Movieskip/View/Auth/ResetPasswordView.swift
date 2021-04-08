//
//  resetPasswordView.swift
//  Movieskip
//
//  Created by marchelmon on 2021-04-08.
//

import UIKit

class ResetPasswordView: UIView {
    
    private let email = CustomTextField(placeholder: "Email")
    
    private let failedAuthMessage: UILabel = {
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func resetPassword() {
        
    }
    
}
