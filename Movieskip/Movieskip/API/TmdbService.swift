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
        
        let urlString = "\(TMDB_DISCOVER_BASE)\(filter.prepareFilterString())"
        
        if let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),let url = URL(string: encoded) {

            AF.request(url).validate().responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    
                    let data = JSON(value)["results"]
                    
                    movies = data.arrayValue.map({ Movie(data: $0) })
                    
                    completion(movies)

                case .failure(let error):
                    debugPrint(error)
                }
            }
        }
    }
    
    static func fetchMovieWithDetails(withId id: Int, completion: @escaping(Movie) -> Void) {
        let url = "\(TMDB_MOVIE_BASE)\(id)?api_key=\(TMDB_API_KEY)&append_to_response=credits,videos,images,reviews"
                                
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

