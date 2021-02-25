//
//  AuthButton.swift
//  Movieskip
//
//  Created by marchelmon on 2021-02-25.
//

import UIKit

class AuthButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = #colorLiteral(red: 0.3406828936, green: 0.02802316744, blue: 0.7429608185, alpha: 1)
        layer.cornerRadius = 5
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        setTitleColor(.white, for: .normal)
        isEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
