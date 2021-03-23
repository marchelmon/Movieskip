//
//  HomeNavigationStack.swift
//  Movieskip
//
//  Created by marchelmon on 2021-02-12.
//

import UIKit

protocol HomeNavigationStackViewDelegate: class {
    func shouldShowWatchlist()
    func shouldShowSettings()
}

class HomeNavigationStackView: UIStackView {
    
    //MARK: - Properties
    
    weak var delegate: HomeNavigationStackViewDelegate?

    private lazy var movieskipIcon = UIImageView(image: MOVIESKIP_ICON)
    private let watchListButton = UIButton(type: .system)
    private let settingsButton = UIButton(type: .system)
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30)
        let watchlistImage = UIImage(systemName: "text.badge.star", withConfiguration: imageConfig)?.withTintColor(#colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1), renderingMode: .alwaysOriginal)
        let settingsImage = UIImage(systemName: "person", withConfiguration: imageConfig)?.withTintColor(#colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1), renderingMode: .alwaysOriginal)
        
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        movieskipIcon.contentMode = .scaleAspectFit
        
        watchListButton.setImage(watchlistImage, for: .normal)
        settingsButton.setImage(settingsImage, for: .normal)
        
        watchListButton.addTarget(self, action: #selector(handleShowWatchlist), for: .touchUpInside)
        settingsButton.addTarget(self, action: #selector(handleShowSettings), for: .touchUpInside)
        
        
        [watchListButton, UIView(), movieskipIcon, UIView(), settingsButton].forEach { view in
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
    
    @objc func handleShowWatchlist() {
        delegate?.shouldShowWatchlist()
    }
    
    @objc func handleShowSettings() {
        delegate?.shouldShowSettings()
    }
    
}
