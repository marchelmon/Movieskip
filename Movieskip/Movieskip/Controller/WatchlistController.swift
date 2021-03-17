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
    
    private var watchlist = [Movie]()
    
    private lazy var movieTable = MovieTable()
    private lazy var movieCollection: MovieCollection = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 100)
        let layout = UICollectionViewLayout()
        
        let cv = MovieCollection(frame: frame, collectionViewLayout: layout)
        return cv
    }()
    
    private let collectionButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 35)
        let image = UIImage(systemName: "square.grid.2x2", withConfiguration: imageConfig)?.withTintColor(MAIN_COLOR, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(showCollectionView), for: .touchUpInside)
        return button
    }()
    
    private let tableButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 35)
        let image = UIImage(systemName: "list.dash", withConfiguration: imageConfig)?.withTintColor(MAIN_COLOR, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(showTableView), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchMoviesInWatchlist()

    }
    
    //MARK: - Actions
    
    func fetchMoviesInWatchlist() {
        guard let user = sceneDelegate.user else { return }         //TODO: error to user

        user.watchlist.forEach { movieId in
            TmdbService.fetchMovieWithDetails(withId: movieId) { movie in
                self.watchlist.append(movie)
                if self.watchlist.count == user.watchlist.count {
                    self.showTableView()
                }
            }
        }
    }
    
    @objc func handleDone() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func showTableView() {
        movieCollection.alpha = 0
        movieTable.alpha = 1
        
        movieTable.movies = watchlist
    }
    
    @objc func showCollectionView() {
        movieTable.alpha = 0
        movieCollection.alpha = 1
        
        movieCollection.movies = watchlist
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Watchlist"
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
                
        
        view.addSubview(tableButton)
        tableButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor, paddingTop: 20, paddingRight: 20)
        
        view.addSubview(collectionButton)
        collectionButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: tableButton.leftAnchor, paddingTop: 20, paddingRight: 20)
        
        view.addSubview(movieTable)
        movieTable.anchor(top: tableButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 50, paddingLeft: 30, paddingRight: 30, height: 500)
        
        view.addSubview(movieCollection)
        movieCollection.anchor(top: tableButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 50, paddingLeft: 30, paddingRight: 30, height: 500)
    }
    
    
}
