//
//  HomeController.swift
//  Movieskip
//
//  Created by marchelmon on 2021-02-12.
//

import UIKit

class HomeController: UIViewController {
    
    //MARK: - Properties
    
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
        //fetchMovie()
        fetchMovies()
        
    }
    
    
    //MARK: - API
    
    func fetchMovie() {
        TmdbService.fetchMovie(withId: "504949") { movie in
            let viewModel = CardViewModel(movie: movie)
            let cardView = CardView(viewModel: viewModel)
            self.deckView.addSubview(cardView)
            cardView.fillSuperview()
            self.topCard = cardView
        }
    }
    
    func fetchMovies() {
        TmdbService.fetchMovies(filter: Filter(), completion: { movies in
            self.viewModels = movies.map({ CardViewModel(movie: $0) })
        })
    }
    
    
    //MARK: - Helpers
    
    func configureCards() {
        for viewModel in viewModels {
            let cardView = CardView(viewModel: viewModel)
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
    
}


extension HomeController: BottomControlsStackViewDelegate {
    func handleLike() {
        print("Pressed like")
    }
    
    func handleDislike() {
        print("Pressed dislike")
    }
    
    func handleShowFilter() {
        let controller = FilterController()
        //controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    func handleShowWatchlist() {
        print("Pressed watchlist")
    }
    
    
}
