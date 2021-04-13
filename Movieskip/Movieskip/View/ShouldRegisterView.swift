//
//  ShouldRegisterView.swift
//  Movieskip
//
//  Created by marchelmon on 2021-04-13.
//

import UIKit

protocol ShouldRegisterDelegate: class {
    func goToRegister()
}

class ShouldRegisterView: UIView {
    
    weak var delegate: ShouldRegisterDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
