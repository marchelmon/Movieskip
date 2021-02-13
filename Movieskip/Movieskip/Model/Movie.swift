//
//  Movie.swift
//  Movieskip
//
//  Created by marchelmon on 2021-02-13.
//

import Foundation

struct Movie {
    let id: String
    let title: String
    let rating: Double//FLOAT?
    let description: String
    let ImageURL: URL?
    let releaseYear: String
    
    init(data: [String: Any]) {
        id = data["id"] as? String ?? ""
        title = data["title"] as? String ?? "Good movie"
        description = data["id"] as? String ?? ""
        rating = data["rating"] as? Double ?? 5.0
        ImageURL = data["poster"] as? URL ?? URL(string: "")
        releaseYear = data["releaseYear"] as? String ?? "1995"
    }
    
}
