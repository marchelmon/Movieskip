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
    private lazy var movieCollection = MovieCollection(
        frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 100),
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    private let collectionIcon: UIImage? = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 35)
        let image = UIImage(systemName: "square.grid.2x2", withConfiguration: imageConfig)?.withTintColor(MAIN_COLOR, renderingMode: .alwaysOriginal)
        return image
    }()
    
    private let tableIcon: UIImage? = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 35)
        let image = UIImage(systemName: "list.dash", withConfiguration: imageConfig)?.withTintColor(MAIN_COLOR, renderingMode: .alwaysOriginal)
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
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieTable.delegate = self
                
        configureUI()
        sceneDelegate.userWatchlist.count == 0 ? fetchMoviesInWatchlist() : configureAndDisplayMovies()
        
    }
    
    //MARK: - Actions
    
    func fetchMoviesInWatchlist() {
        guard let user = sceneDelegate.user else { return }         //TODO: error to user
        print("Fetching movies")
        user.watchlist.forEach { movieId in
            TmdbService.fetchMovieWithDetails(withId: movieId) { movie in
                self.sceneDelegate.userWatchlist.append(movie)
                if self.sceneDelegate.userWatchlist.count == user.watchlist.count {
                    self.configureAndDisplayMovies()
                }
            }
        }
    }
    
    @objc func handleDone() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func showTableView() {
        movieCollection.alpha = 0
        movieTable.alpha = 1

        toggleViewModeButton.setImage(collectionIcon, for: .normal)
        UserDefaults.standard.setValue(true, forKey: WATCHLIST_IS_TABLE)
        
    }
    
    @objc func showCollectionView() {
        movieTable.alpha = 0
        movieCollection.alpha = 1
                
        toggleViewModeButton.setImage(tableIcon, for: .normal)
        UserDefaults.standard.setValue(false, forKey: WATCHLIST_IS_TABLE)
    }
    
    @objc func toggleViewMode() {
        let currentIcon = toggleViewModeButton.imageView?.image
        currentIcon == tableIcon ? showTableView() : showCollectionView()
        
    }
    
    //MARK: - Helpers
    
    func configureAndDisplayMovies() {
        movieTable.movies = sceneDelegate.userWatchlist
        movieCollection.movies = sceneDelegate.userWatchlist
                
        if UserDefaults.standard.bool(forKey: WATCHLIST_IS_TABLE) {
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
                
        
        view.addSubview(toggleViewModeButton)
        toggleViewModeButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor, paddingTop: 20, paddingRight: 20)
        
        view.addSubview(matchButton)
        matchButton.anchor(top: toggleViewModeButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 30, paddingLeft: 30, paddingRight: 30)
                
        view.addSubview(movieTable)
        movieTable.anchor(top: matchButton.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: 30, paddingBottom: 30, paddingRight: 30)
        
        view.addSubview(movieCollection)
        movieCollection.anchor(top: matchButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: 30, paddingRight: 30, height: 500)
    }
    
    
}

extension WatchlistController: MovieTableDelegate {
    
    func presentMovieDetails(movie: Movie) {
        let controller = DetailsController(movie: movie)
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
}
