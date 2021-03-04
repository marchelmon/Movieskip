//
//  Service.swift
//  Movieskip
//
//  Created by marchelmon on 2021-02-13.
//

import Foundation
import Firebase


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



//MARK: - AuthService

struct AuthService {
    
    static func userIsLoggedIn() -> Bool{
        return Auth.auth().currentUser != nil
    }
    
    static func logUserIn(withEmail email: String, withPassword password: String, completion: AuthDataResultCallback?) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    static func registerUser(email: String, username: String, password: String, completion: @escaping ((Error?) -> Void)) {
    
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                completion(error)
                return
            }
            guard let uid = result?.user.uid else { return }
            
            let data = ["email": email, "username": username, "uid": uid] as [String : Any]
            
            COLLECTION_USERS.document(uid).setData(data, completion: completion)
            
        }
    }
    
    static func resetUserPassword(email: String, completion: @escaping ((Error?) -> Void)) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            completion(error)
        }
    }
    
}
