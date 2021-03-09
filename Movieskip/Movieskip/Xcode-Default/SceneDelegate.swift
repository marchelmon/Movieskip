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
    var localUser: LocalUser?
    
    override init() {
        super.init()
        
        fetchLocalUserInDefaults()
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
        updateLocalUserDefaults()
        
    }

    //MARK: - Helpers
    
    func setUser(user: User) {
        self.user = user
    }
    
    func addToWatchlist(movie: Int) {
        
        if user != nil {
            user?.watchlist.append(movie)
            return
        }
        
        if localUser != nil {
            localUser?.watchlist.append(movie)
        }
    }
    
    func addToExcluded(movie: Int) {

        if user != nil {
            user?.excluded.append(movie)
            return
        }
        
        if localUser != nil {
            localUser?.excluded.append(movie)
        }
        
    }
    
    func addToSkipped(movie: Int) {

        if user != nil {
            user?.skipped.append(movie)
            return
        }
        
        if localUser != nil {
            localUser?.skipped.append(movie)
        }

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
        guard let user = user else { return }
        COLLECTION_USERS.document(user.uid).setData(user.dictionary)
    }
    
    func fetchLocalUserInDefaults() {
        
        
        let watchlist = UserDefaults.standard.object(forKey: "watchlist") as? [Int] ?? [1, 3]
        let excluded = UserDefaults.standard.object(forKey: "excluded") as? [Int] ?? [2]
        let skipped = UserDefaults.standard.object(forKey: "skipped") as? [Int] ?? [3]
        
        let data = ["watchlist": watchlist, "excluded": excluded, "skipped": skipped]
        
        if watchlist.count != 0 || excluded.count != 0 || skipped.count != 0 {
            print("THERE IS A USER DEFAULTS USER")
            localUser = LocalUser(data: data)
        }
                
    }
    
    func updateLocalUserDefaults() {
        
        if localUser != nil {
            UserDefaults.standard.set(localUser?.watchlist, forKey: "watchlist")
            UserDefaults.standard.set(localUser?.excluded, forKey: "excluded")
            UserDefaults.standard.set(localUser?.skipped, forKey: "skipped")
        }
        
    }
    
    func clearDefaults() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }

}

