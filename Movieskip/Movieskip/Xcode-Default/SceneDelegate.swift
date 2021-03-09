//
//  SceneDelegate.swift
//  Movieskip
//
//  Created by marchelmon on 2021-02-12.
//

import UIKit
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var user: User?
    
    override init() {
        super.init()
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
        
        updateFirebaseUser()
        
    }

    //MARK: - Helpers
    
    func setUser(user: User) {
        self.user = user
    }
    
    func addToWatchlist(movie: Int) {
        user?.watchlist.append(movie)
    }
    
    func addToExcluded(movie: Int) {
        user?.excluded.append(movie)
    }
    
    func addToSwiped(movie: Int) {
        user?.skipped.append(movie)
    }
    
    func addFriend(friend: User) {
        user?.friends.append(friend)
    }
    
    func setProfileImage(image: String) {
        user?.profileImage = image
    }
    
    func setUsername(username: String) {
        user?.username = username
    }
    
    func updateFirebaseUser() {
        print("ENTERED BACKGROUND")
        guard let user = user else { return }
        COLLECTION_USERS.document(user.uid).setData(user.dictionary)
    }

}

