//
//  SceneDelegate.swift
//  Movieskip
//
//  Created by marchelmon on 2021-02-12.
//

import UIKit
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    //MARK: - Properties
    
    var window: UIWindow?
    var user: User?
    var localUser: LocalUser?
    
    //MARK: - Lifecycle
    
    override init() {
        super.init()
        fetchAndSetUser()
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        window?.makeKeyAndVisible()
        window?.rootViewController = HomeController()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        saveUserDataOnExit()
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        saveUserDataOnExit()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        saveUserDataOnExit()
    }
    
    //MARK: - Fetch firebase user and lcoaluser
    
    func fetchAndSetUser() {
        if let authenticatedUser = Auth.auth().currentUser {
            AuthService.fetchLoggedInUser(uid: authenticatedUser.uid) { (snapshot, error) in
                
                if let error = error { print("ERROR: \(error.localizedDescription)") }
                
                if let snapshot = snapshot {
                    if let userData = snapshot.data() {
                        self.user = User(dictionary: userData)
                    }
                } else {
                    self.fetchLocalUser()
                }
            }
        } else {
            fetchLocalUser()
        }
    }
    
    func fetchLocalUser() {
        let watchlist = UserDefaults.standard.object(forKey: "watchlist") as? [Int] ?? []
        let excluded = UserDefaults.standard.object(forKey: "excluded") as? [Int] ?? []
        let skipped = UserDefaults.standard.object(forKey: "skipped") as? [Int] ?? []
        
        let data = ["watchlist": watchlist, "excluded": excluded, "skipped": skipped]
        
        if watchlist.count != 0 || excluded.count != 0 || skipped.count != 0 {
            print("THERE IS A USER DEFAULTS USER")
            localUser = LocalUser(data: data)
        }
    }

    //MARK: - Update user data
    
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
    
    //MARK: - Update firebase and local user
    
    func saveUserDataOnExit() {
        updateFirebaseUser()
        updateLocalUserDefaults()
        UserDefaults.standard.set(false, forKey: "skippedLogin") //TODO: ta bort?
    }
    
    func updateFirebaseUser() {
        guard let user = user else { return }
        COLLECTION_USERS.document(user.uid).setData(user.dictionary)
    }
    
    func updateLocalUserDefaults() {
        if let user = localUser {
            print("SAVE TO USER DEFAUTLS")
            UserDefaults.standard.set(user.watchlist, forKey: "watchlist")
            UserDefaults.standard.set(user.excluded, forKey: "excluded")
            UserDefaults.standard.set(user.skipped, forKey: "skipped")
        }
    }
    
    //TODO: TA BORT! Bara till för att testa annars
    func clearDefaults() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }

}

