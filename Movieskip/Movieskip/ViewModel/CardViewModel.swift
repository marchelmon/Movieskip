//
//  CardViewModel.swift
//  Movieskip
//
//  Created by marchelmon on 2021-02-15.
//

import UIKit

struct CardViewModel {
    
    let movie: Movie
    let movieInfoText: NSAttributedString
    
    init(movie: Movie) {
        self.movie = movie

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
