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
    
    
    private var filter: Filter?
    
    private var topCard: CardView?
    private var viewModels = [CardViewModel]() {
        didSet { configureCards() }
    }
    
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
        configureUI()
        fetchFilterAndMovies()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkIfUserIsLoggedIn()
    }
    
    //MARK: - API
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser == nil {
            presentRegisterController()
        } else {
            print("USER IS LOGGED IN ALREADY")
        }
    }
    
    func fetchFilterAndMovies() {
        Service.fetchFilter { filter in
            self.filter = filter
            self.fetchMovies(filter: filter)
        }
    }
    
    func fetchMovies(filter: Filter) {
        TmdbService.fetchMovies(filter: filter, completion: { movies in
            self.viewModels = movies.map({ CardViewModel(movie: $0) })
        })
    }
    
    //MARK: - Helpers
    
    func configureCards() {
        for view in deckView.subviews{
            view.removeFromSuperview()
        }
        for viewModel in viewModels {
            let cardView = CardView(viewModel: viewModel)
            cardView.delegate = self
            deckView.addSubview(cardView)
            cardView.fillSuperview()
        }
    }
    
    func configureUI() {
        view.backgroundColor = .white
        
        let stack = UIStackView(arrangedSubviews: [topStack, deckView , bottomStack])
        
        view.addSubview(stack)
        
        stack.axis = .vertical
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        
        bottomStack.anchor(bottom: view.bottomAnchor, paddingBottom: 25)
        
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = .init(top: 0, left: 15, bottom: 0, right: 15)
        
        stack.bringSubviewToFront(deckView)
    }
    
    func presentRegisterController() {
        DispatchQueue.main.async {
            let controller = RegistrationController()
            controller.delegate = self
            let nav = UINavigationController(rootViewController: controller)
            nav.modalTransitionStyle = .flipHorizontal
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
    
}

//MARK: - BottomControlsStackViewDelegate

extension HomeController: BottomControlsStackViewDelegate {
    func handleLike() {
        print("Pressed like")
    }
    
    func handleDislike() {
        print("Pressed dislike")
    }
    
    func handleShowFilter() {
        
        let currentFilter = self.filter ?? Filter(genres: TMDB_GENRES, minYear: 2000, maxYear: 2021, popular: true)
        let filterView = FilterView()
        filterView.viewModel = FilterViewModel(filter: currentFilter)
        let controller = FilterController(filterView: filterView)
        controller.delegate = self
                
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    func handleShowWatchlist() {
        print("Pressed watchlist")
    }
    
}

//MARK: - FilterControllerDelegate

extension HomeController: FilterControllerDelegate {
    
    func filterController(controller: FilterController, wantsToUpdateFilter filter: Filter) {
        self.filter = filter
        Service.saveFilter(filter: filter)
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
}

//MARK: - AutheticationDelegate

extension HomeController: AuthenticationDelegate {
    func authenticationComplete() {
        dismiss(animated: true, completion: nil)
        //Fetch user and
    }
}
