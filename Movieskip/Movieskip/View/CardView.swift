//
//  CardView.swift
//  Movieskip
//
//  Created by marchelmon on 2021-02-12.
//

import UIKit

class CardView: UIView {
    
    private let userView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Jag vill vara din margaretea"
        return label
    } ()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        
        layer.cornerRadius = 10
        clipsToBounds = true
        backgroundColor = .purple
        
        addSubview(userView)
        
        userView.fillSuperview()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
