//
//  CardViewModel.swift
//  Movieskip
//
//  Created by marchelmon on 2021-02-15.
//

import Foundation
import UIKit

struct CardViewModel {
    
    let movie: Movie
    let title: String
    let relased: String
    let poster: URL?
    let rating: String
    let movieInfoText: NSAttributedString
    
    init(movie: Movie) {
        self.movie = movie
        self.title = movie.title
        self.relased = movie.released
        self.rating = String(movie.rating)
        
        if let posterPath = movie.posterPath {
            let posterString = TMDB_IMAGE_BASE + posterPath
            self.poster = URL(string: posterString)
        } else {
            poster = nil
        }

        let attributedText = NSMutableAttributedString(
            string: movie.title,
            attributes: [
                .font: UIFont.systemFont(ofSize: 28, weight: .heavy),
                .foregroundColor: UIColor.white
            ]
        )
        
        attributedText.append(
            NSAttributedString(
                string: "  \(movie.rating)",
                attributes: [
                    .font: UIFont.systemFont(ofSize: 18),
                    .foregroundColor: UIColor.white
                ]
            )
        )
        self.movieInfoText = attributedText
        
    }
    
    
}
