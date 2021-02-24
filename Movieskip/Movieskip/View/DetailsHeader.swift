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
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = 7
        iv.clipsToBounds = true
        return iv
    }()

    lazy var rating: UIButton = {
        let rating = UIButton()
        rating.setTitle("  \(movie.rating)/10", for: .normal)
        rating.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        rating.setTitleColor(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), for: .normal)
        rating.setImage(UIImage(systemName: "star.fill")?.withTintColor(#colorLiteral(red: 0.9529411793, green: 0.8256965162, blue: 0.1009962625, alpha: 1), renderingMode: .alwaysOriginal), for: .normal)
        rating.imageView?.setDimensions(height: 30, width: 30)
        return rating
    }()
    
    lazy var releaseLabel: UILabel = {
        let label = UILabel()
        label.text = "\(self.movie.released)"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        return label
    }()
    
    let trailerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Watch trailer", for: .normal)
        button.tintColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.layer.borderWidth = 1
        button.layer.borderColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        button.layer.cornerRadius = 8
        return button
    } ()
    
    let genresLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = movie.title
        label.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    lazy var overviewText: UILabel = {
        let label = UILabel()
        label.text = movie.overview
        label.numberOfLines = 5
        return label
    }()
    
    //MARK: - Lifecycle
    
    init(movie: Movie) {
        self.movie = movie
        super.init(frame: .zero)
        backgroundColor = .systemGroupedBackground
        
        frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)

        addSubview(posterImage)
        posterImage.anchor(top: safeAreaLayoutGuide.topAnchor, left: leftAnchor, paddingTop: 15, paddingLeft: 15)
        posterImage.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.45).isActive = true
        posterImage.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.45 * 1.5).isActive = true
        
        
        addSubview(rating)
        addSubview(releaseLabel)
        addSubview(trailerButton)
        
        rating.anchor(top: safeAreaLayoutGuide.topAnchor, left: posterImage.rightAnchor, paddingTop: 18, paddingLeft: 10)
        releaseLabel.anchor(top: rating.bottomAnchor, left: posterImage.rightAnchor, paddingTop: 4, paddingLeft: 10)
        trailerButton.anchor(top: releaseLabel.bottomAnchor, left: posterImage.rightAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 10, paddingRight: 15)
        
                
        if let posterUrl = URL(string: "\(TMDB_IMAGE_BASE)\(movie.posterPath!)") {
            posterImage.sd_setImage(with: posterUrl)
        }

        addSubview(genresLabel)

        genresLabel.anchor(top: trailerButton.bottomAnchor, left: posterImage.rightAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 10, paddingRight: 5)

        addSubview(titleLabel)
        addSubview(overviewText)
        
        
        titleLabel.anchor(top: posterImage.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 20, paddingRight: 20)
        overviewText.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 20, paddingRight: 20)

        for (index, genre) in movie.genres.enumerated() {
            if movie.genres.count == index + 1 {
                genresLabel.text?.append("\(genre.name)")
            } else {
                genresLabel.text?.append("\(genre.name), ")
            }
        }
    
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
        
        label.layer.borderWidth = 2
        label.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        label.text = genre
        
        return label
    }
    
    func createRatingView() -> UIView{
        let ratingView = UIView()
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "\(movie.rating)/10"
        
        return ratingView
    }
    
}
