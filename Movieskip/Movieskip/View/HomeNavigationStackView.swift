//
//  HomeNavigationStack.swift
//  Movieskip
//
//  Created by marchelmon on 2021-02-12.
//

import UIKit

class HomeNavigationStackView: UIStackView {
    
    //MARK: - Properties

    private lazy var movieskipIcon = UIImageView(image: MOVIESKIP_ICON)
    private let watchListButton = UIButton(type: .system)
    private let settingsButton = UIButton(type: .system)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        movieskipIcon.contentMode = .scaleAspectFit
        
        watchListButton.setImage(#imageLiteral(resourceName: "super_like_circle").withRenderingMode(.alwaysOriginal), for: .normal)
        settingsButton.setImage(#imageLiteral(resourceName: "top_left_profile").withRenderingMode(.alwaysOriginal), for: .normal)
        
        
        [watchListButton, UIView(), movieskipIcon, UIView(), settingsButton].forEach { view in
            addArrangedSubview(view)
        }
        
        distribution = .equalCentering
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 10, bottom: 0, right: 10)
    
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
