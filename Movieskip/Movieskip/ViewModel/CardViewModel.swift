//
//  CardViewModel.swift
//  Movieskip
//
//  Created by marchelmon on 2021-02-15.
//

import UIKit

struct CardViewModel {
    
    let movie: Movie
    let poster: URL?
    let movieInfoText: NSAttributedString
    
    init(movie: Movie) {
        self.movie = movie
        
        if let posterPath = movie.posterPath {
            let posterString = TMDB_IMAGE_BASE + posterPath
            self.poster = URL(string: posterString)
        } else {
            poster = nil
        }

        let attributedText = NSMutableAttributedString(
            string: movie.title,
            attributes: [
                .font: UIFont.systemFont(ofSize: 18, weight: .heavy),
                .foregroundColor: UIColor.white
            ]
        )
        
        attributedText.append(
            NSAttributedString(
                string: "  \(movie.rating)",
                attributes: [
                    .font: UIFont.systemFont(ofSize: 12),
                    .foregroundColor: UIColor.white
                ]
            )
        )
        self.movieInfoText = attributedText
        
    }
    
    
}
