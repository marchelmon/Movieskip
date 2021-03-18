//
//  WatchlistTableCell.swift
//  Movieskip
//
//  Created by marchelmon on 2021-03-16.
//

import UIKit

class WatchlistTableCell: UITableViewCell {
    
    var movie: Movie?
    
    private let poster: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let movieTitle: UILabel = {
        let label = UILabel()
        label.textColor = MAIN_COLOR
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Helpers
    
    func configureUI() {
        
        guard let movie = movie else { return }
        
        poster.sd_setImage(with: movie.posterPath)
        
        addSubview(poster)
        poster.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor)
        
    }
    
}
