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
    
    static let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
    
    static func userIsLoggedIn() -> Bool {
        return Auth.auth().currentUser != nil
    }
    
    static func logUserIn(withEmail email: String, withPassword password: String, completion: AuthDataResultCallback?) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    static func registerUser(email: String, password: String, completion: @escaping ((Error?) -> Void)) {
    
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                completion(error)
                return
            }
            
            guard let result = result else { return }
            result.user.sendEmailVerification { error in
                if let error = error {
                    print("ERROR VER-EMAIL: \(error.localizedDescription)")
                }
            }
            let uid = result.user.uid
            
            let data = ["email": email, "uid": uid] as [String : Any]
            
            COLLECTION_USERS.document(uid).setData(data, completion: completion)
        
        }
    }
    
    static func resetUserPassword(email: String, completion: @escaping ((Error?) -> Void)) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            completion(error)
        }
    }
    
    static func socialSignIn(credential: AuthCredential, completion: @escaping ((Error?) -> Void)) {
        Auth.auth().signIn(with: credential) { (data, error) in
            if let error = error {
                print("ERROR signing in: \(error.localizedDescription)")
                completion(error)
                return
            }
            if let data = data {
                COLLECTION_USERS.document(data.user.uid).getDocument { (snapshot, error) in
            
                    if let error = error {
                        print("ERROR GETTING DATA: \(error.localizedDescription)")
                        completion(error)
                        return
                    }
                    
                    if let snapshot = snapshot {
                        if snapshot.exists {
                            guard let userData = snapshot.data() else { return }
                            let user = User(dictionary: userData)
                            sceneDelegate.setUser(user: user)
                            completion(nil)
                        } else {
                            let userData: [String: Any] = ["uid": data.user.uid, "email": data.user.email ?? ""]
                            
                            let newUser = User(dictionary: userData)
                            sceneDelegate.setUser(user: newUser)
                            
                            COLLECTION_USERS.document(data.user.uid).setData(newUser.dictionary) { error in
                                completion(error)
                            }
                        }
                    }
                }
            }
        }
    }
    
}
