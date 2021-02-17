//
//  Movie.swift
//  Movieskip
//
//  Created by marchelmon on 2021-02-13.
//

import Foundation
import SwiftyJSON

struct Movie {
    let id: Int
    let title: String
    let rating: Double
    let overview: String
    let posterPath: String?
    let released: String
    var genres = [Genre]()
    
    
    init(data: JSON) {
        self.id = data["id"].int ?? 0
        self.title = data["title"].string ?? "No title found"
        self.posterPath = data["poster_path"].string ?? nil
        self.rating = data["vote_average"].double ?? 5.0
        self.released = data["release_date"].string ?? "Unknown"
        self.overview = data["overview"].string ?? "No description available"
        
        if !data["genres"].arrayValue.isEmpty {
            data["genres"].arrayValue.forEach({ value in
                guard let id = value["id"].int else { return }
                guard let name = value["name"].string else { return }
                let genre = Genre(name: name, id: id)
                genres.append(genre)
            })
        }
        
    }
    
}

struct Genre {
    let name: String
    let id: Int
    
    init(name: String, id: Int) {
        self.name = name
        self.id = id
    }
}


