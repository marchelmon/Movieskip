//
//  WatchlistTableCell.swift
//  Movieskip
//
//  Created by marchelmon on 2021-03-16.
//

import UIKit

class WatchlistTableCell: UITableViewCell {
        
    let poster: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    let movieTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = MAIN_COLOR
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    let rating: UILabel = {
        let label = UILabel()
        label.textColor = MAIN_COLOR
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        addSubview(poster)
        poster.anchor(top: topAnchor, left: leftAnchor, paddingTop: 8, width: 120 / 1.5, height: 120)
        
        addSubview(movieTitle)
        movieTitle.anchor(top: topAnchor, left: poster.rightAnchor, paddingTop: 15, paddingLeft: 20)
        
        addSubview(rating)
        rating.anchor(top: movieTitle.bottomAnchor, left: poster.rightAnchor, paddingTop: 10, paddingLeft: 20)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
