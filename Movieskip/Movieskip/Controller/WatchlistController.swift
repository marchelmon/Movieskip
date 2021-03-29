//
//  WatchlistController.swift
//  Movieskip
//
//  Created by marchelmon on 2021-03-15.
//

import UIKit

class WatchlistController: UIViewController {
    
    //MARK: - Properties
    
    let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
        
    private lazy var movieTable = MovieTable(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 100))
    private lazy var movieCollection = MovieCollection(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 100))
    
    private let collectionIcon: UIImage? = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 40)
        let image = UIImage(systemName: "square.grid.2x2", withConfiguration: imageConfig)?.withTintColor(K.MAIN_COLOR, renderingMode: .alwaysOriginal)
        return image
    }()
    
    private let tableIcon: UIImage? = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 40)
        let image = UIImage(systemName: "star.list", withConfiguration: imageConfig)?.withTintColor(K.MAIN_COLOR, renderingMode: .alwaysOriginal)
        return image
    }()
    
    private let toggleViewModeButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(toggleViewMode), for: .touchUpInside)
        return button
    }()
    
    private let matchButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        button.setTitle("Combine watchlists", for: .normal)
        button.layer.cornerRadius = 5
        button.heightAnchor.constraint(equalToConstant: 45).isActive = true
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(goToMatchView), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieTable.delegate = self
        movieCollection.delegate = self
                
        configureUI()
        
        fetchAndConfigureMovies()
        
    }
    
    //MARK: - Actions
    
    func fetchAndConfigureMovies() {
        let watchlist = sceneDelegate.user != nil ? sceneDelegate.user!.watchlist : sceneDelegate.localUser!.watchlist
        
        if watchlist.count == sceneDelegate.userWatchlist.count {
            displayMovies()
            return
        }
        sceneDelegate.userWatchlist = []
        watchlist.forEach { movieId in
            TmdbService.fetchMovieWithDetails(withId: movieId) { movie in
                self.sceneDelegate.userWatchlist.append(movie)
                if self.sceneDelegate.userWatchlist.count == watchlist.count {
                    self.displayMovies()
                }
            }
        }
    }
    
    @objc func goToMatchView() {
        let controller = CombineWatchlistController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    @objc func handleDone() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func showTableView() {
        movieCollection.alpha = 0
        movieTable.alpha = 1

        toggleViewModeButton.setImage(collectionIcon, for: .normal)
        UserDefaults.standard.setValue(true, forKey: K.WATCHLIST_IS_TABLE)
        
    }
    
    @objc func showCollectionView() {
        movieTable.alpha = 0
        movieCollection.alpha = 1
                
        toggleViewModeButton.setImage(tableIcon, for: .normal)
        UserDefaults.standard.setValue(false, forKey: K.WATCHLIST_IS_TABLE)
    }
    
    @objc func toggleViewMode() {
        let currentIcon = toggleViewModeButton.imageView?.image
        currentIcon == tableIcon ? showTableView() : showCollectionView()
        
    }
    
    func presentMovieDetails(movie: Movie) {
        let controller = DetailsController(movie: movie)
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    //MARK: - Helpers
    
    func displayMovies() {
        movieTable.movies = sceneDelegate.userWatchlist
        movieCollection.movies = sceneDelegate.userWatchlist
                
        if UserDefaults.standard.bool(forKey: K.WATCHLIST_IS_TABLE) {
            showTableView()
        } else {
            showCollectionView()
        }
    }
    
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Watchlist"
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
                
        let stack = UIStackView(arrangedSubviews: [matchButton, toggleViewModeButton])
        stack.distribution = .fillProportionally
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 10)
                
        view.addSubview(movieTable)
        movieTable.anchor(top: stack.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 30, paddingBottom: 10, paddingRight: 30)
        
        view.addSubview(movieCollection)
        movieCollection.anchor(top: stack.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 30, paddingBottom: 10, paddingRight: 30)
        
    }
    
}

extension WatchlistController: MovieTableDelegate {
    
    func tablePresentMovieDetails(movie: Movie) {
        presentMovieDetails(movie: movie)
    }
    
}

extension WatchlistController: MovieCollectionDelegate {
    func collectionPresentMovieDetails(movie: Movie) {
        presentMovieDetails(movie: movie)
    }
}
