//
//  CustomTextField.swift
//  Movieskip
//
//  Created by marchelmon on 2021-02-25.
//

import UIKit

class CustomTextField: UITextField {
    
    init(placeholder: String, secureText: Bool = false) {
        super.init(frame: .zero)
                
        let spacer = UIView()
        spacer.setDimensions(height: 40, width: 12)
        leftView = spacer
        leftViewMode = .always
        
        borderStyle = .none
        backgroundColor = UIColor(white: 1, alpha: 0.2)
        textColor = .white
        heightAnchor.constraint(equalToConstant: 40).isActive = true
        layer.cornerRadius = 5
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [ .foregroundColor: UIColor(white: 1, alpha: 0.7)])
        isSecureTextEntry = secureText
        keyboardAppearance = .dark
        autocorrectionType = .no
        autocapitalizationType = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
