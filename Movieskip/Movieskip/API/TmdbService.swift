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
    
    static let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
    
    static func fetchMovies(filter: Filter, completion: @escaping([Movie]) -> Void) {
        let urlString = "\(TMDB_DISCOVER_BASE)\(filter.filterUrlString)"
                
        print("FETCHING PAGE: \(FilterService.filter.page)")
        
        if let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed), let url = URL(string: encoded) {

            AF.request(url).validate().responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    
                    let data = JSON(value)["results"]
                    
                    let moviesResult = data.arrayValue.map({ Movie(data: $0) })
                    
                    removeAlreadySwiped(allMovies: moviesResult) { newMovies in
                        completion(newMovies)
                    }
                    
                case .failure(let error):
                    debugPrint(error)
                }
            }
        }
    }
    
    static func removeAlreadySwiped(allMovies: [Movie], completion: ([Movie]) -> Void) {
        var newMovies = [Movie]()
        var swipedMovies = [Int]()
                        
        if let user = sceneDelegate.user {
            swipedMovies = user.watchlist + user.excluded + user.skipped
        } else if let localUser = sceneDelegate.localUser {
            swipedMovies = localUser.watchlist + localUser.excluded + localUser.skipped
        }
             
        print("All: \(swipedMovies.count)")
        
        allMovies.forEach { movie in
            if swipedMovies.contains(movie.id) {
                print("Movie: \(movie.title)")
                return
            }
            newMovies.append(movie)
        }
        completion(newMovies)
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

