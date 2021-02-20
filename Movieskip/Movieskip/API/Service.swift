//
//  Service.swift
//  Movieskip
//
//  Created by marchelmon on 2021-02-13.
//

import Foundation


struct Service  {
    
    static func saveFilter(filter: Filter) {
        
        let genres = try! JSONEncoder().encode(filter.genres)
        
        UserDefaults.standard.set(genres, forKey: USER_DEFAULTS_GENRES_KEY)
        UserDefaults.standard.set(filter.minYear, forKey: USER_DEFAULTS_MINYEAR_KEY)
        UserDefaults.standard.set(filter.maxYear, forKey: USER_DEFAULTS_MAXYEAR_KEY)
        UserDefaults.standard.set(filter.popular, forKey: USER_DEFAULTS_POPULAR_KEY)
        
    }
    
    static func fetchFilter(completion: @escaping(Filter) -> Void) {
        
        var genres: [Genre] = TMDB_GENRES
        var minYear: Float = 2000
        var maxYear: Float = 2021
        var popular: Bool = false
        
        if  let genresData = UserDefaults.standard.data(forKey: USER_DEFAULTS_GENRES_KEY) {
            genres = try! JSONDecoder().decode([Genre].self, from: genresData)
            minYear = UserDefaults.standard.float(forKey: USER_DEFAULTS_MINYEAR_KEY)
            maxYear = UserDefaults.standard.float(forKey: USER_DEFAULTS_MAXYEAR_KEY)
            popular = UserDefaults.standard.bool(forKey: USER_DEFAULTS_POPULAR_KEY)
        }

        let filter = Filter(genres: genres, minYear: minYear, maxYear: maxYear, popular: popular)
        
        completion(filter)
    }
    
}
