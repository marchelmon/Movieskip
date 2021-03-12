//
//  Service.swift
//  Movieskip
//
//  Created by marchelmon on 2021-02-13.
//

import Foundation


struct FilterService  {
    
    static var filter: Filter = Filter(genres: TMDB_GENRES, minYear: 2000, maxYear: 2021, popular: false, page: 1)
    
    static var totalPages = 10
    
    static func saveFilter() {
        
        let genres = try! JSONEncoder().encode(filter.genres)
        
        UserDefaults.standard.set(genres, forKey: USER_DEFAULTS_GENRES_KEY)
        UserDefaults.standard.set(filter.minYear, forKey: USER_DEFAULTS_MINYEAR_KEY)
        UserDefaults.standard.set(filter.maxYear, forKey: USER_DEFAULTS_MAXYEAR_KEY)
        UserDefaults.standard.set(filter.popular, forKey: USER_DEFAULTS_POPULAR_KEY)
        
        if filter.page != 1 { filter.page -= 1 }
        UserDefaults.standard.set(filter.page, forKey: USER_DEFAULTS_PAGE_KEY)
        
    }
    
    static func fetchFilter(completion: @escaping(Filter) -> Void) {
        
        if  let genresData = UserDefaults.standard.data(forKey: USER_DEFAULTS_GENRES_KEY) {
            filter.genres = try! JSONDecoder().decode([Genre].self, from: genresData)
            filter.minYear = UserDefaults.standard.float(forKey: USER_DEFAULTS_MINYEAR_KEY)
            filter.maxYear = UserDefaults.standard.float(forKey: USER_DEFAULTS_MAXYEAR_KEY)
            filter.popular = UserDefaults.standard.bool(forKey: USER_DEFAULTS_POPULAR_KEY)
            filter.page = UserDefaults.standard.integer(forKey: USER_DEFAULTS_PAGE_KEY)
        }
                
        completion(filter)
    }
    
}
