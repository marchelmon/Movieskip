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
        
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        swipeView.delegate = self
        
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
        
        view.addSubview(topStack)
        topStack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        
        swipeView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        
        
        view.addSubview(swipeView)
        swipeView.anchor(top: topStack.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingTop: 20, paddingBottom: 20)
             
        
        
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
        
    }
    func presentLogin() {
        
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
