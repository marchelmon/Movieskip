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
        
        print("Filter should be saved")
    }
    
    static func fetchFilter(completion: @escaping(Filter) -> Void) {
        
        let genresData = UserDefaults.standard.data(forKey: USER_DEFAULTS_GENRES_KEY)
        let genres = try! JSONDecoder().decode([Genre].self, from: genresData!)
        
        let minYear = UserDefaults.standard.float(forKey: USER_DEFAULTS_MINYEAR_KEY)
        let maxYear = UserDefaults.standard.float(forKey: USER_DEFAULTS_MAXYEAR_KEY)
        let popular = UserDefaults.standard.bool(forKey: USER_DEFAULTS_POPULAR_KEY)
        
        let filter = Filter(genres: genres, minYear: minYear, maxYear: maxYear, popular: popular)
        
        completion(filter)
    }
    
}
