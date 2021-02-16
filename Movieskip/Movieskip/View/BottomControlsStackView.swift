//
//  BottomControlsStackView.swift
//  Movieskip
//
//  Created by marchelmon on 2021-02-12.
//

import UIKit

protocol BottomControlsStackViewDelegate: class {
    func handleLike()
    func handleDislike()
    func handleShowFilter()
    func handleShowWatchlist()
}

class BottomControlsStackView: UIStackView {
    //MARK: - Properties
    
    weak var delegate: BottomControlsStackViewDelegate?
    
    private let dislikeButton = UIButton(type: .system)
    private let likeButton = UIButton(type: .system)
    private let watchlistButton = UIButton(type: .system)
    private let refreshButton = UIButton(type: .system)
    private let filterButton = UIButton(type: .system)

    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        distribution = .fillEqually
        
        let gearImage = UIImage(systemName: "gearshape.fill")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        
        dislikeButton.setImage(#imageLiteral(resourceName: "dismiss_circle").withRenderingMode(.alwaysOriginal), for: .normal)
        likeButton.setImage(#imageLiteral(resourceName: "like_circle").withRenderingMode(.alwaysOriginal), for: .normal)
        watchlistButton.setImage(#imageLiteral(resourceName: "super_like_circle").withRenderingMode(.alwaysOriginal), for: .normal)
        filterButton.setImage(gearImage, for: .normal)

        
        //Actions for buttons goes here
        dislikeButton.addTarget(self, action: #selector(handleDislike), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        watchlistButton.addTarget(self, action: #selector(handleShowWatchlist), for: .touchUpInside)
        filterButton.addTarget(self, action: #selector(handleShowFilter), for: .touchUpInside)

        
        
        [filterButton, dislikeButton, likeButton, watchlistButton].forEach { view in
            addArrangedSubview(view)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    
    @objc func handleDislike() {
        delegate?.handleDislike()
    }
    
    @objc func handleLike() {
        delegate?.handleLike()
    }
    
    @objc func handleShowFilter() {
        delegate?.handleShowFilter()
    }
    
    @objc func handleShowWatchlist() {
        delegate?.handleShowWatchlist()
    }
}
