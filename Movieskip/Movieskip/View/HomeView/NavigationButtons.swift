//
//  HomeNavigationStack.swift
//  Movieskip
//
//  Created by marchelmon on 2021-02-12.
//

import UIKit

protocol NavigationButtonsDelegate: class {
    func shouldShowSwipe()
    func shouldShowWatchlist()
    func shouldShowUser()
}

class NavigationButtons: UIStackView {
    
    //MARK: - Properties
    
    weak var delegate: NavigationButtonsDelegate?

    private lazy var movieskipIcon = UIImageView(image: K.MOVIESKIP_ICON)
    private let watchListButton = UIButton(type: .system)
    private let userButton = UIButton(type: .system)
    

    
    private let watchlistImage: UIImage? = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30)
        let image = UIImage(systemName: "text.badge.star", withConfiguration: imageConfig)
        return image
    }()
    
    private let userImage: UIImage? = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30)
        let image = UIImage(systemName: "person", withConfiguration: imageConfig)
        return image
    }()
    
    
    
   // let watchlistImage = UIImage(systemName: "text.badge.star", withConfiguration: imageConfig)
    //let settingsImage = UIImage(systemName: "person", withConfiguration: imageConfig)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30)
//        let watchlistImage = UIImage(systemName: "text.badge.star", withConfiguration: imageConfig)
//        let settingsImage = UIImage(systemName: "person", withConfiguration: imageConfig)
        
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        movieskipIcon.contentMode = .scaleAspectFit
        
        watchListButton.setImage(watchlistImage?.withTintColor(#colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1), renderingMode: .alwaysOriginal), for: .normal)
        userButton.setImage(userImage?.withTintColor(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), renderingMode: .alwaysOriginal), for: .normal)
        
        watchListButton.addTarget(self, action: #selector(handleShowWatchlist), for: .touchUpInside)
        userButton.addTarget(self, action: #selector(handleShowUser), for: .touchUpInside)
        
        
        [watchListButton, UIView(), movieskipIcon, UIView(), userButton].forEach { view in
            addArrangedSubview(view)
        }
        
        distribution = .equalCentering
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 20, bottom: 0, right: 20)
    
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    //MARK: - Actions
    
    func clearActiveIcons() {
        watchListButton.setImage(watchlistImage?.withTintColor(#colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1), renderingMode: .alwaysOriginal), for: .normal)
        userButton.setImage(userImage?.withTintColor(#colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1), renderingMode: .alwaysOriginal), for: .normal)
    }
    
    @objc func handleShowWatchlist() {
        clearActiveIcons()
        watchListButton.setImage(watchlistImage?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal), for: .normal)
        delegate?.shouldShowWatchlist()
    }
    
    @objc func handleShowUser() {
        clearActiveIcons()
        userButton.setImage(userImage?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal), for: .normal)
        delegate?.shouldShowUser()
    }
    
}
