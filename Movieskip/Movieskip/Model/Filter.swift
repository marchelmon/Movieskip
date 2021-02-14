//
//  Filter.swift
//  Movieskip
//
//  Created by marchelmon on 2021-02-13.
//

import Foundation

struct Filter {
    var genres: [String] = []
    var minYear: String = "1990"
    var maxYear: String = "2021"
    var popular: Bool = true
    
    private func prepareFiltreString() -> String {
        var requestString: String = "&language=en&release_date.gte=\(minYear)&release_date.lte=\(maxYear)"
        requestString.append(popular ? "&vote_average.gte=7" : "")
        requestString.append(popular ? "&vote_count.gte=1000" : "&vote_count.gte=100")
        
        if genres.count != 0 {
            requestString.append("&with_genres")
            self.genres.forEach { genre in
                requestString.append("\(genre),")
            }
        }
        return requestString
    }
    
    
}
