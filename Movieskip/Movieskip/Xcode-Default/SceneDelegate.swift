//
//  SceneDelegate.swift
//  Movieskip
//
//  Created by marchelmon on 2021-02-12.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var user: User
    
    override init() {
        let userDictionary: [String: Any] = ["uid": "1232", "email": "hej"]
        self.user = User(dictionary: userDictionary)
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        window?.makeKeyAndVisible()
        window?.rootViewController = HomeController()
    }

    func sceneWillEnterForeground(_ scene: UIScene) {

    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        //Save user to firebase
        //Service.saveUserData(user: user, completition)
    }

    //MARK: - Helpers
    
    func setUser(user: User) {
        self.user = user
    }
    
    func addToWatchlist(movie: Int) {
        user.watchlist.append(movie)
    }
    
    func addToExcluded(movie: Int) {
        user.excluded.append(movie)
    }
    
    func addToSwiped(movie: Int) {
        user.skipped.append(movie)
    }
    
    func addFriend(friend: User) {
        user.friends.append(friend)
    }
    
    func setProfileImage(image: String) {
        user.profileImage = image
    }

}

