//
//  DetailsViewController.swift
//  Movieskip
//
//  Created by marchelmon on 2021-02-20.
//

import UIKit

class DetailsController: UIViewController {
    
    //MARK: - Properties
    
    private var movie: Movie
    private lazy var detailsView = DetailsHeader(movie: movie)
    
    //MARK: - Lifecycle
    
    init(movie: Movie) {
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        loadDetails()
        
    }
    
    
    //MARK: - Actions
    
    @objc func handleDone() {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        navigationItem.title = "Movie details"
        navigationController?.navigationBar.tintColor = .black
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
       
        view.addSubview(detailsView)
        
        detailsView.fillSuperview()
        
//        tableView.tableHeaderView = headerView
//        tableView.backgroundColor = .systemGroupedBackground
//        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 500)
    }
    
    func loadDetails() {
    }
    
}
