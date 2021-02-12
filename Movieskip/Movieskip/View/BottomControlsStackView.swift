//
//  BottomControlsStackView.swift
//  Movieskip
//
//  Created by marchelmon on 2021-02-12.
//

import UIKit

class BottomControlsStackView: UIStackView {
    
    //MARK: - Properties
    
    private let dislikeButton = UIButton(type: .system)
    private let likeButton = UIButton(type: .system)
    private let watchlistButton = UIButton(type: .system)
    private let refreshButton = UIButton(type: .system)
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        distribution = .fillEqually
        
        dislikeButton.setImage(#imageLiteral(resourceName: "dismiss_circle").withRenderingMode(.alwaysOriginal), for: .normal)
        likeButton.setImage(#imageLiteral(resourceName: "like_circle").withRenderingMode(.alwaysOriginal), for: .normal)
        watchlistButton.setImage(#imageLiteral(resourceName: "super_like_circle").withRenderingMode(.alwaysOriginal), for: .normal)
        refreshButton.setImage(#imageLiteral(resourceName: "refresh_circle").withRenderingMode(.alwaysOriginal), for: .normal)
        
        //Actions for buttons goes here
        
        [refreshButton, dislikeButton, likeButton, watchlistButton].forEach { view in
            addArrangedSubview(view)
        }
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
