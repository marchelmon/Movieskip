//
//  DetailsHeaderView.swift
//  Movieskip
//
//  Created by marchelmon on 2021-02-22.
//

import UIKit


class DetailsHeader: UIView {
    
    //MARK: - Properties
    
    let movie: Movie
    
    let posterImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.borderWidth = 5
        iv.layer.borderColor = #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1)
        iv.image = #imageLiteral(resourceName: "top_left_profile")
        return iv
    }()
    
    let superButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 10
        button.setTitle("Go Back", for: .normal)
        button.clipsToBounds = true
        button.imageView?.contentMode = .scaleAspectFill
        button.backgroundColor = .white

        return button
    }()
        
    let ratingLabel: UILabel = {
        let label = UILabel()
        label.text = "Rating"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .systemBlue
        return label
    }()
    
    let releaseLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let trailerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Watch trailer", for: .normal)
        button.tintColor = .systemBlue
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        return button
    } ()
    
    let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Dismiss controller", for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        button.backgroundColor = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
        button.tintColor = .white
        button.titleEdgeInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        return button
    }()
    
    let genreView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    
    
    //MARK: - Lifecycle
    
    init(movie: Movie) {
        self.movie = movie
        super.init(frame: .zero)
        backgroundColor = .systemGroupedBackground
        
//        addSubview(posterImage)
//
//        posterImage.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: 20)
//
        addSubview(superButton)
        
        superButton.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: 20)
        superButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.45).isActive = true

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Actions
    
    @objc func handleDismiss() {
        print("SHOULD DISMISS!")
    }
    
    //MARK: - Helpers
    
    func createGenreLabel(genre: String) -> UILabel {
        let label = UILabel()
        
        label.layer.borderWidth = 3
        label.layer.borderColor = #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1)
        label.text = genre
        
        return label
    }
    
}
