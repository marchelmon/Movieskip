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
    
    private let matchButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        button.setTitle("Combine watchlists", for: .normal)
        button.layer.cornerRadius = 5
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private lazy var movieTable = MovieTable(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 100))
    private lazy var mCollection = MovieCollection(
        frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 100),
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    private lazy var movieCollection: MovieCollection = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 100)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collection = MovieCollection(frame: frame, collectionViewLayout: UICollectionViewLayout())
        return collection
    } ()
    
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
        
        view.addSubview(matchButton)
        matchButton.anchor(top: tableButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 30, paddingRight: 30)
        
        let movieTable = MovieCollection(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 100))
        
        view.addSubview(movieTable)
        movieTable.anchor(top: matchButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: 30, paddingRight: 30, height: 500)
        
        view.addSubview(movieCollection)
        movieCollection.anchor(top: matchButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: 30, paddingRight: 30, height: 500)
    }
    
    
}
