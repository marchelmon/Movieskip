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
        self.user = User(uid: "345", email: "hej", username: "hej", watchlist: [], excluded: [], skipped: [], friends: [], profileImage: "sjsd")
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        window?.makeKeyAndVisible()
        window?.rootViewController = HomeController()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        //Save user to firebase
        //Service.saveUserData(user: user, completition)
    }

    //MARK: - Helpers
    
    func setUser(user: User) {
        self.user = user
    }
    
    func addToWatchlist(movie: Movie) {
        user.watchlist.append(movie)
    }
    
    func addToExcluded(movie: Movie) {
        user.excluded.append(movie)
    }
    
    func addToSwiped(movie: Movie) {
        user.skipped.append(movie)
    }
    
    func addFriend(friend: User) {
        user.friends.append(friend)
    }
    
    func setProfileImage(image: String) {
        user.profileImage = image
    }

}

