//
//  MovieskipController.swift
//  Movieskip
//
//  Created by marchelmon on 2021-04-15.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKCoreKit

class MovieskipController: UIViewController {
    
    //MARK: - Properties
    
    private let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
    
    private let topStack = HomeNavigationStackView()
    
    let swipeView = SwipeView()
    let watchlistView = WatchlistView()
    let userView = UserView()
        
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        swipeView.delegate = self
        watchlistView.delegate = self
        userView.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
                
        if swipeView.topCardView == nil {
            swipeView.configureUserAndFetchMovies()
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            presentLoginController()
            sceneDelegate.user = nil
            sceneDelegate.userFriends = []
        } catch {
            //TODO: ALERT? nä
            print("Failed to log user out")
        }
    }
    
    func presentUsernameSelectionView() {
        let controller = UsernameController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    func presentLoginController() {
        DispatchQueue.main.async {
            let controller = LoginController()
            controller.delegate = self
            let nav = UINavigationController(rootViewController: controller)
            nav.modalTransitionStyle = .flipHorizontal
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    func configureUI() {
        view.backgroundColor = .white
        
        userView.isHidden = false
        watchlistView.isHidden = true
        swipeView.isHidden = true
        
        view.addSubview(topStack)
        topStack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        
        view.addSubview(swipeView)
        swipeView.anchor(top: topStack.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingTop: 5, width: view.frame.width)

        view.addSubview(watchlistView)
        watchlistView.anchor(top: topStack.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingTop: 5, width: view.frame.width)

        view.addSubview(userView)
        userView.anchor(top: topStack.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingTop: 5, width: view.frame.width)
        
    }
    
}

extension MovieskipController: SwipeViewDelegate {
    func showMovieDetails(for movie: Movie) {
        let controller = DetailsController(movie: movie)
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    func showFilter() {
        let controller = FilterController()
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    func presentSelectUsername() {
        presentUsernameSelectionView()
    }
    func presentLogin() {
        presentLoginController()
    }
}

extension MovieskipController: FilterControllerDelegate {
    func filterController(controller: FilterController, wantsToUpdateFilter filter: Filter) {
        FilterService.filter = filter
        swipeView.moviesToDisplay = []
        swipeView.fetchMovies(filter: filter)
        controller.dismiss(animated: true, completion: nil)
    }
}


extension MovieskipController: AuthenticationDelegate {
    func authenticationComplete() {
        dismiss(animated: true) {
            self.swipeView.setStatLabels()
            if self.sceneDelegate.user?.username == "" {
                self.presentUsernameSelectionView()
            }
        }
    }
}

extension MovieskipController: WatchlistViewDelegate {
    func goToCombineWatchlist() {
        let controller = CombineWatchlistController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    func presentMovieDetails(movie: Movie) {
        let controller = DetailsController(movie: movie)
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
}

extension MovieskipController: UserViewDelegate {
    func userPressedLogout() {
        logout()
    }
    
    func userPressedRegister() {
        presentLoginController()
    }
}
