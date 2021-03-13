//
//  HomeController.swift
//  Movieskip
//
//  Created by marchelmon on 2021-02-12.
//
import Firebase
import UIKit

class HomeController: UIViewController {
    
    //MARK: - Properties
    
    let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
    
    var swipeAnimationReady = true
        
    private var viewModels = [CardViewModel]() {
        didSet { configureCards() }
    }
    
    private var moviesToDisplay = [Movie]()
    
    private var topCardView: CardView?
    private var cardViews = [CardView]()
    
    private let topStack = HomeNavigationStackView()
    private let bottomStack = BottomControlsStackView()

    private let deckView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 10
        return view
    }()

    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bottomStack.delegate = self
        topStack.delegate = self
        configureUI()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        if topCardView == nil {
            configureUserAndFetchMovies()
        }
    }

    
    //MARK: - API
    
    func configureUserAndFetchMovies() {
        
        if let user = sceneDelegate.user {
            fetchFilterAndMovies()
            if user.username == "" { presentUsernameSelectionView() }
        } else {
            
            if let loggedInUser = Auth.auth().currentUser {
            
                AuthService.fetchLoggedInUser(uid: loggedInUser.uid) { (snapshot, error) in
                    
                    if let error = error {
                        print("ERROR-home: \(error.localizedDescription)")
                    }
                    
                    if let snapshot = snapshot {
                        if let userData = snapshot.data() {
                            self.sceneDelegate.user = User(dictionary: userData)
                            self.fetchFilterAndMovies()
                        }
                    }
                }
                
            } else {
                let userHasSkippedLoginPreviously = !UserDefaults.standard.bool(forKey: "skippedLogin")
                if  userHasSkippedLoginPreviously {
                    presentLoginController()
                }
            }
        }
    }
    
    func fetchFilterAndMovies() {
        FilterService.fetchFilter { filter in
            self.fetchMovies(filter: filter)
        }
    }
    
    func fetchMovies(filter: Filter) {
        if FilterService.filter.page == FilterService.totalPages { return }  //TODO: Present message about changing filter
        
        TmdbService.fetchMovies(completion: { movies in
            self.moviesToDisplay.append(contentsOf: movies)
            
            if self.moviesToDisplay.count > 15 {
                self.viewModels = self.moviesToDisplay.map({ CardViewModel(movie: $0) })
            } else {
                self.fetchMovies(filter: FilterService.filter)
            }
        })
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            presentLoginController()
        } catch {
            print("Failed to log user out")
        }
    }
    
    //MARK: - Actions
    
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
    
    //Animation, remove topcard and add movieid to skipped or excluded in sceneDelegate.user
    func performSwipeAnimation(shouldExclude: Bool) {
        guard let topCard = self.topCardView else { return }
        
        if !swipeAnimationReady { return }
        swipeAnimationReady = false
        
        let translation: CGFloat = shouldExclude ? -700 : 700
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.2, options: .transitionCurlDown) {
            topCard.frame = CGRect(x: translation, y: 0,
                                             width: (topCard.frame.width),
                                             height: (topCard.frame.height))
        } completion: { _ in
            self.swipeAnimationReady = true
            
            shouldExclude ?
                self.sceneDelegate.addToExcluded(movie: topCard.viewModel.movie.id) :
                self.sceneDelegate.addToSkipped(movie: topCard.viewModel.movie.id)
            
            self.topCardView?.removeFromSuperview()
            guard !self.cardViews.isEmpty else { return }
            self.cardViews.remove(at: self.cardViews.count - 1)
            self.topCardView = self.cardViews.last
        }
    }
    
    //MARK: - Helpers
    
    func configureCards() {
        for view in deckView.subviews {
            view.removeFromSuperview()
        }
        for viewModel in viewModels {
            let cardView = CardView(viewModel: viewModel)
            cardView.delegate = self
            deckView.addSubview(cardView)
            cardView.fillSuperview()
        }
        cardViews = deckView.subviews.map({ ($0 as? CardView)! })
        topCardView = cardViews.last
    }
    
    func configureUI() {
        view.backgroundColor = .white
        
        let spacer = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        let midStack = UIStackView(arrangedSubviews: [spacer, deckView, spacer])
        
        let stack = UIStackView(arrangedSubviews: [topStack, midStack, bottomStack])
        stack.spacing = 20
        
        view.addSubview(stack)
        
        stack.axis = .vertical
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        
        bottomStack.anchor(bottom: view.bottomAnchor, paddingBottom: 35)
        
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        
        stack.bringSubviewToFront(deckView)
    }
    
}

//MARK: - BottomControlsStackViewDelegate

extension HomeController: BottomControlsStackViewDelegate {
    
    func handleSkip() {
        performSwipeAnimation(shouldExclude: false)
    }
    
    func handleExclude() {
        performSwipeAnimation(shouldExclude: true)
    }
    
    func handleAddWatchlist() {
        guard let topCard = topCardView else { return }
        sceneDelegate.addToWatchlist(movie: topCard.viewModel.movie.id)
        
        self.topCardView?.removeFromSuperview()
        guard !self.cardViews.isEmpty else { return }
        self.cardViews.remove(at: self.cardViews.count - 1)
        self.topCardView = self.cardViews.last
    }
    
    func handleShowFilter() {
        let filterView = FilterView()
        filterView.viewModel = FilterViewModel(filter: FilterService.filter)
        let controller = FilterController(filterView: filterView)
        controller.delegate = self
                
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }

}

//MARK: - FilterControllerDelegate

extension HomeController: FilterControllerDelegate {
    
    func filterController(controller: FilterController, wantsToUpdateFilter filter: Filter) {
        FilterService.filter = filter
        self.fetchMovies(filter: filter)
        controller.dismiss(animated: true, completion: nil)
    }
    
}

//MARK: - CardViewDelegate

extension HomeController: CardViewDelegate {
    
    func cardView(_ view: CardView, wantsToShowDetailsFor movie: Movie) {
        let controller = DetailsController(movie: movie)
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    func cardView(_ view: CardView, didLikeMovie: Bool) {
        let movieId = view.viewModel.movie.id
                
        if didLikeMovie {
            sceneDelegate.addToSkipped(movie: movieId)
        } else {
            sceneDelegate.addToExcluded(movie: movieId)
        }
        
        view.removeFromSuperview()
        self.cardViews.removeAll(where: { view == $0 })
        self.topCardView = cardViews.last
    }
    
}

//MARK: - AutheticationDelegate

extension HomeController: AuthenticationDelegate {
    func authenticationComplete() {
        dismiss(animated: true) {
            if self.sceneDelegate.user?.username == "" {
                self.presentUsernameSelectionView()
            }
        }
    }
}

//MARK: - HomeNavigationStackViewDelegate

extension HomeController: HomeNavigationStackViewDelegate {
    func shouldShowWatchlist() {
        
    }
    
    func shouldShowSettings() {
        let controller = SettingsController()
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
}


//MARK: - SettingsControllerDelegate

extension HomeController: SettingsControllerDelegate {
    func settingsPressedLogout(controller: UIViewController) {
        controller.dismiss(animated: true) {
            self.logout()
        }
    }
    
    func settingsPressedRegister(controller: UIViewController) {
        controller.dismiss(animated: true) {
            self.presentLoginController()
        }
        
    }
}

