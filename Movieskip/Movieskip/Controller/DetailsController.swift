//
//  DetailsViewController.swift
//  Movieskip
//
//  Created by marchelmon on 2021-02-20.
//

import UIKit

protocol DetailsControllerDelegate: class {
    
}


class DetailsController: UITableViewController {
    
    //MARK: - Properties
    
    private var movie: Movie
    private lazy var headerView = DetailsHeader(movie: movie)
    
    //MARK: - Lifecycle
    
    init(movie: Movie) {
        self.movie = movie
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
    }
    
    @objc func handleSave() {
        
    }
    
    @objc func handleCancel() {
        
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        navigationItem.title = "Movie details"
        navigationController?.navigationBar.tintColor = .black
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleSave))
       
        tableView.separatorStyle = .none
        tableView.tableHeaderView = headerView
        tableView.backgroundColor = .systemGroupedBackground
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 300)


    }
    
}

//MARK: - TABLE VIEW DATA SOURCE AND DELEGATE

extension DetailsController {
        
}
