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
    
    lazy var watchlistStat = createStatIcon(statIcon: K.WATCHLIST_ICON)
    lazy var excludeStat = createStatIcon(statIcon: K.EXCLUDE_ICON)
    lazy var skipStat = createStatIcon(statIcon: K.SKIP_ICON)

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
                        //TODO: Alert till usern att något gick fel med hämtningen
                        print("ERROR-login-home: \(error.localizedDescription)")
                    }
                    if let snapshot = snapshot {
                        if let userData = snapshot.data() {
                            self.sceneDelegate.user = User(dictionary: userData)
                            if self.sceneDelegate.user?.username == "" { self.presentUsernameSelectionView() }
                            self.fetchFilterAndMovies()
                            self.setStatLabels()
                        }
                    }
                }
            } else {
                let userHasSkippedLoginPreviously = UserDefaults.standard.bool(forKey: "skippedLogin")
                if  !userHasSkippedLoginPreviously {
                    print("has skipped login: \(userHasSkippedLoginPreviously)")
                    presentLoginController()
                } else {
                    if sceneDelegate.localUser == nil { sceneDelegate.fetchLocalUser() }
                    fetchFilterAndMovies()
                    setStatLabels()
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
            sceneDelegate.user = nil
            sceneDelegate.allUsers = nil
            sceneDelegate.userFriends = []
            topCardView = nil
            cardViews = []
            moviesToDisplay = []
            viewModels = []
        } catch {
            //TODO: ALERT? nä
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
    
    func performSwipeAnimation(topCard: CardView, shouldExclude: Bool) {
        
        swipeAnimationReady = false
        
        let translation: CGFloat = shouldExclude ? -700 : 700
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.2, options: .transitionCurlDown) {
            topCard.frame = CGRect(x: translation, y: 0, width: (topCard.frame.width), height: (topCard.frame.height))
        } completion: { _ in
            
            self.swipeAnimationReady = true
            self.updateCardView()
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
    
    func updateCardView() {
        self.topCardView?.removeFromSuperview()
        guard !self.cardViews.isEmpty else { return }
        self.cardViews.remove(at: self.cardViews.count - 1)
        self.topCardView = self.cardViews.last
    }
    
    func setStatLabels() {
        if let user = sceneDelegate.user {
            
            self.excludeStat.setTitle(" \(user.excludedCount)", for: .normal)
            self.watchlistStat.setTitle(" \(user.watchListCount)", for: .normal)
            self.skipStat.setTitle(" \(user.skippedCount)", for: .normal)
            
        } else if let user = sceneDelegate.localUser {
            
            self.excludeStat.setTitle(" \(user.excluded.count)", for: .normal)
            self.watchlistStat.setTitle(" \(user.watchlist.count)", for: .normal)
            self.skipStat.setTitle(" \(user.skipped.count)", for: .normal)
            
        }

    }
    
    func configureUI() {
        view.backgroundColor = .white
        
        let spacer = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        let midStack = UIStackView(arrangedSubviews: [spacer, deckView, spacer])
        let statsStack = UIStackView(arrangedSubviews: [excludeStat, watchlistStat, skipStat])
        
        statsStack.alignment = .trailing
        statsStack.spacing = 30
        
        let alignmentStack = UIStackView()
        alignmentStack.axis = .vertical
        alignmentStack.alignment = .center
        alignmentStack.addArrangedSubview(statsStack)
        alignmentStack.heightAnchor.constraint(equalToConstant: 30).isActive = true

        
        let stack = UIStackView(arrangedSubviews: [topStack, alignmentStack, midStack, bottomStack])
        stack.spacing = 12
        stack.axis = .vertical

        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
                
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        
        stack.bringSubviewToFront(deckView)
    }
    
    func createStatIcon(statIcon: UIImage?) -> UIButton {
        let statView = UIButton(type: .system)
        statView.isEnabled = false
        statView.setImage(statIcon, for: .normal)
        statView.setTitleColor(.black, for: .normal)
        statView.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        return statView
    }
    
}

//MARK: - BottomControlsStackViewDelegate

extension HomeController: BottomControlsStackViewDelegate {
    
    func handleSkip() {
        if swipeAnimationReady {
            guard let topCard = topCardView else { return }
            sceneDelegate.addToSkipped(movie: topCard.viewModel.movie.id)
            performSwipeAnimation(topCard: topCard, shouldExclude: false)
            setStatLabels()
        }
    }
    
    func handleExclude() {
        if swipeAnimationReady {
            guard let topCard = topCardView else { return }
            sceneDelegate.addToExcluded(movie: topCard.viewModel.movie.id)
            performSwipeAnimation(topCard: topCard, shouldExclude: true)
            setStatLabels()
        }
    }
    
    func handleAddWatchlist() {
        guard let topCard = topCardView else { return }
        sceneDelegate.addToWatchlist(movie: topCard.viewModel.movie.id)
        setStatLabels()
        updateCardView()
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
                
        didLikeMovie ? sceneDelegate.addToSkipped(movie: movieId) : sceneDelegate.addToExcluded(movie: movieId)
        
        setStatLabels()
        
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
        let controller = WatchlistController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
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

