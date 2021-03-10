//
//  BottomControlsStackView.swift
//  Movieskip
//
//  Created by marchelmon on 2021-02-12.
//

import UIKit

protocol BottomControlsStackViewDelegate: class {
    func handleSkip()
    func handleExclude()
    func handleShowFilter()
    func handleAddWatchlist()
}

class BottomControlsStackView: UIStackView {
    //MARK: - Properties
    
    weak var delegate: BottomControlsStackViewDelegate?
    
    private let excludeButton = UIButton(type: .system)
    private let skipButton = UIButton(type: .system)
    private let watchlistButton = UIButton(type: .system)
    private let refreshButton = UIButton(type: .system)
    private let filterButton = UIButton(type: .system)

    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        distribution = .fillEqually
        
        let gearImage = UIImage(systemName: "gearshape.fill")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        
        excludeButton.setImage(#imageLiteral(resourceName: "dismiss_circle").withRenderingMode(.alwaysOriginal), for: .normal)
        skipButton.setImage(#imageLiteral(resourceName: "like_circle").withRenderingMode(.alwaysOriginal), for: .normal)
        watchlistButton.setImage(#imageLiteral(resourceName: "super_like_circle").withRenderingMode(.alwaysOriginal), for: .normal)
        filterButton.setImage(gearImage, for: .normal)

        
        //Actions for buttons goes here
        excludeButton.addTarget(self, action: #selector(handleDislike), for: .touchUpInside)
        skipButton.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        watchlistButton.addTarget(self, action: #selector(handleShowWatchlist), for: .touchUpInside)
        filterButton.addTarget(self, action: #selector(handleShowFilter), for: .touchUpInside)

        
        
        [filterButton, excludeButton, skipButton, watchlistButton].forEach { view in
            addArrangedSubview(view)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    
    @objc func handleDislike() {
        delegate?.handleExclude()
    }
    
    @objc func handleLike() {
        delegate?.handleSkip()
    }
    
    @objc func handleShowFilter() {
        delegate?.handleShowFilter()
    }
    
    @objc func handleShowWatchlist() {
        delegate?.handleAddWatchlist()
    }
}
