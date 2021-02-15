//
//  TmdbService.swift
//  Movieskip
//
//  Created by marchelmon on 2021-02-13.
//

import Foundation
import Alamofire
import SwiftyJSON


struct TmdbService {
    
    static func fetchMovies(filter: Filter, completion: @escaping([Movie]) -> Void) {
        var movies = [Movie]()
        
        let url = "\(TMDB_DISCOVER_BASE)\(filter.prepareFilterString())"
        
        AF.request(url).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                //debugPrint(json["results"])

            case .failure(let error):
                debugPrint(error)
            }
        }
            
    }
    
    static func fetchMovie(withId id: String, completion: @escaping(Movie) -> Void) {
        let url = "\(TMDB_MOVIE_BASE)\(id)?api_key=\(TMDB_API_KEY)"
                
        AF.request(url).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                
                
                let movie = Movie(data: JSON(value))
                
                completion(movie)

            case .failure(let error):
                debugPrint(error)
                
            }
        }
    }
}

struct MovieData: Codable {
    let name: String
}

