//
//  WatchlistController.swift
//  Movieskip
//
//  Created by marchelmon on 2021-03-15.
//

import UIKit

class WatchlistController: UIViewController {
    
    let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
    
    //private let movieCollection = MovieCollection()
    //private let movieTable = MovieTable()
    
    private let collectionButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "square.grid.2x2")?.withTintColor(MAIN_COLOR, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let tableButton: UIButton = {
        let button = UIButton()
        
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()

    }
    
    //MARK: - Actions
    
    @objc func handleDone() {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        navigationItem.title = "Watchlist"
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
        
    }
    
    
}
